@ECHO OFF&SET ERR=0&SET DROP= %*
>nul 2>&1 REG ADD HKCU\Software\Classes\.theBAG\shell\runas\command /f /ve /d "CMD /x /d /r SET \"f0=%%2\"&call \"%%2\" %%3"
>nul 2>&1 FLTMC||(CD.>"%temp%\elevate.theBAG"&START "%~n0" /high "%temp%\elevate.theBAG" "%~f0" "%DROP:"=""%"&EXIT /b)
>nul 2>&1 REG DELETE HKCU\Software\Classes\.theBAG\ /f &>nul 2>&1 DEL %temp%\elevate.theBAG /f
FOR /F "usebackq skip=2 tokens=3,4" %%# IN (`REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul`) DO SET "VER=%%# %%$"
IF NOT "%VER%"=="Windows 10" ECHO/&ECHO UNSUPPORTED SYSTEM DETECTED!&ECHO/&PAUSE&EXIT
IF [%1]==[] (CALL :EMPTYBAG) ELSE (SETLOCAL ENABLEDELAYEDEXPANSION&ECHO FILLING BAG...&ECHO/&FOR %%# IN (!DROP!) DO (ENDLOCAL&CALL :FILLBAG %%#))
IF %ERR%==1 (ECHO/&PAUSE&EXIT) ELSE (EXIT)
:FILLBAG
IF EXIST "%~1\*" ECHO [Folder - Ignored] - "%~nx1" - Folders are not supported!&SET ERR=1&EXIT /b
IF %~z1 LSS 1 ECHO [File - Ignored] - "%~nx1" - Empty files are not supported!&SET ERR=1&EXIT /b
IF %~z1 GEQ 525000000 ECHO [File - Ignored] - "%~nx1" - Not Added! The file is too large!&SET ERR=1&EXIT /b
SET /A SIZE=(%~z0+%~z1)*(130 / 100)&SET "FN=%~nx1"&SET "FP=%~1"
IF %SIZE% GEQ 525000000 ECHO [File - Skipped] - "%~nx1" - Not Added! There is not enough room in the BAG!&SET ERR=1&EXIT /b
ECHO/>>"%~f0" &>nul 2>&1 POWERSHELL -nop -c "$fn=[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('%FN:'=''%'));AC '%~f0' "^""::$fn::"^"" -NoNewline;$fn1='%FP:'=''%';$fn2=$fn1.Replace('[','``[').Replace(']','``]');$fi=Get-Item "^""$fn2"^"";$i=$fi.OpenRead();$o=[System.IO.MemoryStream]::new();$g=[System.IO.Compression.GZipStream]::new($o,[System.IO.Compression.CompressionLevel]::Optimal);$i.CopyTo($g);$g.Dispose();$o.Dispose();$i.Dispose();[Convert]::ToBase64String($o.ToArray())|AC '%~f0' -NoNewline; AC '%~f0' "^""::$fn::"^"" -NoNewline"&DEL /F "%~1"
EXIT /b
:EMPTYBAG
IF %~z0 LSS 3049 ECHO The BAG is already empty, drag-and-drop something onto the BAG to put it inside. ;^)&ECHO/&PAUSE&EXIT /b
IF %~z0 GEQ 80000000 (ECHO EMPTYING BAG... ^(This may take a while^)) ELSE (ECHO EMPTYING BAG...)
POWERSHELL -nop -c "$f=GC '%~f0';$m=[regex]::Matches($f,'::([^::]+)::(.+?)::\1::')|Select-Object -Skip 1|%%{$n2=[System.Text.Encoding]::Utf8.GetString([System.Convert]::FromBase64String($_.Groups[1].Value));if($n2 -match '^DUPLICATE -(\d+)-'){$n=[int]$Matches[2]};$fn=$n2;while(Test-Path -LiteralPath "^""%~dp0$fn"^""){$n++;if($fn -match '^DUPLICATE -(\d+)-'){$fn=$fn -Replace '^DUPLICATE -(\d+)-',"^""DUPLICATE -$n-"^""}else{$fn="^""DUPLICATE -$n- $n2"^""}};$i=[System.IO.MemoryStream]::new([Convert]::FromBase64String($_.Groups[2].Value));$o=(New-Item "^""$fn"^"" -Force).OpenWrite();$g=[System.IO.Compression.GZipStream]::new($i,[System.IO.Compression.CompressionMode]::Decompress);$g.CopyTo($o);$g.Dispose();$o.Dispose();$i.Dispose();$n=0};(GC '%~f0' -TotalCount 21)|SC '%~f0'"
EXIT /b 