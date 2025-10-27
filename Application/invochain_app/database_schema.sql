-- InvoChain User Authentication Database Schema
-- SQLite Database: invochain.db

-- ============================================
-- TABLES
-- ============================================

-- Users Table
-- Stores all registered user information
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    created_at TEXT NOT NULL,
    last_login TEXT
);

-- ============================================
-- INDEXES
-- ============================================

-- Index on email for faster lookups during login
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================
-- SAMPLE QUERIES
-- ============================================

-- Insert a new user (example - password is hashed in the app)
-- INSERT INTO users (email, password_hash, full_name, created_at)
-- VALUES (
--     'john.doe@example.com',
--     'hashed_password_here',
--     'John Doe',
--     '2025-10-28T10:30:00.000'
-- );

-- Get user by email (for login)
-- SELECT * FROM users WHERE email = 'john.doe@example.com' LIMIT 1;

-- Get user by ID
-- SELECT * FROM users WHERE id = 1 LIMIT 1;

-- Update last login time
-- UPDATE users 
-- SET last_login = '2025-10-28T15:45:00.000'
-- WHERE id = 1;

-- Check if email exists
-- SELECT COUNT(*) FROM users WHERE email = 'john.doe@example.com';

-- Get all users (admin only)
-- SELECT id, email, full_name, created_at, last_login FROM users;

-- Delete a user
-- DELETE FROM users WHERE id = 1;

-- ============================================
-- COLUMN DESCRIPTIONS
-- ============================================

-- id: Auto-incrementing primary key for each user
-- email: User's email address (unique, used for login)
-- password_hash: SHA-256 hashed password (never store plain text!)
-- full_name: User's full name
-- created_at: ISO 8601 timestamp when account was created
-- last_login: ISO 8601 timestamp of most recent login

-- ============================================
-- NOTES
-- ============================================

-- 1. All timestamps are stored in ISO 8601 format
-- 2. Passwords are hashed using SHA-256 before storage
-- 3. Email is case-insensitive (converted to lowercase before storage)
-- 4. The database is automatically created on first app launch
-- 5. Database location:
--    - Android: /data/data/com.example.invochain_app/databases/invochain.db
--    - iOS: ~/Library/Application Support/invochain.db

-- ============================================
-- FUTURE ENHANCEMENTS
-- ============================================

-- Add these tables/columns for extended functionality:
--
-- Email Verification:
-- ALTER TABLE users ADD COLUMN email_verified INTEGER DEFAULT 0;
-- ALTER TABLE users ADD COLUMN verification_token TEXT;
--
-- Password Reset:
-- CREATE TABLE password_reset_tokens (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     user_id INTEGER NOT NULL,
--     token TEXT NOT NULL,
--     expires_at TEXT NOT NULL,
--     FOREIGN KEY (user_id) REFERENCES users(id)
-- );
--
-- User Sessions:
-- CREATE TABLE user_sessions (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     user_id INTEGER NOT NULL,
--     session_token TEXT UNIQUE NOT NULL,
--     created_at TEXT NOT NULL,
--     expires_at TEXT NOT NULL,
--     FOREIGN KEY (user_id) REFERENCES users(id)
-- );
--
-- Login Attempts (for security):
-- CREATE TABLE login_attempts (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     email TEXT NOT NULL,
--     success INTEGER NOT NULL,
--     ip_address TEXT,
--     attempted_at TEXT NOT NULL
-- );
