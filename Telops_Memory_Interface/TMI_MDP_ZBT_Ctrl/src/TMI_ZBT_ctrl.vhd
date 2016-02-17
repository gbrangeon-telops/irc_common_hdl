-------------------------------------------------------------------------------
--
-- Title       : TMI_ZBT_ctrl
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-------------------------------------------------------------------------------
-- Description : 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   
library Common_HDL;     
use Common_HDL.all;

-- translate_off 
library VIRTEX4;
use IEEE.vital_timing.all;
-- translate_on 


entity TMI_ZBT_ctrl is
   generic(
      Gen_IDLY_CTRL : boolean := false;
      ALEN : INTEGER := 21;
      DLEN : INTEGER := 32;
      BUSY_GENERATE : boolean := false;	-- Generate Pseudo-random TMI_BUSY signal  
      random_seed : std_logic_vector(3 downto 0) := x"1"; -- --Pseudo-random generator seed
      BUSY_DURATION : integer := 20  -- Duration of TMI_BUSY signal in clock cycles
      );
   port(
      --------------------------------
      -- IDELAY stuff (CLK200 domain)
      --------------------------------      
      DLY_CTRL_RDY   : out std_logic;      
      DLY_EN         : in std_logic;
      DLY_INC        : in std_logic;
      --------------------------------
      -- IDELAY stuff (CLK domain)
      --------------------------------         
      EXTRA_CYCLE    : in std_logic;
      --------------------------------
      -- TMI interface (CLK domain)
      --------------------------------
      TMI_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI_RNW       : in  std_logic;
      TMI_DVAL      : in  std_logic;
      TMI_BUSY      : out std_logic;
      TMI_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI_RD_DVAL   : out std_logic; 
      TMI_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI_IDLE      : out std_logic;
      TMI_ERROR     : out std_logic;      
      --------------------------------
      -- ZBT interface (CLK domain)
      --------------------------------
      ZBT_ADD        : out std_logic_vector(ALEN-1 downto 0);
      ZBT_CE_N       : out std_logic;
      ZBT_OE_N       : out std_logic;
      ZBT_WE_N       : out std_logic;
      ZBT_ADV_LD_N   : out std_logic;
      ZBT_MODE       : out std_logic;
      ZBT_CKE_N      : out std_logic;
      ZBT_CE2_N      : out std_logic;
      ZBT_CE2        : out std_logic;
      ZBT_ZZ         : out std_logic;
      ZBT_BWA_N      : out std_logic;
      ZBT_BWB_N      : out std_logic;
      ZBT_BWC_N      : out std_logic;
      ZBT_BWD_N      : out std_logic;
      ZBT_DATA       : inout std_logic_vector(DLEN-1 downto 0);
      --------------------------------
      -- Other
      --------------------------------      
      ARESET         : in std_logic;
      CLK            : in std_logic;
      CLK200         : in std_logic    -- For IDELAY stuff
      );
end TMI_ZBT_ctrl;


architecture RTL of TMI_ZBT_ctrl is
   
   component OFD
      port (
         C : in std_logic;
         D : in std_logic;
         Q : out std_logic
         );
   end component;
   
   component idelay
      generic(
         IOBDELAY_TYPE : STRING := "DEFAULT";
         IOBDELAY_VALUE : INTEGER := 0);
      port(
         O : out std_ulogic;
         C : in std_ulogic;
         CE : in std_ulogic;
         I : in std_ulogic;
         INC : in std_ulogic;
         RST : in std_ulogic);
   end component;
   
   component idelayctrl
      port(
         RDY : out std_ulogic;
         REFCLK : in std_ulogic;
         RST : in std_ulogic);
   end component; 
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   type data_delay_type is array (2 downto 0) of std_logic_vector(DLEN-1 downto 0);
   
   signal sreset : std_logic;
   
   signal zbt_data_delayed : std_logic_vector(DLEN-1 downto 0);    
   signal TMI_WR_DATA_r2 : std_logic_vector(DLEN-1 downto 0);    
   signal zbt_data_oe : std_logic_vector(DLEN-1 downto 0);  
   
   signal ZBT_WE_Ni2 : std_logic;
   
   signal valid_read_cmd : std_logic :='0';
   signal data_valid_out : std_logic :='0';
   signal we_n_reg_d : std_logic;
   signal zbt_wr_r1 : std_logic;
   signal busy_i : std_logic := '1';
   signal dval_i : std_logic;
   
   signal extra_cycle_r1 : std_logic;
   
   signal tmi_busy_s	: std_logic;
   signal lfsr     : std_logic_vector(15 downto 0) := (others => '0');   -- To avoid X in simulation
   signal lfsr_in  : std_logic;
   signal busy_cnt : unsigned(7 downto 0);
   
   attribute equivalent_register_removal : string;      
   attribute equivalent_register_removal of TMI_WR_DATA_r2             : signal is "NO"; 
   attribute equivalent_register_removal of TMI_RD_DATA                 : signal is "NO"; 
   attribute equivalent_register_removal of zbt_data_oe             : signal is "NO"; -- 
   attribute equivalent_register_removal of data_valid_out          : signal is "NO"; 
   
   attribute iob : string;
   attribute iob of TMI_WR_DATA_r2 : signal is "force";
   attribute iob of TMI_RD_DATA    : signal is "force";
   attribute iob of zbt_data_oe    : signal is "force";
   attribute iob of data_valid_out : signal is "force";
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   TMI_ERROR <= '0';
   
   -----------------------------------------------------------------------------------
   -- IDELAY
   -----------------------------------------------------------------------------------
   gen_dly : for i in (DLEN-1) downto 0 generate
      
      dly : idelay
      generic map(
         IOBDELAY_TYPE => "VARIABLE",
         IOBDELAY_VALUE => 0
         )
      port map(
         O => zbt_data_delayed(i),
         C => CLK200,
         CE => DLY_EN,
         I => ZBT_DATA(i),
         INC => DLY_INC,
         RST => ARESET
         );
      
   end generate;
   
   gen_ctrl : if Gen_IDLY_CTRL generate
      dly_ctrl : idelayctrl
      port map(
         RDY => DLY_CTRL_RDY,
         REFCLK => CLK200,
         RST => ARESET
         );
   end generate;
   
   gen_ctrl_false : if Gen_IDLY_CTRL = FALSE generate
      DLY_CTRL_RDY <= '0';
   end generate;
   
   dval_i <= TMI_DVAL and not busy_i;
   
   -----------------------------------------------------------------------------------
   --          PARTIE LECTURE: data valide 2 VALIDES CLKS apres la commande de lecture
   -----------------------------------------------------------------------------------	
   -- read transaction
   valid_read_cmd <= TMI_RNW and dval_i; 
   
   idle_proc: process(CLK)
      variable counter : unsigned(2 downto 0) := (others => '0');
      constant latency : integer := 4;
   begin
      if rising_edge(CLK) then
         if sreset = '1' then
            TMI_IDLE <= '1';
            counter := (others => '0');
         else
            if counter = to_unsigned(0,counter'length) then 
               TMI_IDLE <= '1';
            else
               TMI_IDLE <= '0';
               counter := counter - 1;
            end if;
            
            if TMI_DVAL = '1' then
               TMI_IDLE <= '0';
               counter := to_unsigned(latency-1,counter'length);
            end if;
         end if;
      end if;
   end process;
   
   read_proc:  process(CLK)
      variable valid_read_cmd_in  : std_logic_vector(2 downto 0) := (others =>'0');
      
   begin 
      if rising_edge(CLK)  then 
         --extra_cycle_r1 <= EXTRA_CYCLE;
         if EXTRA_CYCLE = '0' then
            data_valid_out <= valid_read_cmd_in(1);
         else
            data_valid_out <= valid_read_cmd_in(2);
         end if;
         
         valid_read_cmd_in(2) := valid_read_cmd_in(1);                 
         valid_read_cmd_in(1) := valid_read_cmd_in(0);                 
         valid_read_cmd_in(0) := valid_read_cmd;
      end if;     
   end process;  
   
   -----------------------------------------------------------------------------------
   --          PARTIE ECRITURE: 
   -----------------------------------------------------------------------------------
   write_proc:  process(CLK)
      variable data_delay : data_delay_type;
   begin 
      if rising_edge(CLK) then
         TMI_WR_DATA_r2        <=    data_delay(1);        -- Donnee sortant 2 CLKS apres l'adresse  
         data_delay(2)      :=	 data_delay(1);
         data_delay(1)      :=    data_delay(0);
         data_delay(0)      :=    TMI_WR_DATA;
      end if;
   end process;
   
   -----------------------------------------------------------------------------------
   --           SIGNAUX DE CONTROLE CLOCKÉS DE LA ZBT 
   -----------------------------------------------------------------------------------
   
   -- Always enable the ZBT ram
   ZBT_CE_n  <=  '0';
   ZBT_CE2_n <=  '0';
   ZBT_CE2   <=  '1'; 
   
   gen_add_out_reg : for n in 0 to ALEN-1 generate
      REG : OFD
      port map(
         C => CLK,
         D => TMI_ADD(n),
         Q => ZBT_ADD(n)
         );     
   end generate;  
   
   we_n_reg_d <= TMI_RNW or not dval_i or ARESET;
   we_n_reg : OFD
   port map(
      C => CLK,
      D => we_n_reg_d,
      Q => ZBT_WE_N
      );
   
   OUTPUT_GRP:  process(CLK,ARESET)  
   begin 
      
      if rising_edge(CLK) then 
         ZBT_ZZ        <=   '0';
         ZBT_CKE_n     <=   '0'; 
         ZBT_ADV_LD_N  <=   '0';
         ZBT_MODE      <=   '0'; 
         ZBT_WE_Ni2    <=   TMI_RNW or not dval_i;
      end if;
      
      if ARESET ='1' then                    -- aucune action possible
         ZBT_ZZ       <= '1';
         ZBT_CKE_n    <= '1';
         ZBT_ADV_LD_N <= '0';
         ZBT_MODE     <= '0';
         ZBT_BWA_N    <= '0';
         ZBT_BWB_N    <= '0';
         ZBT_BWC_N    <= '0';
         ZBT_BWD_N    <= '0';
         ZBT_WE_Ni2   <= '1';
      end if;
   end process;  
   ZBT_OE_N  <='0';
   
   --TMI_RD_DATA <= zbt_data_delayed  ;    -- donnees lues envoyées vers l'application cliente 
   --   TMI_RD_DVAL <= data_valid_out;-- dit à l'application cliente que la donnée est prête (valide)   
   
   Readout: process(CLK)
   begin
      if rising_edge(CLK)then 
         if sreset='1' then
            TMI_RD_DATA     <= (others =>'0');
            TMI_RD_DVAL  <=   '0';             
         else
            TMI_RD_DATA           <= zbt_data_delayed  ;    -- donnees lues envoyées vers l'application cliente   
            TMI_RD_DVAL        <= data_valid_out;-- dit à l'application cliente que la donnée est prête (valide)
         end if;
      end if;
   end process;  
   
   oe_process : process(CLK)
   begin 
      if rising_edge(CLK) then       
         zbt_wr_r1 <= not ZBT_WE_Ni2;
         gen_oe : for i in DLEN-1 downto 0 loop
            zbt_data_oe(i) <= zbt_wr_r1;
         end loop;          
      end if;           
   end process;
   
   -----------------------------------------------------------------------------------
   --         CONTROL DU BUS TRI-STATE INOUT
   -----------------------------------------------------------------------------------
   gen : for i in DLEN-1 downto 0 generate
      ZBT_DATA(i)         <=    TMI_WR_DATA_r2(i) when zbt_data_oe(i) = '1' else 'Z';
   end generate;
   
   BusyEmulate_gen0:if BUSY_GENERATE= false generate
      ------------------------------------------------
      -- Process to handel TMI_BUSY in the case it's
      -- not emulated/used 
      ------------------------------------------------   		
      process (CLK)
      begin
         if rising_edge(CLK) then
            if sreset = '1' then
               busy_i <= '1';   					
            else   					
               busy_i <= '0';   					
            end if;
         end if;
      end process;   				
   end generate BusyEmulate_gen0;
   
   BusyEmulate_gen1:if BUSY_GENERATE= true generate 
      
      ------------------------------------------------
      -- Process for pseudo-random generator
      ------------------------------------------------
      lfsr_in <= lfsr(1) xor lfsr(2) xor lfsr(4) xor lfsr(15);
      process(CLK)
      begin
         if rising_edge(CLK) then
            lfsr(0) <= lfsr_in;
            lfsr(15 downto 2) <= lfsr(14 downto 1);
            
            if sreset = '1' then
               lfsr(0) <= random_seed(0); -- We need at least one '1' in the LFSR to activate it.
               lfsr(2) <= random_seed(1);
               lfsr(3) <= random_seed(2); 
               lfsr(5) <= random_seed(3);
            else
               lfsr(1) <= lfsr(0);   
            end if;
         end if;
      end process;			
      
      ------------------------------------------------
      -- Process to emulate a memory BUSY (TMI_BUSY)
      -- signal.
      ------------------------------------------------
      process(CLK)
      begin
         if rising_edge(CLK) then
            if sreset = '1' then
               tmi_busy_s <= '1'; -- Busy at reset time					
               busy_cnt <= (others =>'0');
            else					
               -- Count the busy signal duration				
               if (tmi_busy_s = '1') then
                  busy_cnt <= busy_cnt + 1;
                  if busy_cnt = to_unsigned(BUSY_DURATION-1,8) then	-- Clear busy signal
                     busy_cnt <= (others =>'0');
                     tmi_busy_s <= '0';
                  end if;					
               elsif lfsr(7) = '1' then -- Randomly set busy signal						
                  tmi_busy_s <= '1';	
               end if;
            end if;
         end if;
      end process;
      busy_i <= tmi_busy_s;		
   end generate BusyEmulate_gen1;
   
   TMI_BUSY <= busy_i;
   
end RTL;





