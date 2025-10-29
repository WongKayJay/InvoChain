# InvoChain

<div align="center">

![InvoChain](https://img.shields.io/badge/InvoChain-Blockchain%20Invoice%20Financing-667eea?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.35.6-02569B?style=for-the-badge&logo=flutter)
![Vite](https://img.shields.io/badge/Vite-7.1.12-646CFF?style=for-the-badge&logo=vite)
![License](https://img.shields.io/badge/License-ISC-green?style=for-the-badge)

**A blockchain-verified invoice financing platform connecting SMEs with investors**

[Live Demo](https://g1t2.drshaiban.cloud)  [Documentation](DEPLOYMENT.md)  [Report Bug](https://github.com/WongKayJay/InvoChain/issues)

</div>

---

##  Table of Contents

- [About](#about)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Setup Guide](#setup-guide)
- [Running Locally](#running-locally)
- [Building for Production](#building-for-production)
- [Deployment](#deployment)
- [Testing](#testing)
- [Documentation](#documentation)
- [License](#license)

---

##  About

InvoChain is a transparent, secure invoice financing platform that enables SMEs to unlock liquidity while providing investors with blockchain-verified investment opportunities.

**Key Value Propositions:**
-  Escrow-Backed Security
-  Blockchain Verification
-  Real-Time Portfolio Tracking
-  Multi-Platform Support (Web, iOS, Android, Windows, macOS)
-  Shariah-Compliant Options
-  24/7 Transparency

---

##  Features

### Platform Features
- User authentication with session persistence
- Investment opportunity marketplace
- Portfolio management dashboard
- Invoice creation and tracking
- Blockchain transaction simulation
- Dark/Light theme support
- Responsive cross-platform design

---

##  Technologies Used

**Frontend:**
- Flutter 3.35.6 (Dart)
- Provider (State Management)
- HTML5, CSS3, JavaScript
- Vite 7.1.12 (Build Tool)

**Storage:**
- SharedPreferences (Authentication)
- AppDataProvider (State Management)

**Deployment:**
- Nginx Web Server
- Let's Encrypt SSL
- Ubuntu/Debian Linux

---

##  Project Structure

```
InvoChain/
├── frontend/                 # Frontend applications
│   ├── website/             # Marketing website (Vite + HTML/CSS/JS)
│   └── mobile-app/          # Flutter cross-platform app
├── backend/                 # Backend API server
│   ├── database/           # Database connections & migrations
│   ├── models/             # Data models (User, Investment, Invoice)
│   ├── routes/             # API endpoints (auth, investments, invoices)
│   ├── middleware/         # Authentication middleware
│   └── server.js           # Express server
├── deployment/              # All deployment files
│   ├── deploy-g1t2.bat     # Windows deployment script
│   ├── deploy.sh           # Linux deployment script
│   ├── DEPLOY-G1T2.md      # Deployment guide
│   ├── nginx-g1t2.conf     # Nginx configuration
│   └── README.md           # Deployment documentation
├── docs/                    # Project documentation
│   ├── AUTHENTICATION_TESTING.md
│   ├── BACKEND_SETUP.md
│   ├── FEATURE_UPDATES.md
│   ├── THEME_UPDATES.md
│   ├── VERIFICATION.md
│   └── QUICKSTART.md
├── requirements.txt         # Installation requirements
├── built.txt               # Complete dependency list
├── plan.txt                # System design overview
├── COMMANDS.md             # Command reference
└── README.md               # This file
```

---

##  Setup Guide

### Prerequisites
- Flutter SDK 3.35.6+
- Node.js v20.x+
- Git

### Installation

**Windows PowerShell:**

```powershell
# Clone repository
git clone https://github.com/WongKayJay/InvoChain.git
cd InvoChain

# Setup backend
cd backend
npm install

# Setup Flutter app
cd ..\frontend\mobile-app
flutter pub get

# Setup website
cd ..\website
npm install
```

---

##  Running Locally

### Quick Start (All-in-One)
```powershell
# Run the complete Flutter app (builds and serves)
invochain
```
**Access at:** `http://localhost:8080`

### Backend API
```powershell
cd backend
node server.js
```
**API at:** `http://localhost:3000`
**Demo Accounts:** 
- Username: `demo_investor` Password: `demo123`
- Username: `demo_sme` Password: `demo123`

### Flutter Application (Manual)
```powershell
cd frontend\mobile-app
flutter run -d chrome
```

### Marketing Website
```powershell
cd frontend\website
npm run dev
```
**Access at:** `http://localhost:5173`

---

##  Building for Production

### Flutter Web
```powershell
cd frontend\mobile-app
flutter build web --release
```

### Website
```powershell
cd frontend\website
npm run build
```

### Backend
```powershell
cd backend
# Set production environment variables in .env
# Then deploy to server
```

---

##  Deployment

See [deployment/DEPLOY-G1T2.md](deployment/DEPLOY-G1T2.md) or [docs/QUICKSTART.md](docs/QUICKSTART.md) for complete deployment instructions.

**Available Scripts:**
- `deployment/deploy-g1t2.bat` - Windows deployment to g1t2.drshaiban.cloud
- `deployment/deploy.sh` - Linux/Mac deployment
---

##  Testing

### Backend API
```powershell
cd backend
npm test  # If tests are configured
```

### Flutter App
```powershell
cd frontend\mobile-app
flutter analyze  # Code analysis
flutter test     # Run tests
```

---

##  Documentation

### Core Documentation (Root Level)
- **[requirements.txt](requirements.txt)** - Installation requirements and setup guide
- **[built.txt](built.txt)** - Complete dependency list with versions
- **[plan.txt](plan.txt)** - System design and architecture overview
- **[COMMANDS.md](COMMANDS.md)** - Command reference guide
- **[PROJECT-VERIFICATION.md](PROJECT-VERIFICATION.md)** - Project verification checklist

### Deployment Documentation (deployment/)
- **[deployment/DEPLOY-G1T2.md](deployment/DEPLOY-G1T2.md)** - Complete deployment guide
- **[deployment/DEPLOYMENT-CHECKLIST-G1T2.md](deployment/DEPLOYMENT-CHECKLIST-G1T2.md)** - Step-by-step checklist
- **[deployment/HOSTINGER.md](deployment/HOSTINGER.md)** - Hostinger DNS configuration
- **[deployment/README.md](deployment/README.md)** - Deployment folder guide

### Project Documentation (docs/)
- **[docs/AUTHENTICATION_TESTING.md](docs/AUTHENTICATION_TESTING.md)** - Authentication testing guide
- **[docs/BACKEND_SETUP.md](docs/BACKEND_SETUP.md)** - Backend setup instructions
- **[docs/FEATURE_UPDATES.md](docs/FEATURE_UPDATES.md)** - Feature updates and changelog
- **[docs/THEME_UPDATES.md](docs/THEME_UPDATES.md)** - UI theme documentation
- **[docs/VERIFICATION.md](docs/VERIFICATION.md)** - System verification procedures
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - Quick start guide

---

##  License

ISC License

---

##  Support

- Issues: [GitHub Issues](https://github.com/WongKayJay/InvoChain/issues)
- Email: support@invochain.com

---

<div align="center">

**Made with  by the InvoChain Team**

</div>
