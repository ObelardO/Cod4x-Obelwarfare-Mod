echo off

cls

Cod4PackagedModBuilder.exe -workdir %CD%\.. -toolsdir %CD%\..\..\.. -packgsc false

pause