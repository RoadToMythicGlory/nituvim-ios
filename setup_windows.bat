@echo off
setlocal enabledelayedexpansion

echo.
echo 🚀 Nituvim AI - Windows Setup Script
echo ===================================
echo.

:: Check if running with admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  This script should be run as Administrator for best results
    echo    Right-click and select "Run as administrator"
    echo.
    pause
)

:: Check if Flutter is installed
echo [INFO] Checking Flutter installation...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Flutter is not installed
    echo.
    echo Please install Flutter manually:
    echo 1. Go to: https://flutter.dev/docs/get-started/install/windows
    echo 2. Download Flutter SDK
    echo 3. Extract to C:\flutter
    echo 4. Add C:\flutter\bin to your PATH
    echo.
    echo After installation, run this script again.
    pause
    exit /b 1
) else (
    echo [SUCCESS] Flutter is installed
)

:: Check Flutter doctor
echo.
echo [INFO] Running Flutter doctor...
flutter doctor

:: Check if we're in the correct directory
if not exist "pubspec.yaml" (
    echo [ERROR] pubspec.yaml not found
    echo Please run this script from the Flutter project root directory
    pause
    exit /b 1
)

:: Install Flutter dependencies
echo.
echo [INFO] Installing Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [SUCCESS] Flutter dependencies installed

:: Check for Windows development setup
echo.
echo [INFO] Checking Windows development setup...
flutter config --enable-windows-desktop
echo [SUCCESS] Windows desktop development enabled

:: Final Flutter doctor check
echo.
echo [INFO] Running final Flutter doctor check...
flutter doctor

:: Check for any remaining issues
flutter doctor | findstr /C:"✗" >nul
if %errorlevel% equ 0 (
    echo.
    echo [WARNING] There are some issues with Flutter setup
    echo Please review the output above and fix any issues
) else (
    echo.
    echo [SUCCESS] Flutter setup is complete and ready!
)

echo.
echo 🎉 Setup Complete!
echo ==================
echo.
echo Next steps:
echo 1. Open Windows Terminal or Command Prompt
echo 2. Navigate to this folder
echo 3. Run: flutter run -d windows
echo 4. Start testing your app!
echo.
echo Useful commands:
echo • flutter run -d windows          - Run on Windows
echo • flutter run -d windows --release - Run in release mode  
echo • flutter build windows           - Build for Windows
echo • flutter test                    - Run tests
echo • flutter clean                   - Clean build files
echo.
echo [SUCCESS] Happy coding! 🚀
echo.
pause 