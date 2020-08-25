@echo off
setlocal EnableDelayedExpansion
set /p=<nul>exec.bat
set destPath=%2
ECHO @echo on >>exec.bat
for %%i in (*.proto) do (
	set /p="protoc --descriptor_set_out=%destPath%%%~ni.pb %%i "<nul >> exec.bat

	findstr /b /i import %%i >nul
	if !errorlevel! equ 0  (set /p="--include_imports "<nul >> exec.bat)
	
	for /f tokens^=2*^ delims^=^" %%a in ('findstr /b /i import %%i') do (
		set /p= %%a <nul>> exec.bat
		set /a wind+=1
	)
	ECHO.>> exec.bat
)
ECHO @echo off>> exec.bat
call exec.bat
del exec.bat
pause