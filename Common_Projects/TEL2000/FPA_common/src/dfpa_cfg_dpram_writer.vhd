------------------------------------------------------------------
--!   @file : dfpa_cfg_dpram_writer
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tel2000.all;

entity dfpa_cfg_dpram_writer is
   port(
      ARESET           : in std_logic;
      MB_CLK           : in std_logic;
      CLK              : in std_logic;
      
      -- cfg serielle en provevance de MB et INT (bus sur MB_CLK)
      MB_SER_CFG       : in t_axi4_stream_mosi16;
      EXP_SER_CFG      : in t_axi4_stream_mosi16;
      
      -- config MB à ecrire en RAM (bus sur MB_CLK)
      MB_CFG_WR        : out std_logic;
      MB_CFG_ADD       : out std_logic_vector(10 downto 0);
      MB_CFG_DATA      : out std_logic_vector(7 downto 0);
      
      -- config INT à ecrire en RAM (bus sur CLK)
      EXP_CFG_WR       : out std_logic;
      EXP_CFG_ADD      : out std_logic_vector(10 downto 0);
      EXP_CFG_DATA     : out std_logic_vector(7 downto 0)
      );
end dfpa_cfg_dpram_writer;



architecture rtl of dfpa_cfg_dpram_writer is
   
   
   component fwft_afifo_w32_d16
      
      port (
         rst         : in std_logic;
         wr_clk      : in std_logic;
         rd_clk      : in std_logic;
         din         : in std_logic_vector(31 downto 0);
         wr_en       : in std_logic;
         rd_en       : in std_logic;
         dout        : out std_logic_vector(31 downto 0);
         full        : out std_logic;
         overflow    : out std_logic;
         empty       : out std_logic;
         valid       : out std_logic;
         wr_rst_busy : out std_logic;
         rd_rst_busy : out std_logic
         );
   end component;
   
   signal fifo_din     : std_logic_vector(31 downto 0) := (others => '0');  
   signal fifo_dout    : std_logic_vector(31 downto 0);
   signal fifo_wr_en   : std_logic;
   signal fifo_rd_en   : std_logic;
   signal fifo_dval    : std_logic;
   
begin
   
   
   --------------------------------------------------
   -- MB SERIAL CFG ecrite en RAM
   --------------------------------------------------
   MB_CFG_ADD  <= "000" & MB_SER_CFG.TDATA(15 downto 8);
   MB_CFG_DATA <= MB_SER_CFG.TDATA(7 downto 0); 
   MB_CFG_WR   <= MB_SER_CFG.TVALID;   
   
   --------------------------------------------------
   -- INT SERIAL CFG ecrite en RAM
   --------------------------------------------------
   EXP_CFG_ADD  <= "000" & fifo_dout(15 downto 8);
   EXP_CFG_DATA <= fifo_dout(7 downto 0); 
   EXP_CFG_WR   <= fifo_dval;   
   
   --------------------------------------------------
   -- changement d'horloge pour INT SERIAL CFG
   --------------------------------------------------
   fifo_din(15 downto 0) <= EXP_SER_CFG.TDATA(15 downto 0); -- TDATA(15 downto 8) -> adresse, TDATA(7 downto 0) -> byte pour la ram
   fifo_wr_en            <= EXP_SER_CFG.TVALID;
   
   
   U2 : fwft_afifo_w32_d16
   
   port map (      
      rst         => ARESET,
      wr_clk      => MB_CLK,
      rd_clk      => CLK,
      din         => fifo_din,
      wr_en       => fifo_wr_en,
      rd_en       => fifo_dval,
      dout        => fifo_dout,
      full        => open,
      overflow    => open,
      empty       => open,
      valid       => fifo_dval,
      wr_rst_busy => open,
      rd_rst_busy => open
      );
   
   
end rtl;
