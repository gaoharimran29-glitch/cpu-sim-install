@echo off
:: Check for Administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting Administrator privileges...
    goto UACPrompt
) else ( goto main )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /b

:main
set "DOWNLOAD_DIR=%~dp0CPUSim_Downloads"
set "JAVA_FILE_NAME=JavaInstaller.exe"
set "JAVA_FILE_ID=1smn_N9GZQ5QJFHPohzhQgoQWj0SDthkF"
set "CPUSIM_URL=http://www.cs.colby.edu/djskrien/CPUSim/CPUSim4.0.11.zip"
set "JAVA_PATH=%DOWNLOAD_DIR%\%JAVA_FILE_NAME%"
set "CPUSIM_ZIP=%DOWNLOAD_DIR%\CPUSim4.0.11.zip"

echo.
echo =========================================================
echo Script Made By Gaohar Imran
echo =========================================================

echo =========================================================
echo  Starting Automated CPU Sim Setup (RUNNING AS ADMIN)
echo =========================================================

:: 1. Setup Download Directory
if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%"
)

:: 1. Download CPU Sim v4 using .NET (Reliable Download Method)
echo.
echo ---------------------------------
echo  1. Downloading CPU Sim v4 (Reliable Method)...
echo ---------------------------------
:: Set download URL and target filename
set URL=[http://www.cs.colby.edu/courses/cs203/CPUSim4/CPUSim4.jar](http://www.cs.colby.edu/courses/cs203/CPUSim4/CPUSim4.jar)
set FILE=CPUSim4.jar
powershell -Command "Invoke-WebRequest -Uri '%CPUSIM_URL%' -OutFile '%CPUSIM_ZIP%' -UseBasicParsing"
powershell -Command "Expand-Archive -Path '%CPUSIM_ZIP%' -DestinationPath '%DOWNLOAD_DIR%' -Force"
echo CPU Sim Installed

:: 2. Install gdown (if Python is available)
echo.
echo ---------------------------------
echo  2. Setting up Python Dependencies...
echo ---------------------------------
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python is required for Google Drive download. Please install Python 3.x.
    pause
    exit /b 1
)
pip install gdown >nul 2>nul

:: 3. Download Java Installer using gdown
echo.
echo ---------------------------------
echo  3. Downloading Java Installer from Google Drive...
echo ---------------------------------
python -m gdown --id "%JAVA_FILE_ID%" -O "%JAVA_PATH%"

if not exist "%JAVA_PATH%" (
    echo.
    echo ERROR: Failed to download Java installer using gdown.
    pause
    exit /b 1
)

:: 4. Install Java Silently
echo.
echo ---------------------------------
echo  4. Installing Java silently...
echo ---------------------------------
:: Adding "ADDLOCAL=ALL" makes silent installs more reliable for some Oracle versions.
CALL "%JAVA_PATH%" /s ADDLOCAL=ALL
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Java installation may have failed or returned an error code (%ERRORLEVEL%).
)

:: Check if download succeeded
if exist "%FILE%" (
echo Download complete: %FILE%
) else (
echo Download failed!
)

:: 5. Cleanup and Finalization
echo.
echo ---------------------------------
echo  5. Cleaning up files and organizing...
echo ---------------------------------
move "%DOWNLOAD_DIR%\CPUSim4.0.11" "%~dp0" 2>nul
del "%JAVA_PATH%" 2>nul
del "%CPUSIM_ZIP%" 2>nul
rmdir "%DOWNLOAD_DIR%" 2>nul

echo.
echo =========================================================
echo  ✅ Installation Complete!
echo =========================================================
echo The Java runtime environment has been installed.
echo CPU Sim v4 is available in the new folder: CPUSim4.0.11