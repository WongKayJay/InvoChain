# InvoChain Deployment Checklist - g1t2.drshaiban.cloud

Quick reference checklist for deploying InvoChain to production.

## 📋 Pre-Deployment

### DNS Configuration (Hostinger)
- [ ] Add A record: `g1t2` → [Server IP]
- [ ] Add A record: `app.g1t2` → [Server IP]
- [ ] Wait 10-15 minutes for DNS propagation
- [ ] Verify DNS: `nslookup g1t2.drshaiban.cloud`
- [ ] Verify DNS: `nslookup app.g1t2.drshaiban.cloud`

### Local Environment
- [ ] Node.js v22+ installed
- [ ] Flutter SDK 3.35+ installed
- [ ] All dependencies installed locally
- [ ] SSH access to server configured
- [ ] Server IP address confirmed

### Server Requirements
- [ ] Ubuntu 20.04/22.04 LTS running
- [ ] SSH access as root or sudo user
- [ ] Ports 80, 443, 22 open in firewall
- [ ] Nginx installed: `nginx -v`
- [ ] Node.js installed: `node -v`
- [ ] PM2 installed: `pm2 -v`
- [ ] Certbot installed: `certbot --version`

## 🚀 Deployment Steps

### Option 1: Automated Deployment (Recommended)
```powershell
cd C:\Users\there\Downloads\InvoChain
scripts\deploy-g1t2.bat all
```

- [ ] Build website completed
- [ ] Build Flutter app completed
- [ ] Upload website files completed
- [ ] Upload app files completed
- [ ] Upload backend files completed
- [ ] Backend dependencies installed on server
- [ ] PM2 started backend
- [ ] Nginx configuration uploaded
- [ ] Nginx configuration enabled
- [ ] Nginx reloaded successfully

### Option 2: Manual Deployment
See `docs/DEPLOY-G1T2.md` for detailed manual steps.

## 🔐 SSL Certificates

SSH to server and run:

```bash
# Main domain
certbot --nginx -d g1t2.drshaiban.cloud

# App subdomain  
certbot --nginx -d app.g1t2.drshaiban.cloud
```

- [ ] SSL certificate for g1t2.drshaiban.cloud obtained
- [ ] SSL certificate for app.g1t2.drshaiban.cloud obtained
- [ ] Auto-renewal configured
- [ ] Nginx reloaded with SSL config

## ✅ Verification

### Website (g1t2.drshaiban.cloud)
```bash
curl -I https://g1t2.drshaiban.cloud
```
- [ ] Returns HTTP 200 OK
- [ ] Page loads in browser
- [ ] Download buttons work
- [ ] "Launch Web App" button links to app.g1t2.drshaiban.cloud

### Flutter App (app.g1t2.drshaiban.cloud)
```bash
curl -I https://app.g1t2.drshaiban.cloud
```
- [ ] Returns HTTP 200 OK
- [ ] App loads in browser
- [ ] No console errors
- [ ] Login/signup pages accessible

### Backend API
```bash
curl https://g1t2.drshaiban.cloud/api/health
```
- [ ] Returns `{"status":"OK",...}`
- [ ] API accessible from both domains
- [ ] CORS headers present
- [ ] JWT authentication working

### Security
- [ ] HTTP redirects to HTTPS on both domains
- [ ] SSL certificates valid and trusted
- [ ] No mixed content warnings
- [ ] Security headers present
- [ ] CORS properly configured

### Backend Status
```bash
ssh root@drshaiban.cloud "pm2 status"
```
- [ ] PM2 shows `invochain-api` online
- [ ] Backend auto-starts on reboot
- [ ] No errors in PM2 logs: `pm2 logs invochain-api`

## 🧪 Functional Testing

### Test User Journey
- [ ] Visit https://g1t2.drshaiban.cloud
- [ ] Click "🚀 Launch Web App" button
- [ ] Redirected to https://app.g1t2.drshaiban.cloud
- [ ] Sign up new account (use test email)
- [ ] Login successful, redirected to dashboard
- [ ] Create test invoice
- [ ] Create test investment
- [ ] View blockchain transactions
- [ ] Logout and login again

### Test API Endpoints
```bash
# Health check
curl https://g1t2.drshaiban.cloud/api/health

# Signup
curl -X POST https://g1t2.drshaiban.cloud/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","name":"Test User","role":"investor"}'

# Login
curl -X POST https://g1t2.drshaiban.cloud/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

- [ ] Health endpoint returns 200
- [ ] Signup creates new user
- [ ] Login returns JWT token
- [ ] Protected routes require authentication

## 📊 Monitoring Setup

### Logs
```bash
# PM2 logs
pm2 logs invochain-api

# Nginx website logs
tail -f /var/log/nginx/invochain-g1t2-website-access.log
tail -f /var/log/nginx/invochain-g1t2-website-error.log

# Nginx app logs
tail -f /var/log/nginx/invochain-g1t2-app-access.log
tail -f /var/log/nginx/invochain-g1t2-app-error.log
```

- [ ] PM2 logs accessible
- [ ] Nginx access logs show traffic
- [ ] No errors in Nginx error logs
- [ ] Backend logs show API requests

### Health Monitoring (Optional)
- [ ] Setup uptime monitoring (e.g., UptimeRobot)
- [ ] Configure email alerts for downtime
- [ ] Monitor disk space usage
- [ ] Monitor SSL certificate expiration

## 🔧 Configuration Files

### Verify on Server
```bash
# Check Nginx config
cat /etc/nginx/sites-enabled/invochain-g1t2

# Check backend .env
cat /var/www/invochain-g1t2/backend/.env

# Check PM2 process
pm2 describe invochain-api
```

- [ ] Nginx config matches docs/nginx-g1t2.conf
- [ ] Backend .env has JWT_SECRET set
- [ ] PM2 configured for auto-restart
- [ ] File permissions correct (755 directories, 644 files)

## 📝 Documentation

- [ ] Update README.md with new URLs
- [ ] Document any custom server configurations
- [ ] Save deployment date and version
- [ ] Update team/stakeholders on new URLs

## 🎉 Post-Deployment

### Announce New URLs
Update these locations:
- [ ] README.md
- [ ] Email signatures
- [ ] Social media profiles
- [ ] Business cards
- [ ] Partner integrations

### Backup Configuration
```bash
# Backup entire deployment
ssh root@drshaiban.cloud "tar -czf /root/invochain-backup-$(date +%Y%m%d).tar.gz /var/www/invochain-g1t2"
```

- [ ] Initial backup created
- [ ] Backup schedule configured
- [ ] Backup restoration tested

### Performance Optimization (Optional)
- [ ] Enable Nginx gzip compression
- [ ] Configure browser caching
- [ ] Setup CDN for static assets
- [ ] Enable HTTP/2 push
- [ ] Optimize database queries

## 🚨 Rollback Plan

If deployment fails:
1. [ ] Keep previous deployment files
2. [ ] Document what went wrong
3. [ ] Restore from backup if needed
4. [ ] Switch Nginx to old configuration
5. [ ] Reload services

## ✅ Final Checklist

- [ ] All DNS records configured
- [ ] All SSL certificates valid
- [ ] Website live and functional
- [ ] App live and functional
- [ ] API responding correctly
- [ ] HTTPS enforced
- [ ] CORS working
- [ ] PM2 auto-restart enabled
- [ ] Logs accessible
- [ ] Team notified
- [ ] Documentation updated

---

## 📞 Quick Commands

### Deploy Everything
```powershell
scripts\deploy-g1t2.bat all
```

### Deploy Individual Components
```powershell
scripts\deploy-g1t2.bat website   # Website only
scripts\deploy-g1t2.bat app       # Flutter app only
scripts\deploy-g1t2.bat backend   # Backend API only
```

### Server Management
```bash
# Restart backend
ssh root@drshaiban.cloud "pm2 restart invochain-api"

# Reload Nginx
ssh root@drshaiban.cloud "systemctl reload nginx"

# View logs
ssh root@drshaiban.cloud "pm2 logs invochain-api"
```

---

**Deployment Date**: _________________

**Deployed By**: _________________

**Server IP**: _________________

**Notes**: _________________
