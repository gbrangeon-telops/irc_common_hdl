function [] = Get_PatGen_Status(PG_ADD);

A_MODE                = hex2dec('00');
A_ZSIZE               = hex2dec('02');
A_XSIZE               = hex2dec('04');
A_YSIZE               = hex2dec('06');
A_TAGSIZE             = hex2dec('08');
A_DIAGSIZE            = hex2dec('0A');
A_PAYLOADSIZE         = hex2dec('0C');
A_IMAGEPAUSE          = hex2dec('0E');  
A_ROM_Z_START         = hex2dec('10');
A_ROM_INIT_INDEX      = hex2dec('12');
A_CONFIG              = hex2dec('14');    


A_CONTROL             = hex2dec('18');
A_STATUS              = hex2dec('19');
%A_DCUBE_CNT           = hex2dec('81');
%A_STATE               = hex2dec('82');

fprintf('\n******* Pattern Generator module config *********\n');
fprintf('MODE             = %d\n', WB_read32(PG_ADD + A_MODE               ));
fprintf('ZSIZE            = %d\n', WB_read32(PG_ADD + A_ZSIZE              ));
fprintf('XSIZE            = %d\n', WB_read32(PG_ADD + A_XSIZE              ));
fprintf('YSIZE            = %d\n', WB_read32(PG_ADD + A_YSIZE              ));
fprintf('TAGSIZE          = %d\n', WB_read32(PG_ADD + A_TAGSIZE            ));
fprintf('DIAGSIZE         = %d\n', WB_read32(PG_ADD + A_DIAGSIZE           ));
fprintf('PAYLOADSIZE      = %d\n', WB_read32(PG_ADD + A_PAYLOADSIZE        ));
fprintf('IMAGEPAUSE       = %d\n', WB_read32(PG_ADD + A_IMAGEPAUSE         ));
fprintf('ROM_Z_START      = %d\n', WB_read32(PG_ADD + A_ROM_Z_START        ));
fprintf('ROM_INIT_INDEX   = %d\n', WB_read32(PG_ADD + A_ROM_INIT_INDEX     ));

fprintf('RUN              = %d\n', WB_read16(PG_ADD + A_CONTROL            ));
fprintf('DONE             = %d\n', WB_read16(PG_ADD + A_STATUS             ));
config = WB_read32(PG_ADD + A_CONFIG);

%fprintf('CameraMode          = %d\n', bitand(config, 1)); 
%fprintf('EN_CRC              = %d\n', bitand(config, 2)/2); 
%fprintf('DCUBE_CNT           = %d\n', WB_read16(PG_ADD + A_DCUBE_CNT          ));
%state = WB_read16(PG_ADD + A_STATE);
%switch state
%   case 1,    fprintf('State               = Idle\n');
%   case 2,    fprintf('State               = Init\n');
%   case 4,    fprintf('State               = SendImgHeader\n');
%   case 8,    fprintf('State               = SendPayload\n'); 
%   case 16,    fprintf('State               = Pause\n');      
%   otherwise, fprintf('State               = Unknown!!!\n');
%end