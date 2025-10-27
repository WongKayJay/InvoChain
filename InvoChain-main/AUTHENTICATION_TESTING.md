# User Authentication Persistence - Testing Guide

## What I Fixed

The authentication system **already saves user data correctly** using SharedPreferences. I've added:

1. **Debug logging** to track user registration and login
2. **View Registered Users button** on login screen
3. **User count confirmation** when signing up
4. **Better error messages** to help troubleshoot

## How to Test Persistence

### Test 1: Sign Up New User
1. Launch the app (should show login screen if logged out)
2. Click "Sign Up"
3. Fill in:
   - Full Name: Test User
   - Email: test@example.com
   - Password: password123
   - Confirm Password: password123
4. Click "Sign Up"
5. You should see: **"Account created successfully! You are user #X"**
6. You'll be auto-logged in and taken to the home screen

### Test 2: Verify User Was Saved
1. On the home screen, go to Profile tab
2. Click "Logout"
3. You're back at the login screen
4. Click **"View Registered Users"** button at the bottom
5. You should see: `test@example.com` in the list

### Test 3: Login with Saved Credentials
1. Enter: test@example.com / password123
2. Click "Login"
3. You should successfully log in to the app

### Test 4: Browser Refresh (Critical Test)
1. While logged in, press F5 or refresh the browser
2. The app should automatically log you back in
3. This proves the session persists across page reloads

### Test 5: Multiple Users
1. Logout again
2. Sign up another user: test2@example.com
3. Click "View Registered Users" - should show BOTH users
4. Login with either account - both should work

## Important Notes

### Why Users Might "Disappear"

**SharedPreferences on Web uses browser localStorage**, which means:

1. ✅ **Persists** across page refreshes
2. ✅ **Persists** across browser restarts (in normal mode)
3. ❌ **DOES NOT persist** if you:
   - Clear browser cache/cookies
   - Use Incognito/Private browsing mode
   - Use browser's "Clear Site Data"
   - Switch browsers

### Console Debugging

Open Browser DevTools (F12) and check the Console for:
- `User registered successfully: email@example.com`
- `Total users in database: 2`
- `Login attempt for: email@example.com`
- `Users in database: [email1, email2]`

### View Stored Data in Browser

1. Press F12 → Application tab (Chrome) or Storage tab (Firefox)
2. Look under "Local Storage" → your app URL
3. Find the key `flutter.users_db`
4. You'll see the JSON with all users

## Database Structure

```json
{
  "test@example.com": {
    "id": 1,
    "email": "test@example.com",
    "passwordHash": "hash_here",
    "fullName": "Test User",
    "createdAt": "2025-10-28T...",
    "lastLogin": "2025-10-28T..."
  }
}
```

## Production Considerations

For production, consider:
1. Backend database (Firebase, Supabase, etc.)
2. JWT tokens for authentication
3. Proper encryption (SharedPreferences is not encrypted)
4. Server-side validation

Current implementation is perfect for:
- Development/testing
- Demo applications
- Local-first apps
- Prototypes
