@echo off
REM InvoChain Deployment Script for Windows
REM Purpose: Automate deployment to g1t2.drshaiban.cloud
REM Usage: deploy.bat [website|app|backend|all]
REM 
REM Note: This is a legacy script. Use deploy-g1t2.bat for current deployment.

setlocal enabledelayedexpansion

REM Configuration
set SERVER=root@drshaiban.cloud
set REMOTE_DIR=/var/www/invochain-g1t2
set LOCAL_WEBSITE_DIR=frontend\website
set LOCAL_APP_DIR=frontend\mobile-app\build\web
set LOCAL_BACKEND_DIR=backend

REM Parse command line argument
set DEPLOY_TYPE=%1
if "%DEPLOY_TYPE%"=="" set DEPLOY_TYPE=all

echo ========================================
echo InvoChain Deployment Script
echo ========================================
echo.
echo NOTE: This is a legacy script.
echo For current deployment, use: deploy-g1t2.bat
echo.

if "%DEPLOY_TYPE%"=="website" goto deploy_website
if "%DEPLOY_TYPE%"=="app" goto deploy_app
if "%DEPLOY_TYPE%"=="backend" goto deploy_backend
if "%DEPLOY_TYPE%"=="all" goto deploy_all
if "%DEPLOY_TYPE%"=="help" goto show_help
goto invalid_option

:deploy_website
echo [INFO] Deploying marketing website...
echo.

if not exist "%LOCAL_WEBSITE_DIR%" (
    echo [ERROR] Website directory not found: %LOCAL_WEBSITE_DIR%
    exit /b 1
)

echo [INFO] Syncing website files to server...
scp -r %LOCAL_WEBSITE_DIR%\* %SERVER%:%REMOTE_DIR%/website/

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Website deployed successfully!
) else (
    echo [ERROR] Failed to deploy website
    exit /b 1
)

goto reload_nginx

:deploy_app
echo [INFO] Deploying Flutter web application...
echo.

if not exist "%LOCAL_APP_DIR%" (
    echo [ERROR] Flutter build not found. Building now...
    cd Application\invochain_app
    call flutter clean
    call flutter pub get
    call flutter build web --release --web-renderer html
    cd ..\..
)

echo [INFO] Syncing Flutter app to server...
scp -r %LOCAL_APP_DIR%\* %SERVER%:%REMOTE_DIR%/app/

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Flutter app deployed successfully!
) else (
    echo [ERROR] Failed to deploy Flutter app
    exit /b 1
)

goto reload_nginx

:deploy_all
echo [INFO] Starting full deployment...
echo.
call :deploy_website_internal
call :deploy_app_internal
goto reload_nginx

:deploy_website_internal
echo [INFO] Deploying marketing website...
if exist "%LOCAL_WEBSITE_DIR%" (
    scp -r %LOCAL_WEBSITE_DIR%\* %SERVER%:%REMOTE_DIR%/website/
    echo [SUCCESS] Website deployed!
)
goto :eof

:deploy_app_internal
echo [INFO] Deploying Flutter app...
if not exist "%LOCAL_APP_DIR%" (
    echo [INFO] Building Flutter app...
    cd Application\invochain_app
    call flutter clean
    call flutter pub get
    call flutter build web --release --web-renderer html
    cd ..\..
)
scp -r %LOCAL_APP_DIR%\* %SERVER%:%REMOTE_DIR%/app/
echo [SUCCESS] Flutter app deployed!
goto :eof

:reload_nginx
echo.
echo [INFO] Reloading Nginx configuration...
ssh %SERVER% "sudo nginx -t && sudo systemctl reload nginx"

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Nginx reloaded successfully!
) else (
    echo [WARNING] Failed to reload Nginx
)

echo.
echo ========================================
echo [SUCCESS] Deployment completed!
echo ========================================
echo.
echo Next steps:
echo   1. Visit https://g1t2.drshaiban.cloud to verify website
echo   2. Visit https://g1t2.drshaiban.cloud/app to test Flutter app
echo   3. Check logs on server
echo.
goto end

:show_help
echo Usage: deploy.bat [website^|app^|all]
echo.
echo Options:
echo   website  - Deploy marketing website only
echo   app      - Deploy Flutter web application only
echo   all      - Deploy everything (default)
echo.
echo Examples:
echo   deploy.bat website
echo   deploy.bat app
echo   deploy.bat all
echo.
goto end

:invalid_option
echo [ERROR] Invalid option: %DEPLOY_TYPE%
echo.
goto show_help

:end
endlocal
