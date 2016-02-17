<?xml version="1.0" encoding="UTF-8"?>
<CONFIG>
 <Version>
  <version number="3"/>
 </Version>
 <Compilation>
  <folder name="$ALDEC\mingw\include"/>
  <folder name="$ALDEC\SystemC\interface"/>
  <folder name="$dsn\src\SystemC"/>
  <folder name="D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\Driver"/>
  <folder name="$dsn\src\SystemC\include"/>
  <file name="$dsn\src\SystemC\uc2_transactor.cpp"/>
  <file name="$dsn\src\SystemC\uc2_gpio.cpp"/>
  <file name="$dsn\src\SystemC\uc2_model.cpp"/>
  <file name="$dsn\src\SystemC\utils.cpp"/>
  <file name="D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\Driver\PatGen.cpp"/>
  <file name="$dsn\src\SystemC\vp30_ctrl.cpp"/>
  <options name="-fpermissive"/>
  <options name="-ggdb"/>
  <options name="-shared"/>
  <options name="-Wno-deprecated"/>
  <options name="-fno-strict-aliasing"/>
  <options name="-fno-gcse-lm"/>
  <options name="-D__int64=&quot;long"/>
  <options name="long"/>
  <options name="int&quot;"/>
  <options name="-DSIM"/>
 </Compilation>
 <Linker>
  <target name="$dsn\src\SystemC\uc2_model.dll"/>
  <library name="$ALDEC\SystemC\interface\systemc.def"/>
  <library name="$ALDEC\SystemC\lib\SystemC.a"/>
  <library name="$ALDEC\mingw\lib\libstdc++.a"/>
  <options name="-shared"/>
  <folder name="$ALDEC\SystemC\lib"/>
  <folder name="$ALDEC\mingw\lib"/>
 </Linker>
 <Type>
  <DesignType name="SYSTEMC"/>
 </Type>
 <Additional>
  <AddLibraryToDesign name="false"/>
  <AddModulesToLibrary name="true"/>
 </Additional>
</CONFIG>
