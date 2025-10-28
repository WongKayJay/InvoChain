# InvoChain - Project Navigation Guide

Welcome to InvoChain! This guide will help you navigate the reorganized project structure.

## 📁 Folder Structure

```
InvoChain/
├── 📱 frontend/           → All frontend applications
│   ├── website/          → Marketing website (Vite)
│   └── mobile-app/       → Flutter cross-platform app
├── 🔧 backend/           → API server & database
├── 📚 docs/              → All documentation files
└── 🛠️ scripts/           → Deployment & utility scripts
```

---

## 🚀 Quick Commands

### Run Complete App
```powershell
invochain
# Builds and serves Flutter app on http://localhost:8080
```

### Run Backend API
```powershell
cd backend
node server.js
# API available at http://localhost:3000
```

### Run Marketing Website
```powershell
cd frontend\website
npm run dev
# Website at http://localhost:5173
```

---

## 📂 What's Where?

### Frontend (`frontend/`)
- **`website/`** - Landing page, marketing content, downloads
  - Built with: Vite, HTML, CSS, JavaScript
  - Command: `npm run dev`
  
- **`mobile-app/`** - Main InvoChain application
  - Built with: Flutter 3.35.6
  - Command: `invochain` or `flutter run -d chrome`

### Backend (`backend/`)
- **`server.js`** - Express API server
- **`routes/`** - API endpoints (auth, investments, invoices)
- **`models/`** - Database models (User, Investment, Invoice)
- **`database/`** - DB connections (SQLite for dev, PostgreSQL for prod)
- **`middleware/`** - Authentication & validation

### Documentation (`docs/`)
- **AUTHENTICATION_TESTING.md** - How to test auth
- **BACKEND_SETUP.md** - Backend installation
- **DEPLOYMENT.md** - Production deployment
- **FEATURE_UPDATES.md** - Feature changelog
- **THEME_UPDATES.md** - UI/UX updates
- **VERIFICATION.md** - Testing procedures
- **QUICKSTART.md** - Fast deployment guide
- **HOSTINGER.md** - Hostinger deployment
- **nginx.conf** - Web server config
- **plan.txt** - Original system design

### Scripts (`scripts/`)
- **deploy.sh** - Linux/Mac deployment
- **deploy.bat** - Windows deployment
- **backup.sh** - Database backup
- **server-setup.sh** - Server configuration
- **requirements.txt** - Python dependencies

---

## 🎯 Common Tasks

### Starting Development
```powershell
# 1. Backend
cd backend
npm install
node server.js

# 2. Frontend (new terminal)
invochain
```

### Building for Production
```powershell
# Flutter app
cd frontend\mobile-app
flutter build web --release

# Website
cd frontend\website
npm run build
```

### Deploying
```powershell
# Windows
scripts\deploy.bat

# Linux/Mac
./scripts/deploy.sh
```

### Viewing Documentation
```powershell
# Open docs folder
cd docs
explorer .

# Or read specific docs
Get-Content docs\QUICKSTART.md
```

---

## 💡 Tips

1. **Use the `invochain` command** - It's configured to build and serve the complete app
2. **Check `docs/` for guides** - All documentation is now in one place
3. **Scripts are in `scripts/`** - Deployment and utility scripts
4. **Frontend paths changed** - Update any bookmarks:
   - `frontend/Application/invochain_app` → `frontend/mobile-app`
   - `frontend/Website` → `frontend/website`

---

## 📞 Need Help?

- **Setup Issues**: See `docs/BACKEND_SETUP.md`
- **Deployment**: See `docs/QUICKSTART.md` or `docs/DEPLOYMENT.md`
- **Features**: See `docs/FEATURE_UPDATES.md`
- **Testing**: See `docs/AUTHENTICATION_TESTING.md`

---

*Last Updated: October 29, 2025*
*Structure Version: 2.0 (Reorganized)*
