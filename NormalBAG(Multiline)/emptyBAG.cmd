@ECHO OFF & SET "PARAM=%1" & SET "PARAMS=%*"
SET "PARAM=%PARAM:"=%
SET "PARAMS=%PARAMS:"=%
IF NOT "%PARAM%" == "%PARAMS%" ECHO You can only put one thing at a time in the BAG! & PAUSE & EXIT /b
>nul 2>&1 reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul 2>&1 fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
>nul 2>&1 reg delete hkcu\software\classes\.Admin\ /f
>nul 2>&1 del %temp%\runas.Admin /f /q 
IF NOT [%1]==[] (CALL :FILLBAG %1) ELSE (CALL :EMPTYBAG %1)
EXIT
:EMPTYBAG
IF "%~n0"=="emptyBAG" ECHO The BAG is already empty, drag-and-drop something onto the BAG to put it inside. ;^) & PAUSE & EXIT /b
ECHO EMPTYING BAG...
powershell -nop -c $file=Get-Content '%~f0'; $r=[regex]::Match^($file,'\:\:^([^^^\:]+^)\:\:^(.+?^)\:\:\1\:\:'^).Groups[2].Value.Replace^(' ',"""`n"""^).Replace^('::',''^) ^| Set-Content '%TEMP%\%~n0.003' >nul
powershell -nop -c ^(Get-Content '%~f0' ^| Select-Object -Skip 35^) ^| Set-Content '%TEMP%\%~n0.002' >nul
SET /p FNAME=<"%TEMP%\%~n0.002" 
DEL "%TEMP%\%~n0.002" /F /Q>nul
SETLOCAL ENABLEDELAYEDEXPANSION
CERTUTIL -DECODE -F "%TEMP%\%~n0.003" "%~dp0!FNAME::=!" >nul
ENDLOCAL
DEL "%TEMP%\%~n0.003" /F /Q>nul
powershell -nop -c ^(get-content '%~f0' -totalcount 35^) ^| set-content '%~dp0emptyBAG.cmd' >nul
GOTO 2>nul & del "%~f0" /F /Q>nul & EXIT /b
:FILLBAG
IF %~z1 GEQ 74400000 ECHO File Exceeds Safe Size Limit! ^(~70mb^) & PAUSE & EXIT /b
IF "%~n0"=="fullBAG" ECHO The BAG is already full! Open the BAG to empty it. & EXIT /b
ECHO FILLING BAG...
CERTUTIL -ENCODE -F %1 "%TEMP%\%~n1.000">nul
powershell -nop -c ^(Get-Content '%TEMP%\%~n1.000'^) -replace '^^^','::' -replace '-----BEGIN CERTIFICATE-----','%~nx1::' -replace '-----END CERTIFICATE-----','%~nx1::' ^| Set-Content '%TEMP%\%~n1.001' >nul
DEL "%TEMP%\%~n1.000" /F /Q>nul
powershell -nop -c Add-Content -Path '%~f0' -Value ^(Get-Content -Path '"%TEMP%\%~n1.001"'^) >nul
DEL "%TEMP%\%~n1.001" /F /Q>nul
DEL %1 /F /Q>nul
COPY /Y "%~f0" "%~dp0fullBAG.cmd" >nul
GOTO 2>nul & del "%~f0" /F /Q>nul & EXIT /b
::