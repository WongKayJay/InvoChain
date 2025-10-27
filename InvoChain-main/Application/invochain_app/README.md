# InvoChain Flutter App

A mobile application for InvoChain - Transparent, secure invoice financing verified on blockchain.

## Features

- **Home Dashboard**: Quick stats and actions for SMEs and investors
- **Invoice Management**: Submit, track, and manage invoices with blockchain verification
- **Investment Opportunities**: Browse verified invoice opportunities with risk grading
- **Portfolio Tracking**: Monitor active investments and returns
- **Profile & Settings**: User profile, KYC verification, dark mode support

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for mobile development
- VS Code or Android Studio with Flutter plugin

### Installation

1. **Clone the repository**
   ```bash
   cd Application/invochain_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For iOS simulator
   flutter run -d ios

   # For Android emulator
   flutter run -d android

   # For Chrome (web)
   flutter run -d chrome
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
│   ├── main_navigation.dart  # Bottom navigation
│   ├── home_screen.dart      # Home dashboard
│   ├── invoices_screen.dart  # Invoice management
│   ├── invest_screen.dart    # Investment opportunities
│   ├── portfolio_screen.dart # Portfolio tracking
│   └── profile_screen.dart   # User profile & settings
├── widgets/                  # Reusable widgets
│   ├── stat_card.dart        # Stat display widget
│   └── action_card.dart      # Action button widget
├── services/                 # Business logic
│   └── theme_provider.dart   # Theme management
└── models/                   # Data models (to be added)
```

## Key Technologies

- **Flutter**: Cross-platform mobile framework
- **Provider**: State management
- **Google Fonts**: Inter font family
- **Material 3**: Modern UI design system

## Theme Support

The app supports both light and dark modes:
- Light mode: Clean white interface with blue accents (#2563EB)
- Dark mode: Dark slate backgrounds (#0F172A) with cyan accents

Toggle theme in Profile → Dark Mode switch

## Features Overview

### Home Screen
- Welcome banner with gradient
- Quick stats (Total Funded, Active Deals)
- Quick actions (Submit Invoice, Browse Investments, Track On-Chain)

### Invoices Screen
- List of user's invoices with status badges
- Filter and search functionality (skeleton)
- Floating action button to add new invoice

### Invest Screen
- Browse investment opportunities
- Filter by grade (A, B) and compliance (Shariah)
- View returns, tenor, and risk grading
- One-click investment action

### Portfolio Screen
- Total portfolio value with trend indicator
- Performance metrics (Total Returns, Active investments)
- Active investment tracking with progress bars

### Profile Screen
- User information and verification status
- Dark mode toggle
- Settings (Notifications, Security, KYC)
- Support links (Help Center, Terms, Privacy)
- Logout functionality

## Next Steps

To complete the app, implement:

1. **Authentication**: Login, signup, and session management
2. **API Integration**: Connect to InvoChain backend
3. **Blockchain Integration**: Web3 wallet connection and transaction signing
4. **KYC Flow**: Document upload and verification
5. **Invoice Upload**: Camera integration and OCR
6. **Payment Integration**: Escrow and fund transfer
7. **Real-time Updates**: WebSocket for live status
8. **Analytics**: Track user behavior and conversion
9. **Push Notifications**: Alert users of status changes
10. **Testing**: Unit tests, widget tests, integration tests

## Design System

**Colors:**
- Primary: #2563EB (Blue)
- Secondary: #1E40AF (Dark Blue)
- Success: Green
- Warning: Orange
- Error: Red

**Typography:**
- Font Family: Inter (Google Fonts)
- Headlines: Bold, 24-32px
- Body: Regular, 14-16px
- Captions: Regular, 12px

**Spacing:**
- Small: 8px
- Medium: 16px
- Large: 24px

## Contributing

1. Follow Flutter style guide
2. Use meaningful commit messages
3. Write widget tests for new components
4. Update documentation

## License

Copyright © 2025 InvoChain. All rights reserved.
