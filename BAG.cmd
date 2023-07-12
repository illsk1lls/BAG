@ECHO OFF & SET N=0
>nul 2>&1 reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul 2>&1 fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
>nul 2>&1 reg delete hkcu\software\classes\.Admin\ /f
>nul 2>&1 del %temp%\runas.Admin /f
IF [%1]==[] (CALL :EMPTYBAG) ELSE (ECHO FILLING BAG... & ECHO. & FOR %%i IN (%*) DO (CALL :FILLBAG %%i))
IF %N%==1 (ECHO. & PAUSE & EXIT) ELSE (EXIT)
:FILLBAG
IF EXIST %1\* ECHO [Folder - Ignored] - %~nx1 - Folders are not supported! & SET N=1 & EXIT /b
IF %~z1 LSS 1 ECHO [File   - Ignored] - %~nx1 - Empty files are not supported! & SET N=1 & EXIT /b
ECHO. >>"%~f0" & POWERSHELL -nop -c "Add-Content '%~f0' ':' -NoNewline; Add-Content '%~f0' """:%~nx1:""" -NoNewline; Add-Content '%~f0' ':' -NoNewline; [Convert]::ToBase64String([IO.File]::ReadAllBytes("""%~1""")) | Add-Content """%~f0""" -NoNewline; Add-Content '%~f0' ':' -NoNewline; Add-Content '%~f0' """:%~nx1:""" -NoNewline; Add-Content '%~f0' ':' -NoNewline" & DEL /F "%~1">nul
EXIT /b
:EMPTYBAG
IF %~z0 LSS 1730 ECHO The BAG is already empty, drag-and-drop something onto the BAG to put it inside. ;^) & ECHO. & PAUSE & EXIT /b
IF %~z0 GEQ 80000000 (ECHO EMPTYING BAG... ^(This may take a while^)) ELSE (ECHO EMPTYING BAG...)
POWERSHELL -nop -c "$file=Get-Content '%~f0'; $match=[regex]::Matches($file,'\:\:([^\:]+)\:\:(.+?)\:\:\1\:\:') | Foreach-Object {$name=$_.Groups[1].Value; $data=$_.Groups[2].Value; [IO.File]::WriteAllBytes("""$name""", [Convert]::FromBase64String($data))}; (Get-Content '%~f0' -TotalCount 17) | Set-Content '%~f0'">nul
EXIT /b