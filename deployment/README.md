# InvoChain Deployment Files

This directory contains all necessary files and documentation for deploying InvoChain to `g1t2.drshaiban.cloud`.

---

## 📁 Directory Contents

```
deployment/
├── QUICKSTART.md          # 15-minute quick deployment guide
├── DEPLOYMENT.md          # Comprehensive deployment documentation (in root)
├── HOSTINGER.md          # Hostinger DNS configuration guide
├── nginx.conf            # Nginx server configuration
├── deploy.sh             # Linux/Mac deployment script
├── deploy.bat            # Windows deployment script
├── server-setup.sh       # Automated server setup script
├── backup.sh             # Automated backup script
└── README.md             # This file
```

---

## 🚀 Quick Start

### 1. Configure DNS (5 minutes)

Follow `HOSTINGER.md` to set up `g1t2.drshaiban.cloud` DNS record.

### 2. Setup Server (5 minutes)

```bash
ssh root@drshaiban.cloud
curl -fsSL https://raw.githubusercontent.com/WongKayJay/InvoChain/main/deployment/server-setup.sh | bash
```

### 3. Build & Deploy (5 minutes)

**Windows:**
```powershell
cd c:\Users\there\Downloads\InvoChain
.\deployment\deploy.bat all
```

**Linux/Mac:**
```bash
cd /path/to/InvoChain
chmod +x deployment/deploy.sh
./deployment/deploy.sh all
```

---

## 📚 Documentation

- **`QUICKSTART.md`** - Fast deployment in 15 minutes
- **`../DEPLOYMENT.md`** - Complete deployment guide with troubleshooting
- **`HOSTINGER.md`** - DNS configuration steps for Hostinger

---

## ⚙️ Configuration Files

### `nginx.conf`

Production-ready Nginx configuration with:
- HTTPS redirect
- SSL/TLS configuration
- Security headers
- Gzip compression
- Static asset caching
- Separate routes for website and Flutter app

**Installation:**
```bash
sudo cp deployment/nginx.conf /etc/nginx/sites-available/invochain
sudo ln -s /etc/nginx/sites-available/invochain /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🛠️ Deployment Scripts

### `deploy.bat` (Windows)

Automated deployment script for Windows users.

**Usage:**
```powershell
# Deploy everything
.\deployment\deploy.bat all

# Deploy website only
.\deployment\deploy.bat website

# Deploy Flutter app only
.\deployment\deploy.bat app
```

### `deploy.sh` (Linux/Mac)

Automated deployment script using rsync.

**Usage:**
```bash
chmod +x deployment/deploy.sh

# Deploy everything
./deployment/deploy.sh all

# Deploy website only
./deployment/deploy.sh website

# Deploy Flutter app only
./deployment/deploy.sh app
```

---

## 🔧 Server Scripts

### `server-setup.sh`

Automated server initialization script that:
- Updates system packages
- Installs Nginx, Git, Certbot
- Configures firewall
- Creates directory structure
- Sets proper permissions

**Remote execution:**
```bash
curl -fsSL https://raw.githubusercontent.com/WongKayJay/InvoChain/main/deployment/server-setup.sh | bash
```

**Local execution:**
```bash
chmod +x deployment/server-setup.sh
./deployment/server-setup.sh
```

### `backup.sh`

Automated backup script for:
- Website files
- Flutter app
- Nginx configuration
- SSL certificates

**Setup cron job:**
```bash
# Copy to server
sudo cp deployment/backup.sh /usr/local/bin/backup-invochain.sh
sudo chmod +x /usr/local/bin/backup-invochain.sh

# Add to crontab (runs daily at 2 AM)
sudo crontab -e
# Add: 0 2 * * * /usr/local/bin/backup-invochain.sh
```

**Manual execution:**
```bash
sudo /usr/local/bin/backup-invochain.sh
```

---

## 🔒 SSL Certificate

After DNS propagation, get free SSL certificate:

```bash
sudo certbot --nginx -d g1t2.drshaiban.cloud
```

Certbot will:
- Automatically configure SSL in Nginx
- Set up HTTP to HTTPS redirect
- Configure auto-renewal

**Test auto-renewal:**
```bash
sudo certbot renew --dry-run
```

---

## 🌐 URLs After Deployment

- **Marketing Website**: https://g1t2.drshaiban.cloud
- **Flutter Web App**: https://g1t2.drshaiban.cloud/app
- **Mobile Installer**: https://g1t2.drshaiban.cloud/downloads/InvoChain-Mobile-Installer.html
- **Desktop Installer**: https://g1t2.drshaiban.cloud/downloads/InvoChain-Desktop-Installer.html

---

## 🔄 Update Workflow

### Update Website Content

```bash
# On server
ssh root@drshaiban.cloud
cd /var/www/invochain/InvoChain
git pull origin main
cp -r Website/* /var/www/invochain/website/
sudo systemctl reload nginx
```

### Update Flutter App

```powershell
# Local machine
cd Application\invochain_app
flutter build web --release
scp -r build\web\* root@drshaiban.cloud:/var/www/invochain/app/
```

---

## 📊 Monitoring

### View Logs

```bash
# Access logs
sudo tail -f /var/log/nginx/invochain.access.log

# Error logs
sudo tail -f /var/log/nginx/invochain.error.log

# All Nginx logs
sudo tail -f /var/log/nginx/error.log
```

### Check Status

```bash
# Nginx status
sudo systemctl status nginx

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

---

## 🐛 Troubleshooting

### Site Not Accessible

1. Check DNS: `nslookup g1t2.drshaiban.cloud`
2. Check Nginx: `sudo systemctl status nginx`
3. Check firewall: `sudo ufw status`
4. Check logs: `sudo tail -100 /var/log/nginx/error.log`

### SSL Issues

1. Check certificate: `sudo certbot certificates`
2. Renew manually: `sudo certbot renew --force-renewal`
3. Verify DNS propagation first

### Flutter App Not Loading

1. Verify files: `ls -la /var/www/invochain/app/`
2. Check permissions: `sudo chmod -R 755 /var/www/invochain/app/`
3. Clear browser cache
4. Check browser console (F12) for errors

---

## 📦 Backup & Restore

### Create Backup

```bash
sudo /usr/local/bin/backup-invochain.sh
```

Backups stored in: `/var/backups/invochain/`

### Restore from Backup

```bash
cd /var/backups/invochain
tar -xzf invochain_backup_YYYYMMDD_HHMMSS.tar.gz
sudo cp -r invochain_backup_YYYYMMDD_HHMMSS/website/* /var/www/invochain/website/
sudo cp -r invochain_backup_YYYYMMDD_HHMMSS/app/* /var/www/invochain/app/
sudo systemctl reload nginx
```

---

## 🎯 Production Checklist

Before going live:

- [ ] DNS configured and propagated
- [ ] Server setup complete
- [ ] Files deployed
- [ ] Nginx configured
- [ ] SSL certificate installed
- [ ] HTTPS redirect working
- [ ] Website accessible
- [ ] Flutter app accessible
- [ ] Download buttons functional
- [ ] Mobile responsive
- [ ] Performance tested
- [ ] Backups configured
- [ ] Monitoring setup
- [ ] Error pages configured
- [ ] Security headers verified

---

## 📞 Support

- **Documentation**: See individual markdown files
- **GitHub**: https://github.com/WongKayJay/InvoChain
- **Issues**: Open an issue on GitHub
- **Hostinger Support**: https://support.hostinger.com

---

## 🔗 Quick Links

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Certbot Guide](https://certbot.eff.org/)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Hostinger Knowledge Base](https://support.hostinger.com)

---

**Last Updated**: October 28, 2025  
**Version**: 1.0.0  
**Deployment Target**: g1t2.drshaiban.cloud

© 2025 InvoChain - Transparent, Secure Invoice Financing
