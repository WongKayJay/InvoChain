# InvoChain Authentication System

## Overview
This authentication system provides secure user registration, login, and session management using SQLite database with password hashing.

## Features

### 🔐 Security Features
- **Password Hashing**: All passwords are hashed using SHA-256 encryption
- **Persistent Login**: User sessions are maintained using SharedPreferences
- **Email Validation**: Email format validation on signup
- **Password Strength**: Minimum 6 characters required

### 📱 User Interface
- **Login Screen**: Clean, modern login interface with email/password fields
- **Sign Up Screen**: Registration form with full name, email, password, and confirmation
- **Profile Screen**: Displays logged-in user information with logout functionality
- **Auto-login**: Automatically redirects logged-in users to main navigation

## Database Structure

### Users Table
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL,
  created_at TEXT NOT NULL,
  last_login TEXT
);

CREATE INDEX idx_users_email ON users(email);
```

## File Structure

```
lib/
├── models/
│   └── user.dart                 # User model with database mapping
├── services/
│   ├── auth_service.dart         # Authentication logic (login/signup/logout)
│   ├── database_service.dart     # SQLite database operations
│   └── theme_provider.dart       # Existing theme service
├── screens/
│   ├── login_screen.dart         # Login UI
│   ├── signup_screen.dart        # Registration UI
│   ├── profile_screen.dart       # User profile with logout
│   └── main_navigation.dart      # Main app navigation
└── main.dart                      # App entry point with auth check
```

## How It Works

### 1. App Startup
- `main.dart` starts with `AuthChecker` widget
- Checks if user is already logged in via `SharedPreferences`
- Redirects to `LoginScreen` or `MainNavigation` accordingly

### 2. User Registration (Sign Up)
1. User fills in: Full Name, Email, Password, Confirm Password
2. System validates:
   - Email format is correct
   - Password is at least 6 characters
   - Passwords match
   - Email is not already registered
3. Password is hashed using SHA-256
4. User data is stored in SQLite database
5. User is automatically logged in
6. Session is saved in SharedPreferences

### 3. User Login
1. User enters email and password
2. System looks up user by email in database
3. Password is hashed and compared with stored hash
4. If valid, last login time is updated
5. User session is saved
6. User is redirected to main navigation

### 4. User Logout
1. User clicks logout button in profile screen
2. Confirmation dialog is shown
3. If confirmed, session is cleared from SharedPreferences
4. User is redirected to login screen

## API Reference

### AuthService

```dart
// Sign up new user
Future<Map<String, dynamic>> signUp({
  required String email,
  required String password,
  required String fullName,
})

// Login existing user
Future<Map<String, dynamic>> login({
  required String email,
  required String password,
})

// Logout current user
Future<void> logout()

// Check if user is logged in
Future<bool> checkLoginState()

// Change password
Future<Map<String, dynamic>> changePassword({
  required String oldPassword,
  required String newPassword,
})
```

### DatabaseService

```dart
// Insert new user
Future<int> insertUser(User user)

// Get user by email
Future<User?> getUserByEmail(String email)

// Get user by ID
Future<User?> getUserById(int id)

// Update last login time
Future<int> updateLastLogin(int userId, DateTime lastLogin)

// Check if email exists
Future<bool> emailExists(String email)
```

## Usage Examples

### Sign Up
```dart
final authService = AuthService();
final result = await authService.signUp(
  email: 'user@example.com',
  password: 'securePassword123',
  fullName: 'John Doe',
);

if (result['success']) {
  print('User created: ${result['user']}');
} else {
  print('Error: ${result['message']}');
}
```

### Login
```dart
final authService = AuthService();
final result = await authService.login(
  email: 'user@example.com',
  password: 'securePassword123',
);

if (result['success']) {
  print('Logged in: ${result['user']}');
} else {
  print('Error: ${result['message']}');
}
```

### Check Authentication State
```dart
final authService = AuthService();
if (authService.isAuthenticated) {
  print('User is logged in: ${authService.currentUser?.email}');
}
```

## Dependencies

```yaml
dependencies:
  sqflite: ^2.3.0          # SQLite database
  path: ^1.8.3             # Path manipulation
  crypto: ^3.0.3           # Password hashing (SHA-256)
  shared_preferences: ^2.2.2  # Session persistence
```

## Security Notes

⚠️ **Important Security Considerations:**

1. **Production Security**: For production apps, consider using more advanced authentication:
   - Firebase Authentication
   - OAuth 2.0 providers (Google, Apple, etc.)
   - JWT tokens for API authentication
   - Password hashing with salt (bcrypt, scrypt, or argon2)

2. **Current Implementation**: 
   - Uses SHA-256 for password hashing (basic security)
   - Suitable for development and learning
   - Should be enhanced for production use

3. **Best Practices**:
   - Never store passwords in plain text ✓
   - Always use HTTPS in production
   - Implement rate limiting for login attempts
   - Add email verification
   - Implement password reset functionality

## Future Enhancements

- [ ] Email verification
- [ ] Forgot password / Password reset
- [ ] Two-factor authentication (2FA)
- [ ] Biometric authentication (fingerprint/face ID)
- [ ] Social login (Google, Apple, Facebook)
- [ ] Session timeout
- [ ] Account deletion
- [ ] Profile picture upload
- [ ] Password strength meter

## Testing

To test the authentication system:

1. Run the app: `flutter run`
2. Click "Sign Up" to create a new account
3. Fill in the registration form
4. You'll be automatically logged in
5. Navigate to Profile tab to see your information
6. Click "Logout" to test logout functionality
7. Login again with your credentials

## Database Location

The SQLite database is stored at:
- **Android**: `/data/data/com.example.invochain_app/databases/invochain.db`
- **iOS**: `~/Library/Application Support/invochain.db`

## Troubleshooting

### Issue: Login not working
- Check if user exists in database
- Verify password is correct
- Check console for error messages

### Issue: Session not persisting
- Ensure SharedPreferences is working
- Check `checkLoginState()` is called on app start

### Issue: Database errors
- Clear app data and reinstall
- Check SQL syntax in `database_service.dart`

---

Built with ❤️ for InvoChain - Transparent, Secure Invoice Financing
