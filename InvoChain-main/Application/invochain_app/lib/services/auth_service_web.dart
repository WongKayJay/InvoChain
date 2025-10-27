import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Web-compatible Authentication Service using SharedPreferences
/// Works on all platforms: Web, Android, iOS, Windows, macOS, Linux
class AuthServiceWeb {
  static final AuthServiceWeb _instance = AuthServiceWeb._internal();
  factory AuthServiceWeb() => _instance;
  AuthServiceWeb._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Sign up new user
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Validate email format
      if (!_isValidEmail(email)) {
        return {
          'success': false,
          'message': 'Invalid email format',
        };
      }

      // Validate password strength
      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password must be at least 6 characters long',
        };
      }

      final prefs = await SharedPreferences.getInstance();
      final emailLower = email.toLowerCase();

      // Check if email already exists
      final existingUsersJson = prefs.getString('users_db') ?? '{}';
      final Map<String, dynamic> usersDb = json.decode(existingUsersJson);

      if (usersDb.containsKey(emailLower)) {
        return {
          'success': false,
          'message': 'Email already registered',
        };
      }

      // Create new user
      final now = DateTime.now();
      final user = User(
        id: usersDb.length + 1,
        email: emailLower,
        passwordHash: _hashPassword(password),
        fullName: fullName,
        createdAt: now,
      );

      // Save user to storage
      usersDb[emailLower] = user.toMap();
      await prefs.setString('users_db', json.encode(usersDb));

      // Verify the save was successful
      final savedUsersJson = prefs.getString('users_db');
      if (savedUsersJson == null) {
        return {
          'success': false,
          'message': 'Failed to save user data. Please try again.',
        };
      }

      // Set current user
      _currentUser = user;

      // Save login state
      await _saveLoginState(emailLower);

      // Debug: Print confirmation
      print('User registered successfully: $emailLower');
      print('Total users in database: ${usersDb.length}');

      return {
        'success': true,
        'message': 'Account created successfully',
        'user': _currentUser,
      };
    } catch (e) {
      print('SignUp Error: $e');
      return {
        'success': false,
        'message': 'Failed to create account: ${e.toString()}',
      };
    }
  }

  // Login existing user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final emailLower = email.toLowerCase();

      // Get users database
      final usersJson = prefs.getString('users_db') ?? '{}';
      final Map<String, dynamic> usersDb = json.decode(usersJson);

      // Debug: Print database contents
      print('Login attempt for: $emailLower');
      print('Users in database: ${usersDb.keys.toList()}');

      // Get user by email
      if (!usersDb.containsKey(emailLower)) {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }

      final userMap = usersDb[emailLower] as Map<String, dynamic>;
      final user = User.fromMap(userMap);

      // Verify password
      final hashedPassword = _hashPassword(password);
      if (user.passwordHash != hashedPassword) {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }

      // Update last login time
      final updatedUser = user.copyWith(lastLogin: DateTime.now());
      usersDb[emailLower] = updatedUser.toMap();
      await prefs.setString('users_db', json.encode(usersDb));

      // Set current user
      _currentUser = updatedUser;

      // Save login state
      await _saveLoginState(emailLower);

      return {
        'success': true,
        'message': 'Login successful',
        'user': _currentUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Login failed: ${e.toString()}',
      };
    }
  }

  // Logout user
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_email');
    await prefs.remove('is_logged_in');
  }

  // Check if user is already logged in
  Future<bool> checkLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final loggedInEmail = prefs.getString('logged_in_email');

      if (isLoggedIn && loggedInEmail != null) {
        // Get user from storage
        final usersJson = prefs.getString('users_db') ?? '{}';
        final Map<String, dynamic> usersDb = json.decode(usersJson);

        if (usersDb.containsKey(loggedInEmail)) {
          final userMap = usersDb[loggedInEmail] as Map<String, dynamic>;
          _currentUser = User.fromMap(userMap);
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Save login state to SharedPreferences
  Future<void> _saveLoginState(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('logged_in_email', email);
  }

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Get all registered users (for debugging/admin)
  Future<List<String>> getAllRegisteredEmails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users_db') ?? '{}';
      final Map<String, dynamic> usersDb = json.decode(usersJson);
      return usersDb.keys.toList();
    } catch (e) {
      print('Error getting registered emails: $e');
      return [];
    }
  }

  // Get total user count
  Future<int> getTotalUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users_db') ?? '{}';
      final Map<String, dynamic> usersDb = json.decode(usersJson);
      return usersDb.length;
    } catch (e) {
      return 0;
    }
  }

  // Clear all data (for debugging only)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    print('All data cleared');
  }

  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (_currentUser == null) {
        return {
          'success': false,
          'message': 'No user logged in',
        };
      }

      // Verify old password
      final hashedOldPassword = _hashPassword(oldPassword);
      if (_currentUser!.passwordHash != hashedOldPassword) {
        return {
          'success': false,
          'message': 'Current password is incorrect',
        };
      }

      // Validate new password
      if (newPassword.length < 6) {
        return {
          'success': false,
          'message': 'New password must be at least 6 characters long',
        };
      }

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users_db') ?? '{}';
      final Map<String, dynamic> usersDb = json.decode(usersJson);

      // Update password
      final updatedUser = _currentUser!.copyWith(
        passwordHash: _hashPassword(newPassword),
      );

      usersDb[_currentUser!.email] = updatedUser.toMap();
      await prefs.setString('users_db', json.encode(usersDb));
      _currentUser = updatedUser;

      return {
        'success': true,
        'message': 'Password changed successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to change password: ${e.toString()}',
      };
    }
  }
}
