import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseService _dbService = DatabaseService();
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

      // Check if email already exists
      final emailExists = await _dbService.emailExists(email);
      if (emailExists) {
        return {
          'success': false,
          'message': 'Email already registered',
        };
      }

      // Create new user
      final user = User(
        email: email.toLowerCase(),
        passwordHash: _hashPassword(password),
        fullName: fullName,
        createdAt: DateTime.now(),
      );

      // Insert user into database
      final userId = await _dbService.insertUser(user);

      // Get the created user with ID
      _currentUser = await _dbService.getUserById(userId);

      // Save login state
      await _saveLoginState(userId);

      return {
        'success': true,
        'message': 'Account created successfully',
        'user': _currentUser,
      };
    } catch (e) {
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
      // Get user by email
      final user = await _dbService.getUserByEmail(email.toLowerCase());

      if (user == null) {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }

      // Verify password
      final hashedPassword = _hashPassword(password);
      if (user.passwordHash != hashedPassword) {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }

      // Update last login time
      await _dbService.updateLastLogin(user.id!, DateTime.now());

      // Set current user
      _currentUser = user.copyWith(lastLogin: DateTime.now());

      // Save login state
      await _saveLoginState(user.id!);

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
    await prefs.remove('user_id');
    await prefs.remove('is_logged_in');
  }

  // Check if user is already logged in
  Future<bool> checkLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final userId = prefs.getInt('user_id');

      if (isLoggedIn && userId != null) {
        _currentUser = await _dbService.getUserById(userId);
        return _currentUser != null;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Save login state to SharedPreferences
  Future<void> _saveLoginState(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setInt('user_id', userId);
  }

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
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

      // Update password
      final updatedUser = _currentUser!.copyWith(
        passwordHash: _hashPassword(newPassword),
      );

      await _dbService.updateUser(updatedUser);
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
