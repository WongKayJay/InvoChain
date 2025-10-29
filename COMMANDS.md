# InvoChain Terminal Commands - Quick Reference

## 🚀 Updated PowerShell Commands

All commands have been updated to work with the new reorganized folder structure!

---

## 📋 Available Commands

### Main Commands

| Command | Description | URL |
|---------|-------------|-----|
| `invochain` | Build and serve Flutter app | http://localhost:8080 |
| `invochain-web` | Run marketing website (Vite) | http://localhost:5173 |
| `invochain-api` | Run backend API server | http://localhost:3000 |
| `invochain-all` | Start all services in separate windows | All ports |
| `invochain-dir` | Navigate to project directory | - |
| `invochain-help` | Show help menu | - |

---

## 🎯 Command Details

### `invochain`
**Flutter Web Application**
```powershell
invochain
```
- Builds the Flutter app for production
- Serves on http://localhost:8080
- Includes the new Blockchain Transactions screen
- Uses: `frontend/mobile-app/`

### `invochain-web`
**Marketing Website (Vite Dev Server)**
```powershell
invochain-web
```
- Runs Vite development server
- Hot reload enabled
- Serves on http://localhost:5173
- Uses: `frontend/website/`
- Equivalent to: `cd frontend/website && npm run dev`

### `invochain-api`
**Backend API Server**
```powershell
invochain-api
```
- Starts Node.js + Express server
- SQLite database ready
- Serves on http://localhost:3000
- Uses: `backend/`
- Equivalent to: `cd backend && node server.js`

### `invochain-all`
**All Services at Once**
```powershell
invochain-all
```
- Opens 3 separate PowerShell windows
- Starts backend, website, and Flutter app
- Perfect for full-stack development
- Recommended for comprehensive testing

### `invochain-dir`
**Navigate to Project**
```powershell
invochain-dir
```
- Changes directory to InvoChain root
- Shows folder structure
- Quick way to get to the project

### `invochain-help`
**Command Help**
```powershell
invochain-help
```
- Shows all available commands
- Displays project structure
- Quick reference guide

---

## 🗂️ Updated Folder Structure

Commands now use these paths:

```
InvoChain/
├── frontend/
│   ├── website/           → invochain-web
│   └── mobile-app/        → invochain
├── backend/               → invochain-api
├── docs/                  → Documentation
└── scripts/               → Deployment scripts
```

---

## 🔄 What Changed from Old Commands

### Old Structure → New Structure

**Website:**
- Old: `frontend/Website/`
- New: `frontend/website/`
- Command: `invochain-web`

**Flutter App:**
- Old: `frontend/Application/invochain_app/`
- New: `frontend/mobile-app/`
- Command: `invochain`

**Backend:**
- Location: `backend/` (unchanged)
- Command: `invochain-api` (new!)

---

## 💡 Usage Examples

### Start Development Session
```powershell
# Option 1: All at once (recommended)
invochain-all

# Option 2: Individual services
# Terminal 1:
invochain-api

# Terminal 2:
invochain-web

# Terminal 3:
invochain
```

### Test Backend API
```powershell
# Start backend
invochain-api

# In another terminal, test:
Invoke-RestMethod -Uri "http://localhost:3000/health"
```

### Build Production
```powershell
# Flutter app (production build)
cd frontend\mobile-app
flutter build web --release

# Website (production build)
cd frontend\website
npm run build
```

### Deploy to g1t2.drshaiban.cloud
```powershell
# Deploy everything
.\scripts\deploy-g1t2.bat all

# Deploy specific components
.\scripts\deploy-g1t2.bat website
.\scripts\deploy-g1t2.bat app
.\scripts\deploy-g1t2.bat backend
```

---

## 🆘 Troubleshooting

### Commands Not Found
```powershell
# Reload PowerShell profile
. $PROFILE

# Or restart PowerShell
```

### Port Already in Use
```powershell
# Check what's using a port
Get-NetTCPConnection -LocalPort 3000,5173,8080 -State Listen

# Kill process on port (example: 3000)
Stop-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess -Force
```

### Dependencies Missing
```powershell
# Website dependencies
cd frontend\website
npm install

# Backend dependencies
cd backend
npm install

# Flutter dependencies
cd frontend\mobile-app
flutter pub get
```

---

## 📦 Quick Setup for New Machine

```powershell
# 1. Clone repository
git clone https://github.com/WongKayJay/InvoChain.git
cd InvoChain

# 2. Install dependencies
cd frontend\website
npm install
cd ..\..

cd backend
npm install
cd ..

cd frontend\mobile-app
flutter pub get
cd ..\..

# 3. Reload PowerShell profile
. $PROFILE

# 4. Start development
invochain-all
```

---

## 🎯 Common Workflows

### Development Workflow
```powershell
# 1. Start all services
invochain-all

# 2. Make changes to code
# 3. Website auto-reloads (Vite HMR)
# 4. Rebuild Flutter app: invochain
# 5. Restart backend: Ctrl+C then invochain-api
```

### Testing Workflow
```powershell
# 1. Start backend
invochain-api

# 2. Test API endpoints
Invoke-RestMethod -Uri "http://localhost:3000/api/health"

# 3. Start frontend
invochain

# 4. Open browser at localhost:8080
```

### Deployment Workflow
```powershell
# 1. Build everything
cd frontend\website
npm run build

cd ..\mobile-app
flutter build web --release

# 2. Deploy
cd ..\..
.\scripts\deploy-g1t2.bat all

# 3. Verify
# Visit: https://g1t2.drshaiban.cloud
```

---

## 📞 Additional Resources

- **Full Deployment Guide**: `docs/DEPLOY-G1T2.md`
- **Deployment Checklist**: `DEPLOYMENT-CHECKLIST-G1T2.md`
- **Project Navigation**: `NAVIGATION.md`
- **Backend Setup**: `docs/BACKEND_SETUP.md`
- **Main README**: `README.md`

---

## 🎉 Summary

**Commands are now updated and ready to use!**

✅ `invochain` - Flutter app on port 8080  
✅ `invochain-web` - Website on port 5173  
✅ `invochain-api` - Backend on port 3000  
✅ `invochain-all` - All services in separate windows  
✅ `invochain-help` - Show command reference  

All commands work with the new `frontend/website/` and `frontend/mobile-app/` structure!

---

*Last Updated: October 29, 2025*  
*PowerShell Profile: $PROFILE*
