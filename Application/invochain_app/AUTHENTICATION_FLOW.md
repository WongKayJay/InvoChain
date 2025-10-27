# InvoChain Authentication Flow Diagram

## App Startup Flow
```
┌─────────────────────────────────────────────────────────────────────┐
│                         APP LAUNCHES                                 │
│                         (main.dart)                                  │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
                    ┌────────────────┐
                    │  AuthChecker   │
                    │   Widget       │
                    └────────┬───────┘
                             │
                    ┌────────▼────────┐
                    │ Check Session   │
                    │ (SharedPrefs)   │
                    └────────┬────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
          ❌ No Session              ✅ Valid Session
                │                         │
                ▼                         ▼
        ┌───────────────┐         ┌──────────────┐
        │ Login Screen  │         │    Main      │
        │               │         │ Navigation   │
        └───────────────┘         └──────────────┘
```

## Sign Up Flow
```
┌─────────────────┐
│  Login Screen   │
│                 │
│ [Sign Up Link] ◄────┐
└────────┬────────┘    │
         │             │
         ▼             │
┌────────────────────┐ │
│  Sign Up Screen    │ │
│                    │ │
│ • Full Name        │ │
│ • Email            │ │
│ • Password         │ │
│ • Confirm Password │ │
└────────┬───────────┘ │
         │             │
         ▼             │
┌────────────────────┐ │
│  Validate Inputs   │ │
│                    │ │
│ ✓ Email format     │ │
│ ✓ Password length  │ │
│ ✓ Passwords match  │ │
└────────┬───────────┘ │
         │             │
         ▼             │
┌────────────────────┐ │
│ Check Email Exists │ │
│  (Database Query)  │ │
└────────┬───────────┘ │
         │             │
    ┌────┴────┐        │
    │         │        │
❌ Exists  ✅ New      │
    │         │        │
    │         ▼        │
    │  ┌─────────────┐│
    │  │ Hash Pass   ││
    │  │ (SHA-256)   ││
    │  └──────┬──────┘│
    │         │       │
    │         ▼       │
    │  ┌─────────────┐│
    │  │ Insert User ││
    │  │ (Database)  ││
    │  └──────┬──────┘│
    │         │       │
    │         ▼       │
    │  ┌─────────────┐│
    │  │ Save Session││
    │  │(SharedPrefs)││
    │  └──────┬──────┘│
    │         │       │
    │         ▼       │
    │  ┌─────────────┐│
    │  │    Main     ││
    │  │ Navigation  ││
    │  └─────────────┘│
    │                 │
    └─────────────────┘
       Show Error
```

## Login Flow
```
┌─────────────────┐
│  Login Screen   │
│                 │
│ • Email         │
│ • Password      │
│                 │
│   [Login Btn]   │
└────────┬────────┘
         │
         ▼
┌────────────────────┐
│  Validate Inputs   │
│                    │
│ ✓ Email not empty  │
│ ✓ Password entered │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  Get User by Email │
│   (Database Query) │
└────────┬───────────┘
         │
    ┌────┴─────┐
    │          │
❌ Not Found ✅ Found
    │          │
    │          ▼
    │   ┌─────────────┐
    │   │ Hash Input  │
    │   │  Password   │
    │   └──────┬──────┘
    │          │
    │          ▼
    │   ┌─────────────┐
    │   │  Compare    │
    │   │   Hashes    │
    │   └──────┬──────┘
    │          │
    │     ┌────┴────┐
    │     │         │
    │  ❌ Mismatch ✅ Match
    │     │         │
    │     │         ▼
    │     │  ┌─────────────┐
    │     │  │Update Last  │
    │     │  │   Login     │
    │     │  └──────┬──────┘
    │     │         │
    │     │         ▼
    │     │  ┌─────────────┐
    │     │  │Save Session │
    │     │  │(SharedPrefs)│
    │     │  └──────┬──────┘
    │     │         │
    │     │         ▼
    │     │  ┌─────────────┐
    │     │  │    Main     │
    │     │  │ Navigation  │
    │     │  └─────────────┘
    │     │
    └─────┴──────────────────
          Show Error
```

## Logout Flow
```
┌─────────────────┐
│ Profile Screen  │
│                 │
│  User Info      │
│  Settings       │
│                 │
│ [Logout Button] │
└────────┬────────┘
         │
         ▼
┌────────────────────┐
│ Confirmation Dialog│
│                    │
│ "Are you sure?"    │
│                    │
│ [Cancel] [Logout]  │
└────────┬───────────┘
         │
    ┌────┴────┐
    │         │
 Cancel    Confirm
    │         │
    │         ▼
    │  ┌─────────────┐
    │  │   Clear     │
    │  │  Session    │
    │  │(SharedPrefs)│
    │  └──────┬──────┘
    │         │
    │         ▼
    │  ┌─────────────┐
    │  │   Clear     │
    │  │ Current User│
    │  └──────┬──────┘
    │         │
    │         ▼
    │  ┌─────────────┐
    │  │  Navigate to│
    │  │Login Screen │
    │  └─────────────┘
    │
    └─────────────────
      Stay on Profile
```

## Database Operations Flow
```
┌──────────────────────────────────────────────────────────────┐
│                    DATABASE SERVICE                          │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐        │
│  │  Insert    │    │   Query    │    │   Update   │        │
│  │   User     │    │   User     │    │Last Login  │        │
│  └─────┬──────┘    └─────┬──────┘    └─────┬──────┘        │
│        │                 │                  │               │
│        └─────────────────┼──────────────────┘               │
│                          ▼                                  │
│              ┌───────────────────────┐                      │
│              │   SQLite Database     │                      │
│              │   invochain.db        │                      │
│              ├───────────────────────┤                      │
│              │  TABLE: users         │                      │
│              │  - id (PK)            │                      │
│              │  - email (UNIQUE)     │                      │
│              │  - password_hash      │                      │
│              │  - full_name          │                      │
│              │  - created_at         │                      │
│              │  - last_login         │                      │
│              └───────────────────────┘                      │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Password Security Flow
```
┌─────────────────┐
│  User Password  │
│  "myPassword123"│
└────────┬────────┘
         │
         ▼
┌────────────────────┐
│   UTF-8 Encoding   │
│   to bytes         │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│   SHA-256 Hash     │
│   Algorithm        │
└────────┬───────────┘
         │
         ▼
┌────────────────────────────────────────────────┐
│  Hash Output (Hexadecimal String)             │
│  "ef92b778bafe771e89245b89ecbc08a..."         │
└────────┬───────────────────────────────────────┘
         │
         ▼
┌────────────────────┐
│   Store in         │
│   Database         │
│   (password_hash)  │
└────────────────────┘

Note: Original password is NEVER stored!
```

## Session Management Flow
```
┌────────────────────────────────────────────────────────┐
│                  SharedPreferences                     │
│  (Persistent Key-Value Storage)                        │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Key: "is_logged_in"     │  Value: true/false         │
│  Key: "user_id"          │  Value: integer            │
│                                                        │
└────────────────────────────────────────────────────────┘
                           │
                           │ Read on App Start
                           │ Write on Login
                           │ Delete on Logout
                           │
                           ▼
                  ┌────────────────┐
                  │  AuthService   │
                  │                │
                  │ - currentUser  │
                  │ - isAuth       │
                  └────────────────┘
```

## Component Architecture
```
┌───────────────────────────────────────────────────────────┐
│                      PRESENTATION                         │
├───────────────────────────────────────────────────────────┤
│  • LoginScreen          • SignUpScreen                    │
│  • ProfileScreen        • AuthChecker                     │
└─────────────────────────┬─────────────────────────────────┘
                          │
                          ▼
┌───────────────────────────────────────────────────────────┐
│                     BUSINESS LOGIC                        │
├───────────────────────────────────────────────────────────┤
│  • AuthService (login, signup, logout, session mgmt)     │
│  • Password hashing & validation                          │
│  • Email validation                                        │
└─────────────────────────┬─────────────────────────────────┘
                          │
                          ▼
┌───────────────────────────────────────────────────────────┐
│                    DATA ACCESS                            │
├───────────────────────────────────────────────────────────┤
│  • DatabaseService (CRUD operations)                      │
│  • SharedPreferences (session storage)                    │
└─────────────────────────┬─────────────────────────────────┘
                          │
                          ▼
┌───────────────────────────────────────────────────────────┐
│                       DATA                                │
├───────────────────────────────────────────────────────────┤
│  • User Model                                             │
│  • SQLite Database (invochain.db)                         │
│  • Local Storage                                          │
└───────────────────────────────────────────────────────────┘
```

## Legend
```
┌─────────┐
│  Box    │  = Process/Component
└─────────┘

    │
    ▼        = Flow Direction

┌───┴───┐
│       │    = Decision Point

✅         = Success Path
❌         = Error Path

[Button]   = User Action
```

---

**InvoChain Authentication System**
Visual Documentation - October 28, 2025
