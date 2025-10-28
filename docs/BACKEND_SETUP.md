# 🚀 Quick Start Guide - InvoChain Backend

## What Was Implemented

Your InvoChain project now has a **complete PostgreSQL backend** with:

✅ **User Authentication System**
- Secure signup/login with JWT tokens
- Password hashing with bcrypt
- Session management

✅ **SQL Database (PostgreSQL)**
- 5 database tables with proper relationships
- Automatic timestamps and triggers
- Indexes for optimized queries

✅ **RESTful API Server**
- Express.js Node.js server
- 12 API endpoints
- Input validation
- Error handling

---

## 📁 What's in the Backend

```
backend/
├── server.js                 ✅ Express API server
├── package.json              ✅ Dependencies
├── .env.example              ✅ Configuration template
├── database/
│   ├── schema.sql           ✅ PostgreSQL database schema
│   ├── connection.js        ✅ Database connection pool
│   └── migrate.js           ✅ Migration script
├── models/
│   ├── User.js              ✅ User database operations
│   ├── Investment.js        ✅ Investment CRUD
│   └── Invoice.js           ✅ Invoice CRUD
├── routes/
│   ├── auth.js              ✅ Authentication endpoints
│   ├── investments.js       ✅ Investment API
│   └── invoices.js          ✅ Invoice API
└── middleware/
    └── auth.js              ✅ JWT authentication
```

---

## 🗄️ Database Schema

### Users Table
Stores user account information with secure password hashing.

**Fields**: id, username, email, password_hash, full_name, user_type (investor/sme), phone, company_name, timestamps

### Investments Table
Tracks all investment opportunities and user investments.

**Fields**: id, user_id, company_name, amount, expected_return, risk_level, status, maturity_date, blockchain_tx_hash

### Invoices Table
Manages invoice financing requests.

**Fields**: id, user_id, invoice_number, buyer_company, invoice_amount, due_date, status, verification_status, blockchain_tx_hash

### Portfolio Table
Tracks user portfolio performance metrics.

### Transactions Table
Records all blockchain transactions.

---

## 🔧 How to Set Up and Run

### Step 1: Install PostgreSQL

**Windows:**
```powershell
# Download from https://www.postgresql.org/download/windows/
# Install with default settings
# Remember your postgres password!
```

### Step 2: Create Database

```powershell
# Open psql (PostgreSQL command line)
psql -U postgres

# In psql, run:
CREATE DATABASE invochain;
\q
```

### Step 3: Configure Backend

```powershell
cd backend

# Install dependencies
npm install

# Create .env file from template
Copy-Item .env.example .env

# Edit .env with your PostgreSQL password
notepad .env
```

Update `.env`:
```env
DB_PASSWORD=your_postgres_password_here
JWT_SECRET=any_random_string_for_production
```

### Step 4: Run Database Migration

```powershell
npm run migrate
```

This creates all 5 tables in PostgreSQL.

### Step 5: Start the Backend Server

```powershell
# Development mode (auto-restarts on changes)
npm run dev

# OR production mode
npm start
```

Server runs on: **http://localhost:3000**

---

## 🧪 Test the API

### 1. Create a User

```powershell
curl -X POST http://localhost:3000/api/auth/signup `
  -H "Content-Type: application/json" `
  -d '{"username":"john","email":"john@example.com","password":"password123","full_name":"John Doe"}'
```

**Response:**
```json
{
  "message": "User created successfully",
  "user": {
    "id": 1,
    "username": "john",
    "email": "john@example.com",
    "user_type": "investor"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 2. Login

```powershell
curl -X POST http://localhost:3000/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"username":"john","password":"password123"}'
```

**Copy the `token` from the response!**

### 3. Create an Investment

```powershell
curl -X POST http://localhost:3000/api/investments `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer YOUR_TOKEN_HERE" `
  -d '{"company_name":"Tech Corp","amount":5000,"expected_return":8.5,"risk_level":"medium"}'
```

### 4. Get Your Investments

```powershell
curl -X GET http://localhost:3000/api/investments `
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 📡 All Available Endpoints

### Authentication (No token required)
- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login and get JWT token

### User (Token required)
- `GET /api/auth/me` - Get current user info

### Investments (Token required)
- `POST /api/investments` - Create investment
- `GET /api/investments` - Get your investments
- `GET /api/investments/active` - Get marketplace
- `GET /api/investments/:id` - Get specific investment

### Invoices (Token required)
- `POST /api/invoices` - Create invoice
- `GET /api/invoices` - Get your invoices
- `GET /api/invoices/pending` - Get pending invoices
- `PUT /api/invoices/:id/verify` - Verify invoice

### System
- `GET /health` - Health check
- `GET /` - API information

---

## 🔐 Security Features

✅ **Password Security**
- Bcrypt hashing (10 salt rounds)
- Passwords never stored in plain text

✅ **Authentication**
- JWT tokens (7-day expiration)
- Bearer token authorization

✅ **Database Security**
- Parameterized queries (SQL injection protection)
- Foreign key constraints
- Unique constraints on username/email

✅ **Input Validation**
- express-validator on all inputs
- Type checking and sanitization

---

## 🔄 Next Steps

### Connect Flutter App to Backend

Currently your Flutter app uses `SharedPreferences` (local storage). To connect to the real database:

1. **Update auth_service_web.dart** to call `/api/auth/login` instead of local storage
2. **Store JWT token** in SharedPreferences
3. **Add Authorization header** to all API calls
4. **Replace AppDataProvider** data fetching with HTTP requests

Example:
```dart
// Instead of local state
final response = await http.post(
  Uri.parse('http://localhost:3000/api/auth/login'),
  body: jsonEncode({'username': username, 'password': password}),
  headers: {'Content-Type': 'application/json'}
);
```

### Future Enhancements

- [ ] Add blockchain integration (Ethereum/Polygon)
- [ ] Implement real-time notifications
- [ ] Add file upload for invoice documents
- [ ] Create admin dashboard
- [ ] Deploy to cloud (AWS/Google Cloud/DigitalOcean)
- [ ] Set up automated database backups
- [ ] Add rate limiting
- [ ] Implement refresh tokens

---

## ❓ Troubleshooting

**"Connection refused" error**
- Make sure PostgreSQL is running
- Check DB_PASSWORD in .env matches your PostgreSQL password

**"Database does not exist"**
- Run `CREATE DATABASE invochain;` in psql

**"Cannot find module 'express'"**
- Run `npm install` in backend directory

**"Invalid token" errors**
- Make sure Authorization header is: `Bearer YOUR_TOKEN`
- Token expires after 7 days - login again

---

## 📊 Database Management

**View all users:**
```sql
psql -U postgres -d invochain
SELECT * FROM users;
```

**View all investments:**
```sql
SELECT * FROM investments;
```

**Reset database (WARNING: Deletes all data):**
```powershell
cd backend
npm run migrate
```

---

## 🎉 Summary

You now have:
- ✅ Complete PostgreSQL database
- ✅ RESTful API server
- ✅ User authentication system
- ✅ Investment & invoice management
- ✅ Secure password handling
- ✅ JWT token authentication

**The backend is fully functional and ready to use!**

Next step: Connect your Flutter app to these API endpoints instead of using local storage.
