function [] = Get_HeaderX_Status(HX_ADD);

A_DP_CONFIG         = hex2dec('0000');
A_HEADER            = hex2dec('0030');
A_FOOTER            = hex2dec('0040');
                   
A_SW                = hex2dec('0080');
A_VALIDCONFIG       = hex2dec('002E');
A_CONFIGCOLLISION   = hex2dec('002F');
                  
A_HEADER_VALID      = hex2dec('003E');
A_FOOTER_VALID      = hex2dec('004E');


HX_SW_PROCESS       = 0;
HX_SW_PASSTHRU      = 1;
HX_SW_BLOCK         = 3;


A_HEAD_Code_Rev       = hex2dec('03'); 
A_HEAD_Status         = hex2dec('04'); 
A_HEAD_Xmin           = hex2dec('06'); 
A_HEAD_Ymin           = hex2dec('07'); 
A_HEAD_StartTimeStamp = hex2dec('08'); 

                     
A_FOOT_Write_No       = hex2dec('03');
A_FOOT_Trig_No        = hex2dec('05');
A_FOOT_Status         = hex2dec('07');
A_FOOT_ZPDPosition    = hex2dec('09');
A_FOOT_ZPDPeakVal     = hex2dec('0B');
A_FOOT_EndTimeStamp   = hex2dec('0C');

HEAD_ADD              = HX_ADD + A_HEADER;
FOOT_ADD              = HX_ADD + A_FOOTER;   

fprintf('\n******* ROIC DCube Header *********\n');
fprintf('HEADER_VALID        = %d\n', WB_read16(HX_ADD + A_HEADER_VALID));

HEAD1 = WB_read16(HEAD_ADD + 1);
HEAD2 = WB_read16(HEAD_ADD + 2);
HEAD_Direction = bitget(HEAD1, 8);
HEAD_Acq_Number = bitand(hex2dec('007F'), HEAD1)*65536 + HEAD2;
fprintf('HEAD_Direction      = %d\n', HEAD_Direction);                                 
fprintf('HEAD_Acq_Number     = %d\n', HEAD_Acq_Number);                                 
fprintf('HEAD_Code_Rev       = 0x%X\n', WB_read16(HEAD_ADD + A_HEAD_Code_Rev       ));
fprintf('HEAD_Status         = %d\n', WB_read32(HEAD_ADD + A_HEAD_Status         ));
fprintf('HEAD_Xmin           = %d\n', WB_read16(HEAD_ADD + A_HEAD_Xmin           ));
fprintf('HEAD_Ymin           = %d\n', WB_read16(HEAD_ADD + A_HEAD_Ymin           ));
fprintf('HEAD_StartTimeStamp = 0x%X\n', WB_read32(HEAD_ADD + A_HEAD_StartTimeStamp ));

fprintf('\n******* ROIC DCube Footer *********\n');
fprintf('FOOTER_VALID        = %d\n', WB_read16(HX_ADD + A_FOOTER_VALID));
FOOT1 = WB_read16(FOOT_ADD + 1);                               
FOOT2 = WB_read16(FOOT_ADD + 2);                               
FOOT_Direction = bitget(FOOT1, 8);                             
FOOT_Acq_Number = bitand(hex2dec('007F'), FOOT1)*65536 + FOOT2;
fprintf('FOOT_Direction      = %d\n', FOOT_Direction     );                                 
fprintf('FOOT_Acq_Number     = %d\n', FOOT_Acq_Number    );                                 
fprintf('FOOT_Write_No       = %d\n', WB_read32(FOOT_ADD + A_FOOT_Write_No      ));                                 
fprintf('FOOT_Trig_No        = %d\n', WB_read32(FOOT_ADD + A_FOOT_Trig_No       )); 
fprintf('FOOT_Status         = %d\n', WB_read32(FOOT_ADD + A_FOOT_Status        )); 
fprintf('FOOT_ZPDPosition    = %d\n', WB_read32(FOOT_ADD + A_FOOT_ZPDPosition   )); 
fprintf('FOOT_ZPDPeakVal     = %d\n', WB_read16(FOOT_ADD + A_FOOT_ZPDPeakVal    )); 
fprintf('FOOT_EndTimeStamp   = %d\n', WB_read32(FOOT_ADD + A_FOOT_EndTimeStamp     )); 

%SW = WB_read16(HX_ADD + A_SW);
%if (SW == HX_SW_PROCESS)
%   fprintf('\nHeader Extractor Switch = PROCESS\n');
%elseif (SW == HX_SW_PASSTHRU)
%   fprintf('\nHeader Extractor Switch = PASSTHRU\n');
%elseif (SW == HX_SW_BLOCK)
%   fprintf('\nHeader Extractor Switch = BLOCK\n');
%else
%   fprintf('\nHeader Extractor Switch = 0x%X = Invalid!!\n', SW);
%end


