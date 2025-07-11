REM //******************************************************************************
REM // Call of Duty 4: Modern Warfare
REM //******************************************************************************
REM // Mod      : The OpenWarfare Project... An Open Source Mod for COD4:MW!
REM // Website  : http://openwarfaremod.com/
REM //******************************************************************************

@echo off
set COMPILEDIR=%CD%
set color=0E
color %color%

:START
cls
echo.
echo.  _____                  _    _             __
echo. ^|  _  ^|                ^| ^|  ^| ^|           / _^|
echo. ^| ^| ^| ^|_ __   ___ _ __ ^| ^|  ^| ^| __ _ _ __^| ^|_ __ _ _ __ ___
echo. ^| ^| ^| ^| '_ \ / _ \ '_ \^| ^|/\^| ^|/ _` ^| '__^|  _/ _` ^| '__/ _ \
echo. \ \_/ / ^|_) ^|  __/ ^| ^| \  /\  / (_^| ^| ^|  ^| ^|^| (_^| ^| ^| ^|  __/
echo.  \___/^| .__/ \___^|_^| ^|_^|\/  \/ \__,_^|_^|  ^|_^| \__,_^|_^|  \___^|
echo.       ^| ^|               We don't make the game you play.
echo.       ^|_^|                 We make the game you play BETTER.
echo.
echo.            Website: http://openwarfaremod.com/

:MAKEOPTIONS
echo _________________________________________________________________
echo.
echo  Please select an option:
echo    1. Build everything (might take longer)
echo    2. Build assets .IWD files
echo    3. Build ruleset .IWD file
echo    4. Build mod.ff
echo.
echo    0. Exit
echo.
set /p make_option=:
set make_option=%make_option:~0,1%
if "%make_option%"=="1" goto CHOOSE_LANG
if "%make_option%"=="2" goto MAKE_OPENWARFARE_IWD
if "%make_option%"=="3" goto MAKE_RULES_IWD
if "%make_option%"=="4" goto CHOOSE_LANG
if "%make_option%"=="0" goto FINAL
goto START



:CHOOSE_LANG
echo _________________________________________________________________
echo.
echo  Please choose the language you would like to compile:
echo    1. English
echo    2. French
echo    3. German
echo    4. Italian
echo    5. Portuguese
echo    6. Russian
echo    7. Spanish
echo.
echo    0. Back
echo.
set /p lang_chosen=:
set lang_chosen=%lang_chosen:~0,1%
REM if "%lang_chosen%"=="1" goto LANGCZ
if "%lang_chosen%"=="1" goto LANGEN
if "%lang_chosen%"=="2" goto LANGFR
if "%lang_chosen%"=="3" goto LANGDE
if "%lang_chosen%"=="4" goto LANGIT
if "%lang_chosen%"=="5" goto LANGPT
if "%lang_chosen%"=="6" goto LANGRU
if "%lang_chosen%"=="7" goto LANGES
if "%lang_chosen%"=="0" goto START
goto CHOOSE_LANG


:LANGEN
set CLANGUAGE=English
set LANG=english
set LTARGET=english
goto COMPILE

:LANGFR
set CLANGUAGE=French
set LANG=french
set LTARGET=french
goto COMPILE

:LANGDE
set CLANGUAGE=German
set LANG=german
set LTARGET=german
goto COMPILE

:LANGIT
set CLANGUAGE=Italian
set LANG=italian
set LTARGET=italian
goto COMPILE

:LANGPT
set CLANGUAGE=Portuguese
set LANG=portuguese
set LTARGET=leet
goto COMPILE

:LANGRU
set CLANGUAGE=Russian
set LANG=russian
set LTARGET=russian
goto COMPILE

:LANGES
set CLANGUAGE=Spanish
set LANG=spanish
set LTARGET=spanish
goto COMPILE


:COMPILE
echo.

echo  Checking language directories...
if not exist ..\..\zone\%LTARGET% mkdir ..\..\zone\%LTARGET%
if not exist ..\..\zone_source\%LTARGET% xcopy ..\..\zone_source\english ..\..\zone_source\%LTARGET% /SYI > NUL

echo  OpenWarfare will be created in %CLANGUAGE%!
if "%make_option%"=="1" goto MAKE_OPENWARFARE_IWD
if "%make_option%"=="2" goto MAKE_OPENWARFARE_IWD
if "%make_option%"=="3" goto MAKE_RULES_IWD
if "%make_option%"=="4" goto MAKE_OPENWARFARE_EVENT_PATCH_IWD
goto END



:MAKE_OPENWARFARE_IWD
echo _________________________________________________________________
echo.
echo  Please choose what set of weapon files to use:
echo    1. Only fixes
echo    2. No Gun Sway
echo    3. Sniper Increased Distance
echo    4. "The Company Hub" weapons by Buster
echo.
echo    0. Back
echo.
set /p zow_option=:
set zow_option=%zow_option:~0,1%
if "%zow_option%"=="1" goto WEAPONS_FIXES
if "%zow_option%"=="2" goto WEAPONS_FIXES_NOGUNSWAY
if "%zow_option%"=="3" goto WEAPONS_FIXES_NOGUNSWAY_SNIPER
if "%zow_option%"=="4" goto WEAPONS_THECOMPANY
if "%zow_option%"=="0" goto START
goto MAKE_OPENWARFARE_IWD


:BUILD_OPENWARFARE_IWD
echo _________________________________________________________________
echo.
echo  Building z_ow_main.iwd:
echo    Deleting old z_ow_main.iwd file...
del z_ow_main.iwd > NUL
echo    Adding images...
7za a -r -tzip z_ow_main.iwd images\*.iwi > NUL
echo    Adding weapons...
7za a -r -tzip z_ow_main.iwd weapons\mp\*_mp > NUL
echo    Adding OpenWarfare standard rulesets...
7za a -r -tzip z_ow_main.iwd rulesets\openwarfare\*.gsc > NUL
7za a -r -tzip z_ow_main.iwd rulesets\leagues.gsc > NUL
echo    Adding empty mod.arena file...
7za a -r -tzip z_ow_main.iwd mod.arena > NUL
echo.
echo  Building z_ow_sounds.iwd:
echo    Deleting old z_ow_sounds.iwd file...
del z_ow_sounds.iwd > NUL
echo    Adding sounds...
7za a -r -tzip z_ow_sounds.iwd sound\*.mp3 > NUL
7za a -r -tzip z_ow_sounds.iwd sound\*.wav > NUL

if not "%eventDir%"=="none" goto BUILD_EVENT
goto FINALE_OPENWARFARE_IWD


:BUILD_EVENT
echo.
echo  Event patching:

move z_ow_main.iwd %eventDir% > NUL
move z_ow_sounds.iwd %eventDir% > NUL

cd %eventDir%

echo    Patch images...
..\7za a -r -tzip z_ow_main.iwd images\*.iwi > NUL
echo    Patch visions...
..\7za a -r -tzip z_ow_main.iwd vision\*.vision > NUL

echo    Patch sounds...
..\7za a -r -tzip z_ow_sounds.iwd sound\*.mp3 > NUL
..\7za a -r -tzip z_ow_sounds.iwd sound\*.wav > NUL

move z_ow_main.iwd ..\ > NUL
move z_ow_sounds.iwd ..\ > NUL

cd ..\

goto FINALE_OPENWARFARE_IWD


:FINALE_OPENWARFARE_IWD
echo.
echo  Assets .IWD building done:
echo    New z_ow_main.iwd file successfully built!
echo    New z_ow_sounds.iwd file successfully built!
del /f /q weapons\mp\* >NUL
rmdir weapons\mp >NUL
if "%make_option%"=="1" goto MAKE_MOD_FF
goto END


:WEAPONS_FIXES
xcopy weapons\fixes weapons\mp /SYI > NUL
goto MAKE_OPENWARFARE_EVENT_PATCH_IWD

:WEAPONS_FIXES_NOGUNSWAY
xcopy weapons\fixes+nogunsway weapons\mp /SYI > NUL
goto MAKE_OPENWARFARE_EVENT_PATCH_IWD

:WEAPONS_FIXES_NOGUNSWAY_SNIPER
xcopy weapons\fixes+nogunsway+sniper weapons\mp /SYI > NUL
goto MAKE_OPENWARFARE_EVENT_PATCH_IWD

:WEAPONS_THECOMPANY
xcopy weapons\thecompany weapons\mp /SYI > NUL
goto MAKE_OPENWARFARE_EVENT_PATCH_IWD



:MAKE_OPENWARFARE_EVENT_PATCH_IWD
echo _________________________________________________________________
echo.
echo  Please choose what event files to use:
echo    1. None
echo    2. Happy Birthday
echo    3. Christmas
echo    4. Spring
echo    5. 9 May
echo.
echo    0. Back
echo.
set /p zow_option_event=:
set zow_option_event=%zow_option_event:~0,1%

set eventDir=none
if "%zow_option_event%"=="2" set eventDir=server_event_patch_hb\
if "%zow_option_event%"=="3" set eventDir=server_event_patch_xmas\
if "%zow_option_event%"=="4" set eventDir=server_event_patch_spring\
if "%zow_option_event%"=="5" set eventDir=server_event_patch_9may\
if "%zow_option_event%"=="0" goto MAKE_OPENWARFARE_IWD

if "%make_option%"=="4" goto MAKE_MOD_FF

if "%zow_option_event%"=="1" goto BUILD_OPENWARFARE_IWD
if "%zow_option_event%"=="2" goto BUILD_OPENWARFARE_IWD
if "%zow_option_event%"=="3" goto BUILD_OPENWARFARE_IWD
if "%zow_option_event%"=="4" goto BUILD_OPENWARFARE_IWD
if "%zow_option_event%"=="5" goto BUILD_OPENWARFARE_IWD

goto MAKE_OPENWARFARE_EVENT_PATCH_IWD


:MAKE_RULES_IWD
echo _________________________________________________________________
echo.
echo  Please type the name of the ruleset to build:
echo.
echo    0. Back
echo.
set /p zow_ruleset=:
if "%zow_ruleset%"=="0" goto START
if not exist rulesets\%zow_ruleset% goto INVALID_RULESET
echo  Building ruleset %zow_ruleset% .IWD file:
echo    Deleting old .IWD ruleset file...
del z_svr_rs_%zow_ruleset%.iwd > NUL
echo    Creating new .IWD ruleset file...
7za a -r -tzip z_svr_rs_%zow_ruleset%.iwd rulesets\%zow_ruleset%\*.gsc > NUL
echo  New ruleset .IWD file successfully built!

if "%make_option%"=="1" goto MAKE_MOD_FF
goto END

:INVALID_RULESET
echo  Invalid ruleset name specified!
goto MAKE_RULES_IWD

:MAKE_MOD_FF
echo _________________________________________________________________
echo.
echo  Building mod.ff:
echo    Deleting old mod.ff file...
del mod.ff

echo    Copying localized strings...
xcopy %LANG% ..\..\raw\%LTARGET% /SYI > NUL

echo    Copying game resources...
xcopy configs ..\..\raw\configs /SYI > NUL
xcopy images ..\..\raw\images /SYI > NUL
xcopy fx ..\..\raw\fx /SYI > NUL
xcopy maps ..\..\raw\maps /SYI > NUL
xcopy materials ..\..\raw\materials /SYI > NUL
xcopy mp ..\..\raw\mp /SYI > NUL
xcopy rulesets ..\..\raw\rulesets /SYI > NUL
xcopy sound ..\..\raw\sound /SYI > NUL
xcopy soundaliases ..\..\raw\soundaliases /SYI > NUL
xcopy ui_mp ..\..\raw\ui_mp /SYI > NUL
xcopy vision ..\..\raw\vision /SYI > NUL
xcopy weapons\fixes ..\..\raw\weapons\mp /SYI > NUL
xcopy xanim ..\..\raw\xanim /SYI > NUL
xcopy xmodel ..\..\raw\xmodel /SYI > NUL
xcopy xmodelparts ..\..\raw\xmodelparts /SYI > NUL
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SYI > NUL
xcopy shock ..\..\raw\shock /SYI > NUL

echo    Copying OpenWarfare source code...
xcopy openwarfare ..\..\raw\openwarfare /SYI > NUL
copy /Y mod_ignore.csv ..\..\zone_source\%LTARGET%\assetlist > NUL

if "%eventDir%"=="none" (
copy /Y mod.csv ..\..\zone_source > NUL
) else (
echo    Copying event resources...

copy /Y mod.csv + %eventDir%mod.csv ..\..\zone_source\mod.csv > NUL

xcopy %eventDir%images ..\..\raw\images /SYI > NUL
xcopy %eventDir%sound ..\..\raw\sound /SYI > NUL
xcopy %eventDir%soundaliases ..\..\raw\soundaliases /SYI > NUL
xcopy %eventDir%vision ..\..\raw\vision /SYI > NUL
xcopy %eventDir%maps ..\..\raw\maps /SYI > NUL
xcopy %eventDir%openwarfare ..\..\raw\openwarfare /SYI > NUL
xcopy %eventDir%material_properties ..\..\raw\material_properties /SYI > NUL
xcopy %eventDir%materials ..\..\raw\materials /SYI > NUL
xcopy %eventDir%xmodelsurfs ..\..\raw\xmodelsurfs /SYI > NUL
xcopy %eventDir%xmodelparts ..\..\raw\xmodelparts /SYI > NUL
xcopy %eventDir%xmodel ..\..\raw\xmodel /SYI > NUL
)

echo    Compiling mod...
cd ..\..\bin > NUL
linker_pc.exe -language %LTARGET% -compress -cleanup mod 
cd %COMPILEDIR% > NUL
copy ..\..\zone\%LTARGET%\mod.ff > NUL
echo.
echo  New mod.ff file successfully built!
goto END

:END
echo.
timeout 10
goto FINAL

:FINAL