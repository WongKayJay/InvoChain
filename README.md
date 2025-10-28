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
 frontend/
    Application/          # Flutter app
       invochain_app/
    Website/              # Marketing site
 backend/                  # Future backend services
 deployment/               # Nginx configs & scripts
 requirements.txt          # Dependencies
 plan.txt                  # System design
 README.md                 # This file
 DEPLOYMENT.md             # Deployment guide
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

# Setup Flutter app
cd frontend\Application\invochain_app
flutter pub get

# Setup website
cd ..\..\Website
npm install
```

---

##  Running Locally

### Flutter Application
```powershell
cd frontend\Application\invochain_app
flutter run -d chrome
```

### Marketing Website
```powershell
cd frontend\Website
npm run dev
```
**Access at:** `http://localhost:5173`

---

##  Building for Production

### Flutter Web
```powershell
cd frontend\Application\invochain_app
flutter build web --release
```

### Website
```powershell
cd frontend\Website
npm run build
```

---

##  Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) or [deployment/QUICKSTART.md](deployment/QUICKSTART.md) for complete deployment instructions to g1t2.drshaiban.cloud.

---

##  Testing

```powershell
# Code analysis
flutter analyze

# Run tests
flutter test
```

---

##  Documentation

- [plan.txt](plan.txt) - System architecture
- [requirements.txt](requirements.txt) - Dependencies
- [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment guide
- [VERIFICATION.md](VERIFICATION.md) - System verification

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
