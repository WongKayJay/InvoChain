@echo off
REM InvoChain Deployment Script for Windows
REM Purpose: Automate deployment to g1t2.drshaiban.cloud
REM Usage: deploy-g1t2.bat [website|app|backend|all]
REM
REM Domains:
REM   - g1t2.drshaiban.cloud: Marketing website
REM   - app.g1t2.drshaiban.cloud: Flutter web application

setlocal enabledelayedexpansion

REM Configuration
set SERVER=root@drshaiban.cloud
set SUBDOMAIN=g1t2
set APP_SUBDOMAIN=app.g1t2
set REMOTE_DIR=/var/www/invochain-g1t2
set LOCAL_WEBSITE_DIR=frontend\website
set LOCAL_APP_DIR=frontend\mobile-app\build\web
set LOCAL_BACKEND_DIR=backend

REM Parse command line argument
set DEPLOY_TYPE=%1
if "%DEPLOY_TYPE%"=="" set DEPLOY_TYPE=all

echo ========================================
echo InvoChain Deployment
echo ========================================
echo Website:  https://g1t2.drshaiban.cloud
echo App:      https://app.g1t2.drshaiban.cloud
echo API:      https://g1t2.drshaiban.cloud/api
echo ========================================
echo.

if "%DEPLOY_TYPE%"=="website" goto deploy_website
if "%DEPLOY_TYPE%"=="app" goto deploy_app
if "%DEPLOY_TYPE%"=="backend" goto deploy_backend
if "%DEPLOY_TYPE%"=="all" goto deploy_all
if "%DEPLOY_TYPE%"=="help" goto show_help
goto invalid_option

:deploy_website
echo [1/4] Deploying marketing website to g1t2.drshaiban.cloud...
echo.

if not exist "%LOCAL_WEBSITE_DIR%" (
    echo [ERROR] Website directory not found: %LOCAL_WEBSITE_DIR%
    exit /b 1
)

echo [INFO] Building website...
cd %LOCAL_WEBSITE_DIR%
call npm install
if errorlevel 1 (
    echo [ERROR] npm install failed
    cd ..\..
    exit /b 1
)
call npm run build
if errorlevel 1 (
    echo [ERROR] npm run build failed
    cd ..\..
    exit /b 1
)
cd ..\..

echo [INFO] Creating remote directory...
ssh %SERVER% "mkdir -p %REMOTE_DIR%/website"

echo [INFO] Syncing website files to server...
scp -r %LOCAL_WEBSITE_DIR%\dist\* %SERVER%:%REMOTE_DIR%/website/

if errorlevel 1 (
    echo [ERROR] Failed to sync website files
    exit /b 1
)

echo [SUCCESS] Website deployed to https://g1t2.drshaiban.cloud
echo.
goto :eof

:deploy_app
echo [2/4] Deploying Flutter app to app.g1t2.drshaiban.cloud...
echo.

echo [INFO] Building Flutter web app...
cd frontend\mobile-app
call flutter build web --release
if errorlevel 1 (
    echo [ERROR] Flutter build failed
    cd ..\..
    exit /b 1
)
cd ..\..

if not exist "%LOCAL_APP_DIR%" (
    echo [ERROR] Flutter build directory not found: %LOCAL_APP_DIR%
    exit /b 1
)

echo [INFO] Creating remote directory...
ssh %SERVER% "mkdir -p %REMOTE_DIR%/app"

echo [INFO] Syncing Flutter app files to server...
scp -r %LOCAL_APP_DIR%\* %SERVER%:%REMOTE_DIR%/app/

if errorlevel 1 (
    echo [ERROR] Failed to sync Flutter app files
    exit /b 1
)

echo [SUCCESS] Flutter app deployed to https://app.g1t2.drshaiban.cloud
echo.
goto :eof

:deploy_backend
echo [3/4] Deploying backend API...
echo.

if not exist "%LOCAL_BACKEND_DIR%" (
    echo [ERROR] Backend directory not found: %LOCAL_BACKEND_DIR%
    exit /b 1
)

echo [INFO] Creating remote backend directory...
ssh %SERVER% "mkdir -p %REMOTE_DIR%/backend"

echo [INFO] Syncing backend files to server...
scp -r %LOCAL_BACKEND_DIR%\* %SERVER%:%REMOTE_DIR%/backend/

if errorlevel 1 (
    echo [ERROR] Failed to sync backend files
    exit /b 1
)

echo [INFO] Installing backend dependencies on server...
ssh %SERVER% "cd %REMOTE_DIR%/backend && npm install --production"

echo [INFO] Setting up PM2 for backend...
ssh %SERVER% "cd %REMOTE_DIR%/backend && pm2 delete invochain-api 2>nul || true && pm2 start server.js --name invochain-api"
ssh %SERVER% "pm2 save"

echo [SUCCESS] Backend API deployed and running
echo.
goto :eof

:deploy_all
echo Deploying all components...
echo.

call :deploy_website
if errorlevel 1 exit /b 1

call :deploy_app
if errorlevel 1 exit /b 1

call :deploy_backend
if errorlevel 1 exit /b 1

echo [4/4] Configuring Nginx...
echo.

echo [INFO] Uploading Nginx configuration...
scp docs\nginx-g1t2.conf %SERVER%:/etc/nginx/sites-available/invochain-g1t2

echo [INFO] Enabling site configuration...
ssh %SERVER% "ln -sf /etc/nginx/sites-available/invochain-g1t2 /etc/nginx/sites-enabled/"

echo [INFO] Testing Nginx configuration...
ssh %SERVER% "nginx -t"
if errorlevel 1 (
    echo [ERROR] Nginx configuration test failed
    exit /b 1
)

echo [INFO] Reloading Nginx...
ssh %SERVER% "systemctl reload nginx"

echo.
echo [INFO] Setting up SSL certificates with Certbot...
echo [NOTE] You may need to run these manually if not already configured:
echo.
echo   ssh %SERVER%
echo   certbot --nginx -d g1t2.drshaiban.cloud
echo   certbot --nginx -d app.g1t2.drshaiban.cloud
echo.

echo ========================================
echo DEPLOYMENT COMPLETE!
echo ========================================
echo.
echo Your InvoChain platform is now live:
echo.
echo   Marketing Website: https://g1t2.drshaiban.cloud
echo   Flutter Web App:   https://app.g1t2.drshaiban.cloud
echo   Backend API:       https://g1t2.drshaiban.cloud/api
echo.
echo Test endpoints:
echo   curl https://g1t2.drshaiban.cloud/api/health
echo   curl https://app.g1t2.drshaiban.cloud
echo.
echo ========================================
goto :eof

:show_help
echo.
echo InvoChain Deployment Script
echo ===========================
echo.
echo Usage: deploy-g1t2.bat [OPTION]
echo.
echo Options:
echo   website  - Deploy marketing website only (g1t2.drshaiban.cloud)
echo   app      - Deploy Flutter web app only (app.g1t2.drshaiban.cloud)
echo   backend  - Deploy backend API only
echo   all      - Deploy everything (default)
echo   help     - Show this help message
echo.
echo Examples:
echo   deploy-g1t2.bat              Deploy everything
echo   deploy-g1t2.bat website      Deploy website only
echo   deploy-g1t2.bat app          Deploy Flutter app only
echo.
echo Prerequisites:
echo   - SSH access to %SERVER%
echo   - Node.js and npm installed locally
echo   - Flutter SDK installed locally
echo   - PM2 installed on server
echo   - Nginx installed on server
echo.
echo Domains:
echo   Main:    g1t2.drshaiban.cloud (website + /api)
echo   App:     app.g1t2.drshaiban.cloud (Flutter app)
echo.
goto :eof

:invalid_option
echo [ERROR] Invalid option: %DEPLOY_TYPE%
echo Run 'deploy-g1t2.bat help' for usage information
exit /b 1
