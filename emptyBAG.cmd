@ECHO OFF & SET "PARAM=%1" & SET "PARAMS=%*"
SET "PARAM=%PARAM:"=%
SET "PARAMS=%PARAMS:"=%
IF NOT "%PARAM%" == "%PARAMS%" ECHO You can only put one thing at a time in the BAG! & PAUSE & EXIT /b
>nul 2>&1 reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul 2>&1 fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
>nul 2>&1 reg delete hkcu\software\classes\.Admin\ /f
>nul 2>&1 del %temp%\runas.Admin /f /q
IF NOT [%1]==[] (CALL :FILLBAG %1) ELSE (CALL :EMPTYBAG)
EXIT
:FILLBAG
IF NOT %~z1 GEQ 1 (ECHO Empty files not allowed! & PAUSE & EXIT /b)
IF EXIST %1\* ECHO Folders are not supported! Single file only.. & PAUSE & EXIT /b
IF "%~n0"=="fullBAG" ECHO The BAG is already full! Open the BAG to empty it. & PAUSE & EXIT /b
ECHO FILLING BAG...
ECHO.>>"%~f0" & ECHO :^:%~nx1:^:>>"%~f0" & ECHO|SET /p="::">>"%~f0" & POWERSHELL -nop -c "[Convert]::ToBase64String([IO.File]::ReadAllBytes(\"%1\"))">>"%~f0" & ECHO :^:%~nx1:^:>>"%~f0"
DEL %1 /F /Q>nul
COPY /Y "%~f0" "%~dp0fullBAG.cmd" >nul
GOTO 2>nul & del "%~f0" /F /Q>nul & EXIT /b
EXIT /b 
:EMPTYBAG
IF "%~n0"=="emptyBAG" ECHO The BAG is already empty, drag-and-drop something onto the BAG to put it inside. ;^) & ECHO. & PAUSE & EXIT /b
IF %~z0 GEQ 80000000 (ECHO EMPTYING BAG... ^(This may take a while^)) ELSE (ECHO EMPTYING BAG...)
POWERSHELL -nop -c $file=Get-Content '%~f0'; $name=[regex]::Match^($file,'\:\:^([^^^\:]+^)\:\:^(.+?^)\:\:\1\:\:'^).Groups[1].Value.Replace^('::',''^).Trim^(^); $data=[regex]::Match^($file,'\:\:^([^^^\:]+^)\:\:^(.+?^)\:\:\1\:\:'^).Groups[2].Value.Replace^('::',''^).Trim^(^); [IO.File]::WriteAllBytes(\"$name\", [Convert]::FromBase64String($data)); ^(get-content '%~f0' -totalcount 26^) ^| set-content '%~dp0emptyBAG.cmd' >nul
GOTO 2>nul & del "%~f0" /F /Q>nul & EXIT /b
EXIT /b