@ECHO OFF & SET ERR=0 & SET DROP= %*
>nul 2>&1 REG ADD HKCU\Software\Classes\.theBAG\shell\runas\command /f /ve /d "CMD /x /d /r SET \"f0=%%2\"& call \"%%2\" %%3"
>nul 2>&1 FLTMC|| IF "%f0%" NEQ "%~f0" (CD.>"%temp%\elevate.theBAG" & START "%~n0" /high "%temp%\elevate.theBAG" "%~f0" "%DROP:"=""%" & EXIT /b)
>nul 2>&1 REG DELETE HKCU\Software\Classes\.theBAG\ /f &>nul 2>&1 DEL %temp%\elevate.theBAG /f
FOR /F "usebackq skip=2 tokens=3,4" %%i IN (`REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul`) DO SET "VER=%%i %%j"
IF NOT "%VER%"=="Windows 10" ECHO. & ECHO UNSUPPORTED SYSTEM DETECTED! & ECHO. & PAUSE & EXIT
IF [%1]==[] (CALL :EMPTYBAG) ELSE (SETLOCAL ENABLEDELAYEDEXPANSION & ECHO FILLING BAG... & ECHO. & FOR %%i IN (!DROP!) DO (ENDLOCAL & CALL :FILLBAG %%i))
IF %ERR%==1 (ECHO. & PAUSE & EXIT) ELSE (EXIT)
:FILLBAG
IF EXIST %1\* ECHO [Folder - Ignored] - "%~nx1" - Folders are not supported! & SET ERR=1 & EXIT /b
IF %~z1 LSS 1 ECHO [File - Ignored] - "%~nx1" - Empty files are not supported! & SET ERR=1 & EXIT /b
IF %~z1 GEQ 750000000 ECHO [File - Ignored] - "%~nx1" - Not Added! The file is too large! & SET ERR=1 & EXIT /b
SET /A SIZE=(%~z0 + %~z1) * (130 / 100) & SET "FN=%~nx1" & SET "FP=%~1"
IF %SIZE% GEQ 980000000 ECHO [File - Skipped] - "%~nx1" - Not Added! There is not enough room in the BAG! & SET ERR=1 & EXIT /b
ECHO.>>"%~f0" &>nul 2>&1 POWERSHELL -nop -c "$fn=[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('%FN:'=''%')); AC '%~f0' "^""::$fn::"^"" -NoNewline; [Convert]::ToBase64String([IO.File]::ReadAllBytes('%FP:'=''%')) | AC '%~f0' -NoNewline; AC '%~f0' "^""::$fn::"^"" -NoNewline" & DEL /F "%~1"
EXIT /b
:EMPTYBAG
IF %~z0 LSS 2574 ECHO The BAG is already empty, drag-and-drop something onto the BAG to put it inside. ;^) & ECHO. & PAUSE & EXIT /b
IF %~z0 GEQ 80000000 (ECHO EMPTYING BAG... ^(This may take a while^)) ELSE (ECHO EMPTYING BAG...)
>nul 2>&1 POWERSHELL -nop -c "$f=GC '%~f0'; $m=[regex]::Matches($f,'::([^:]+)::(.+?)::\1::') | %% {$n2=[System.Text.Encoding]::Utf8.GetString([System.Convert]::FromBase64String($_.Groups[1].Value)); if ($n2 -match '^DUPLICATE -(\d+)-') {$n = [int]$Matches[2]}; $fn=$n2; while(Test-Path -LiteralPath "^""%~dp0$fn"^"") {$n++; if ($fn -match '^DUPLICATE -(\d+)-') {$fn = $fn -Replace '^DUPLICATE -(\d+)-',"^""DUPLICATE -$n-"^""}else{$fn="^""DUPLICATE -$n- $n2"^""}}; [IO.File]::WriteAllBytes("^""$fn"^"", [Convert]::FromBase64String($_.Groups[2].Value));$n=0}; (GC '%~f0' -TotalCount 21) | SC '%~f0'"
EXIT /b 
