# InvoChain Deployment Guide - g1t2.drshaiban.cloud

Complete guide for deploying InvoChain to production with separate domains for website and app.

## 🌐 Domain Structure

- **Main Website**: https://g1t2.drshaiban.cloud (Marketing/Landing page)
- **Web App**: https://app.g1t2.drshaiban.cloud (Flutter application)
- **Backend API**: https://g1t2.drshaiban.cloud/api (Proxied to port 3000)

## 📋 Prerequisites

### Local Requirements
- ✅ Node.js v22+ and npm installed
- ✅ Flutter SDK 3.35+ installed
- ✅ Git installed
- ✅ SSH client configured

### Server Requirements
- ✅ Ubuntu 20.04/22.04 LTS (or similar Linux distribution)
- ✅ Nginx web server
- ✅ Node.js v18+ and npm
- ✅ PM2 process manager
- ✅ SSL certificate (via Certbot/Let's Encrypt)
- ✅ SSH access as root or sudo user

### DNS Configuration
Before deployment, configure these DNS records in Hostinger:

| Type | Name | Value | TTL |
|------|------|-------|-----|
| A | g1t2 | [Your Server IP] | 300 |
| A | app.g1t2 | [Your Server IP] | 300 |

**Wait 10-15 minutes for DNS propagation before proceeding.**

Verify DNS is working:
```bash
nslookup g1t2.drshaiban.cloud
nslookup app.g1t2.drshaiban.cloud
```

## 🚀 Quick Deploy

For a complete deployment of all components:

```bash
cd C:\Users\there\Downloads\InvoChain
scripts\deploy-g1t2.bat all
```

This will:
1. ✅ Build and deploy marketing website to g1t2.drshaiban.cloud
2. ✅ Build and deploy Flutter app to app.g1t2.drshaiban.cloud
3. ✅ Deploy backend API to g1t2.drshaiban.cloud/api
4. ✅ Configure Nginx with proper routing
5. ✅ Start backend with PM2

## 📦 Component-by-Component Deployment

### 1. Marketing Website (g1t2.drshaiban.cloud)

Deploy just the landing page:

```bash
scripts\deploy-g1t2.bat website
```

**What it does:**
- Runs `npm install` in `frontend/website/`
- Builds production bundle with Vite (`npm run build`)
- Uploads `dist/` folder to `/var/www/invochain-g1t2/website/`
- Nginx serves from this directory

**Verify:**
```bash
curl https://g1t2.drshaiban.cloud
```

### 2. Flutter Web App (app.g1t2.drshaiban.cloud)

Deploy just the Flutter application:

```bash
scripts\deploy-g1t2.bat app
```

**What it does:**
- Runs `flutter build web --release` in `frontend/mobile-app/`
- Optimizes assets (tree-shaking, compression)
- Uploads `build/web/` folder to `/var/www/invochain-g1t2/app/`
- Nginx serves from this directory on subdomain

**Verify:**
```bash
curl https://app.g1t2.drshaiban.cloud
```

### 3. Backend API (g1t2.drshaiban.cloud/api)

Deploy just the backend:

```bash
scripts\deploy-g1t2.bat backend
```

**What it does:**
- Uploads entire `backend/` folder to `/var/www/invochain-g1t2/backend/`
- Runs `npm install --production` on server
- Starts/restarts API with PM2 on port 3000
- Nginx proxies `/api` requests to `localhost:3000`

**Verify:**
```bash
curl https://g1t2.drshaiban.cloud/api/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "InvoChain API is running",
  "timestamp": "..."
}
```

## 🔧 Manual Setup Steps

If you prefer manual deployment or need to troubleshoot:

### Step 1: Prepare Server

SSH into your server:
```bash
ssh root@drshaiban.cloud
```

Create directory structure:
```bash
mkdir -p /var/www/invochain-g1t2/{website,app,backend}
```

Install dependencies:
```bash
# Install Node.js (if not already installed)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs

# Install PM2
npm install -g pm2

# Install Nginx (if not already installed)
apt-get install -y nginx

# Install Certbot for SSL
apt-get install -y certbot python3-certbot-nginx
```

### Step 2: Build Locally

On your Windows machine:

**Build website:**
```powershell
cd frontend\website
npm install
npm run build
```

**Build Flutter app:**
```powershell
cd frontend\mobile-app
flutter build web --release
```

### Step 3: Upload Files

Using SCP from Windows PowerShell:

```powershell
# Upload website
scp -r frontend\website\dist\* root@drshaiban.cloud:/var/www/invochain-g1t2/website/

# Upload Flutter app
scp -r frontend\mobile-app\build\web\* root@drshaiban.cloud:/var/www/invochain-g1t2/app/

# Upload backend
scp -r backend\* root@drshaiban.cloud:/var/www/invochain-g1t2/backend/
```

### Step 4: Configure Backend

SSH to server and setup backend:

```bash
cd /var/www/invochain-g1t2/backend
npm install --production

# Start with PM2
pm2 start server.js --name invochain-api
pm2 save
pm2 startup  # Enable auto-restart on server reboot
```

### Step 5: Configure Nginx

Upload Nginx configuration:
```powershell
scp docs\nginx-g1t2.conf root@drshaiban.cloud:/etc/nginx/sites-available/invochain-g1t2
```

Enable the site:
```bash
ln -sf /etc/nginx/sites-available/invochain-g1t2 /etc/nginx/sites-enabled/
nginx -t  # Test configuration
systemctl reload nginx
```

### Step 6: Setup SSL Certificates

Run Certbot for both domains:

```bash
# Main domain
certbot --nginx -d g1t2.drshaiban.cloud

# App subdomain
certbot --nginx -d app.g1t2.drshaiban.cloud
```

Certbot will:
- Obtain SSL certificates from Let's Encrypt
- Automatically configure Nginx for HTTPS
- Set up auto-renewal

## 🔐 Environment Variables

Before deploying backend, ensure `.env` file exists:

**backend/.env:**
```env
# Server Configuration
PORT=3000
NODE_ENV=production

# JWT Secret
JWT_SECRET=your_secure_random_secret_key_here

# Database (SQLite by default)
DB_PATH=./database/invochain.db

# CORS
ALLOWED_ORIGINS=https://g1t2.drshaiban.cloud,https://app.g1t2.drshaiban.cloud

# Optional: PostgreSQL (if switching from SQLite)
# DB_HOST=localhost
# DB_PORT=5432
# DB_NAME=invochain
# DB_USER=invochain_user
# DB_PASSWORD=secure_password
```

Upload to server:
```powershell
scp backend\.env root@drshaiban.cloud:/var/www/invochain-g1t2/backend/
```

## 📊 Server Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Internet                          │
└───────────────────┬─────────────────────────────────┘
                    │
         ┌──────────┴──────────┐
         │                     │
         ▼                     ▼
┌────────────────┐    ┌────────────────┐
│  g1t2.         │    │  app.g1t2.     │
│  drshaiban     │    │  drshaiban     │
│  .cloud        │    │  .cloud        │
└────────┬───────┘    └────────┬───────┘
         │                     │
         └──────────┬──────────┘
                    │
              ┌─────▼──────┐
              │   Nginx    │
              │  (Port 443)│
              └─────┬──────┘
                    │
         ┌──────────┼──────────┬──────────┐
         │          │          │          │
         ▼          ▼          ▼          ▼
    ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
    │Website │ │Flutter │ │API     │ │API     │
    │/       │ │/       │ │/api    │ │/api    │
    │        │ │        │ │(main)  │ │(app)   │
    └────────┘ └────────┘ └────┬───┘ └────┬───┘
                                │          │
                                └────┬─────┘
                                     │
                              ┌──────▼──────┐
                              │  Node.js    │
                              │  Backend    │
                              │ (Port 3000) │
                              └──────┬──────┘
                                     │
                              ┌──────▼──────┐
                              │   SQLite    │
                              │  Database   │
                              └─────────────┘
```

## 🧪 Testing Deployment

### Test Website
```bash
curl -I https://g1t2.drshaiban.cloud
# Should return: HTTP/2 200
```

### Test Flutter App
```bash
curl -I https://app.g1t2.drshaiban.cloud
# Should return: HTTP/2 200
```

### Test API
```bash
curl https://g1t2.drshaiban.cloud/api/health
# Should return: {"status":"OK",...}

curl https://app.g1t2.drshaiban.cloud/api/health
# Should also work (same API)
```

### Test HTTPS Redirect
```bash
curl -I http://g1t2.drshaiban.cloud
# Should return: HTTP/1.1 301 Moved Permanently
# Location: https://g1t2.drshaiban.cloud/
```

### Test CORS
```bash
curl -H "Origin: https://app.g1t2.drshaiban.cloud" \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: Content-Type" \
     -X OPTIONS https://g1t2.drshaiban.cloud/api/auth/signup
# Should include CORS headers in response
```

## 🔍 Monitoring & Logs

### PM2 Backend Logs
```bash
pm2 logs invochain-api
pm2 status
pm2 monit
```

### Nginx Logs
```bash
# Website logs
tail -f /var/log/nginx/invochain-g1t2-website-access.log
tail -f /var/log/nginx/invochain-g1t2-website-error.log

# App logs
tail -f /var/log/nginx/invochain-g1t2-app-access.log
tail -f /var/log/nginx/invochain-g1t2-app-error.log
```

### Check SSL Certificate
```bash
certbot certificates
```

### Check Nginx Status
```bash
systemctl status nginx
nginx -t  # Test configuration
```

## 🔄 Updating Deployment

### Update Website Only
```bash
scripts\deploy-g1t2.bat website
```

### Update App Only
```bash
scripts\deploy-g1t2.bat app
```

### Update Backend Only
```bash
scripts\deploy-g1t2.bat backend
```

### Update Everything
```bash
scripts\deploy-g1t2.bat all
```

## 🐛 Troubleshooting

### Issue: DNS not resolving
**Solution:**
```bash
# Check DNS propagation
nslookup g1t2.drshaiban.cloud
nslookup app.g1t2.drshaiban.cloud

# Wait 10-15 minutes and try again
# Clear local DNS cache (Windows)
ipconfig /flushdns
```

### Issue: SSL certificate error
**Solution:**
```bash
# Check certificates
certbot certificates

# Renew if needed
certbot renew

# Manual renewal
certbot --nginx -d g1t2.drshaiban.cloud
certbot --nginx -d app.g1t2.drshaiban.cloud
```

### Issue: API not responding
**Solution:**
```bash
# Check PM2 status
pm2 status

# Check logs
pm2 logs invochain-api

# Restart backend
pm2 restart invochain-api

# Check port 3000
netstat -tlnp | grep 3000
```

### Issue: 502 Bad Gateway
**Solution:**
```bash
# Backend is not running
pm2 start /var/www/invochain-g1t2/backend/server.js --name invochain-api

# Check Nginx proxy configuration
nginx -t
cat /etc/nginx/sites-enabled/invochain-g1t2
```

### Issue: CORS errors in browser
**Solution:**
1. Check backend `.env` has correct `ALLOWED_ORIGINS`
2. Verify Nginx configuration includes CORS headers
3. Restart backend: `pm2 restart invochain-api`
4. Reload Nginx: `systemctl reload nginx`

### Issue: Flutter app shows blank page
**Solution:**
1. Check browser console for errors
2. Verify base href in index.html
3. Check Flutter assets loaded correctly
4. Rebuild with: `flutter build web --release`

## 🔒 Security Checklist

- ✅ SSL certificates installed for both domains
- ✅ HTTP redirects to HTTPS
- ✅ Security headers configured in Nginx
- ✅ JWT_SECRET is strong and unique
- ✅ Database file has proper permissions (600)
- ✅ Firewall allows only ports 80, 443, 22
- ✅ SSH uses key-based authentication
- ✅ Backend runs as non-root user (recommended)
- ✅ CORS properly configured for app subdomain
- ✅ API rate limiting enabled (optional but recommended)

## 📝 Post-Deployment Checklist

- [ ] DNS records configured for both domains
- [ ] SSL certificates obtained and auto-renewal enabled
- [ ] All three components deployed successfully
- [ ] Website loads at https://g1t2.drshaiban.cloud
- [ ] App loads at https://app.g1t2.drshaiban.cloud
- [ ] API responds at /api/health on both domains
- [ ] PM2 backend is running and auto-starts on reboot
- [ ] Nginx configuration tested and loaded
- [ ] HTTPS redirect working
- [ ] CORS working between domains
- [ ] Logs are accessible
- [ ] Monitoring set up (optional)

## 🎉 Success!

Your InvoChain platform is now live:

- **Marketing Website**: https://g1t2.drshaiban.cloud
- **Web Application**: https://app.g1t2.drshaiban.cloud
- **API Endpoint**: https://g1t2.drshaiban.cloud/api

Users can visit the main website, click "Launch Web App", and be taken to the app subdomain seamlessly!

## 📞 Support

For deployment issues:
1. Check troubleshooting section above
2. Review server logs (PM2 and Nginx)
3. Verify DNS and SSL configuration
4. Test each component individually

For development commands, see: `COMMANDS.md`
