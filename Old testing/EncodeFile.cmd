@ECHO OFF
CLS
TITLE ENCODING FILE
ECHO.
IF [%1]==[] ECHO Please drop a file onto the script & ECHO. & PAUSE & EXIT
SET "INFILE=%1"
ECHO Please Wait...
ECHO.
CERTUTIL -ENCODE -F %1 %INFILE:~0,-4%tmp" >nul
FOR %%i IN ("%1") DO (
SET SECTION=%%~ni
)
ECHO.>>"%~dp0ExtractFunction.cmd" & powershell -nop -c ^(Get-Content ""%INFILE:~0,-4%tmp"""^) -replace '^^^','::' -replace '-----BEGIN CERTIFICATE-----','%SECTION%::' -replace '-----END CERTIFICATE-----','%SECTION%::' ^| Add-Content '%~dp0ExtractFunction.cmd'
DEL %INFILE:~0,-4%tmp" /F /Q>nul
EXIT