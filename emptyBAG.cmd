@ECHO OFF & SET "PARAM=%1" & SET "PARAMS=%*"
SET "PARAM=%PARAM:"=%
SET "PARAMS=%PARAMS:"=%
IF NOT "%PARAM%" == "%PARAMS%" ECHO You can only put one thing at a time in the BAG! & ECHO. & PAUSE & EXIT /b
>nul 2>&1 reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul 2>&1 fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
>nul 2>&1 reg delete hkcu\software\classes\.Admin\ /f
>nul 2>&1 del %temp%\runas.Admin /f
IF NOT [%1]==[] (CALL :FILLBAG %1) ELSE (CALL :EMPTYBAG)
EXIT
:FILLBAG
IF EXIST %1\* ECHO Folders are not supported! & ECHO. & PAUSE & EXIT /b
IF %~z1 LSS 1 ECHO Empty files not allowed! & ECHO. & PAUSE & EXIT /b
ECHO FILLING BAG...
ECHO. >>"%~f0" & POWERSHELL -nop -c "Add-Content '%~f0' ':' -NoNewline; Add-Content '%~f0' """:%~nx1:""" -NoNewline; Add-Content '%~f0' ':' -NoNewline; [Convert]::ToBase64String([IO.File]::ReadAllBytes("""%~1""")) | Add-Content """%~f0""" -NoNewline; Add-Content '%~f0' ':' -NoNewline; Add-Content '%~f0' """:%~nx1:""" -NoNewline; Add-Content '%~f0' ':' -NoNewline" & DEL /F "%~1">nul
IF "%~n0"=="emptyBAG" COPY /Y "%~f0" "%~dp0BAG.cmd">nul & GOTO 2>nul & del "%~f0" /F /Q>nul & EXIT /b
EXIT /b
:EMPTYBAG
IF "%~n0"=="emptyBAG" ECHO The BAG is already empty, drag-and-drop something onto the BAG to put it inside. ;^) & ECHO. & PAUSE & EXIT /b
IF %~z0 GEQ 80000000 (ECHO EMPTYING BAG... ^(This may take a while^)) ELSE (ECHO EMPTYING BAG...)
POWERSHELL -nop -c "$file=Get-Content '%~f0'; $match=[regex]::Matches($file,'\:\:([^\:]+)\:\:(.+?)\:\:\1\:\:') | Foreach-Object {$name=$_.Groups[1].Value; $data=$_.Groups[2].Value; [IO.File]::WriteAllBytes("""$name""", [Convert]::FromBase64String($data))}; (Get-Content '%~f0' -TotalCount 22) | Set-Content '%~dp0emptyBAG.cmd'">nul
GOTO 2>nul & del "%~f0" /F /Q>nul & EXIT /b