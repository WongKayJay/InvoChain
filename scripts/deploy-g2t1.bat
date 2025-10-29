@echo off
REM InvoChain Deployment Script for Windows
REM Purpose: Automate deployment to g2t1.drshaiban.cloud
REM Usage: deploy-g2t1.bat [website|app|backend|all]

setlocal enabledelayedexpansion

REM Configuration - UPDATED FOR g2t1 subdomain
set SERVER=root@drshaiban.cloud
set SUBDOMAIN=g2t1
set REMOTE_DIR=/var/www/invochain-g2t1
set LOCAL_WEBSITE_DIR=frontend\website
set LOCAL_APP_DIR=frontend\mobile-app\build\web
set LOCAL_BACKEND_DIR=backend

REM Parse command line argument
set DEPLOY_TYPE=%1
if "%DEPLOY_TYPE%"=="" set DEPLOY_TYPE=all

echo ========================================
echo InvoChain Deployment to g2t1.drshaiban.cloud
echo ========================================
echo.

if "%DEPLOY_TYPE%"=="website" goto deploy_website
if "%DEPLOY_TYPE%"=="app" goto deploy_app
if "%DEPLOY_TYPE%"=="backend" goto deploy_backend
if "%DEPLOY_TYPE%"=="all" goto deploy_all
if "%DEPLOY_TYPE%"=="help" goto show_help
goto invalid_option

:deploy_website
echo [1/4] Deploying marketing website...
echo.

if not exist "%LOCAL_WEBSITE_DIR%" (
    echo [ERROR] Website directory not found: %LOCAL_WEBSITE_DIR%
    exit /b 1
)

echo [INFO] Building website...
cd %LOCAL_WEBSITE_DIR%
call npm install
call npm run build
cd ..\..

echo [INFO] Creating remote directory...
ssh %SERVER% "mkdir -p %REMOTE_DIR%/website"

echo [INFO] Syncing website files to server...
scp -r %LOCAL_WEBSITE_DIR%\dist\* %SERVER%:%REMOTE_DIR%/website/

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Website deployed successfully!
) else (
    echo [ERROR] Failed to deploy website
    exit /b 1
)

goto reload_nginx

:deploy_app
echo [2/4] Deploying Flutter web application...
echo.

if not exist "%LOCAL_APP_DIR%" (
    echo [INFO] Flutter build not found. Building now...
    cd frontend\mobile-app
    call flutter clean
    call flutter pub get
    call flutter build web --release
    cd ..\..
)

echo [INFO] Creating remote directory...
ssh %SERVER% "mkdir -p %REMOTE_DIR%/app"

echo [INFO] Syncing Flutter app to server...
scp -r %LOCAL_APP_DIR%\* %SERVER%:%REMOTE_DIR%/app/

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Flutter app deployed successfully!
) else (
    echo [ERROR] Failed to deploy Flutter app
    exit /b 1
)

goto reload_nginx

:deploy_backend
echo [3/4] Deploying backend API...
echo.

if not exist "%LOCAL_BACKEND_DIR%" (
    echo [ERROR] Backend directory not found: %LOCAL_BACKEND_DIR%
    exit /b 1
)

echo [INFO] Creating remote directory...
ssh %SERVER% "mkdir -p %REMOTE_DIR%/backend"

echo [INFO] Syncing backend files to server...
scp -r %LOCAL_BACKEND_DIR%\* %SERVER%:%REMOTE_DIR%/backend/

echo [INFO] Installing backend dependencies on server...
ssh %SERVER% "cd %REMOTE_DIR%/backend && npm install --production"

echo [INFO] Setting up PM2 for backend...
ssh %SERVER% "cd %REMOTE_DIR%/backend && pm2 start server.js --name invochain-g2t1-api || pm2 restart invochain-g2t1-api"

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Backend deployed successfully!
) else (
    echo [ERROR] Failed to deploy backend
    exit /b 1
)

goto reload_nginx

:deploy_all
echo [INFO] Starting full deployment to g2t1.drshaiban.cloud...
echo.

REM Create all directories
echo [INFO] Creating remote directories...
ssh %SERVER% "mkdir -p %REMOTE_DIR%/website %REMOTE_DIR%/app %REMOTE_DIR%/backend"

REM Build website
echo.
echo [1/4] Building and deploying website...
cd %LOCAL_WEBSITE_DIR%
call npm install
call npm run build
scp -r dist\* %SERVER%:%REMOTE_DIR%/website/
cd ..\..
echo [SUCCESS] Website deployed!

REM Build Flutter app
echo.
echo [2/4] Building and deploying Flutter app...
cd frontend\mobile-app
call flutter build web --release
scp -r build\web\* %SERVER%:%REMOTE_DIR%/app/
cd ..\..
echo [SUCCESS] Flutter app deployed!

REM Deploy backend
echo.
echo [3/4] Deploying backend API...
scp -r %LOCAL_BACKEND_DIR%\* %SERVER%:%REMOTE_DIR%/backend/
ssh %SERVER% "cd %REMOTE_DIR%/backend && npm install --production && pm2 start server.js --name invochain-g2t1-api || pm2 restart invochain-g2t1-api"
echo [SUCCESS] Backend deployed!

goto reload_nginx

:reload_nginx
echo.
echo [4/4] Configuring Nginx and SSL...
echo.

REM Copy nginx config
echo [INFO] Deploying Nginx configuration...
scp docs\nginx.conf %SERVER%:/etc/nginx/sites-available/invochain-g2t1

echo [INFO] Enabling site and reloading Nginx...
ssh %SERVER% "ln -sf /etc/nginx/sites-available/invochain-g2t1 /etc/nginx/sites-enabled/invochain-g2t1 && nginx -t && systemctl reload nginx"

echo.
echo [INFO] Setting up SSL certificate with Let's Encrypt...
ssh %SERVER% "certbot --nginx -d g2t1.drshaiban.cloud --non-interactive --agree-tos --email admin@drshaiban.cloud || echo 'SSL setup skipped or already configured'"

echo.
echo ========================================
echo    Deployment Complete!
echo ========================================
echo.
echo  Website:     https://g2t1.drshaiban.cloud
echo  Flutter App: https://g2t1.drshaiban.cloud/app
echo  API:         https://g2t1.drshaiban.cloud/api
echo.
echo [INFO] Testing deployment...
curl -I https://g2t1.drshaiban.cloud 2>nul || echo [WARNING] Site not accessible yet. DNS may still be propagating.
echo.
goto end

:show_help
echo Usage: deploy-g2t1.bat [option]
echo.
echo Options:
echo   website  - Deploy only the marketing website
echo   app      - Deploy only the Flutter application
echo   backend  - Deploy only the backend API
echo   all      - Deploy everything (default)
echo   help     - Show this help message
echo.
goto end

:invalid_option
echo [ERROR] Invalid option: %DEPLOY_TYPE%
echo Run 'deploy-g2t1.bat help' for usage information
exit /b 1

:end
endlocal
