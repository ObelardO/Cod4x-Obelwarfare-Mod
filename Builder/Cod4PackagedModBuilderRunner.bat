echo off

cls

Cod4PackagedModBuilder.exe -workdir %CD%\.. -toolsdir %CD%\..\..\.. -iwdprefix z_lgc_ -packgsc false

pause