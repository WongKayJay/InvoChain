# Frontend

This folder contains all frontend applications.

## Structure

### `website/`
Marketing website built with HTML, CSS, and JavaScript.
- **Tech Stack**: HTML5, CSS3, Vanilla JavaScript, Vite
- **Purpose**: Landing page to promote InvoChain platform
- **Run**: `cd website && npm run dev`
- **URL**: http://localhost:5173

### `mobile-app/`
Cross-platform mobile application built with Flutter.
- **Tech Stack**: Flutter 3.35.6, Dart
- **Purpose**: Main InvoChain application for investors and SMEs
- **Run**: `invochain` command (builds and serves on port 8080)
- **Build**: `flutter build web`
- **Platforms**: Web, Android, iOS

## Quick Start

### Website
```bash
cd website
npm install
npm run dev
```

### Mobile App
```bash
# Quick command (recommended)
invochain

# Manual build and serve
cd mobile-app
flutter build web
cd build/web
python -m http.server 8080
```
