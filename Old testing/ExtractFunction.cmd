@ECHO OFF
::For testing manually type the section name here, and enter the final outfile name when prompted.
SET "EXTRACTTHIS=TestFile"
CALL :EXTRACT %EXTRACTTHIS%
SET /P "filename=Name the output file: "
CERTUTIL -DECODE -F "%~dp0%EXTRACTTHIS%.ENCODED" "%~dp0%filename%">nul
DEL /F /Q "%~dp0%EXTRACTTHIS%.ENCODED"
EXIT

:EXTRACT <::sectionlabel::>
powershell -nop -c $file = Get-Content '%~f0';$result = [regex]::Match^($file,'::%1::^(.*?^)::%1::'^).Groups[1].Value.Replace^(' ',"""`n"""^).Replace^('::',''^) ^| Set-Content '%~dp0%1.ENCODED'
EXIT /b