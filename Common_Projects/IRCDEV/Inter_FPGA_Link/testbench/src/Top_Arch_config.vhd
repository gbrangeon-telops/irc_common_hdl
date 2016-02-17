


configuration Config_SyncSerialLink of SyncSerialLinkLoop_tb is
   for SCH                        
            for FILE1 : ll_file_input_8
               use entity common_hdl.ll_file_input_8(ASCII);
            end for; 
            for FILEOUT1 : ll_file_output_8
               use entity common_hdl.ll_file_output_8(ASCII);
            end for;                     
      --                for FILEOUT1 : ll_file_output_8
      --                           use entity ll_file_output_8(ASCII);
      --                end for;             
      
   end for;
end Config_SyncSerialLink;
