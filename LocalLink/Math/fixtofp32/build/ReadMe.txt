To generate the ngc netlists and the vhm poste synthesis simulation files do the followings:
open DOS command windows
cd  to this directory, t.e: "D:\Telops\Common_HDL\LocalLink\Math\fixtofp32\build" and execute the following command:
call make_all.bat
Wait until the command is done and then you can examine the log.txt file in the work directory of each component,
example: \fixtofp32_9s\work\log.txt.

To generate only one component, cd to its corresponding directory and call the make_ngc.bat file from there, example: at DOS cmd windows do
cd  fixtofp32_9s
call ./scripts/make_ngc.bat

The make_clean.bat batch file will delet only the work directory of each component, this is the work dir of ISE.
