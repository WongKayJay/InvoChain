# InvoChain Backend API

PostgreSQL-based backend API server for InvoChain invoice financing platform.

## 🚀 Features

- ✅ **User Authentication** - Secure signup/login with JWT tokens
- ✅ **PostgreSQL Database** - Relational database for user data, investments, and invoices
- ✅ **RESTful API** - Clean API endpoints for all operations
- ✅ **Password Hashing** - bcrypt encryption for user passwords
- ✅ **Input Validation** - express-validator for request validation
- ✅ **CORS Support** - Cross-origin resource sharing enabled
- ✅ **Error Handling** - Comprehensive error handling and logging

## 📁 Project Structure

```
backend/
├── server.js                   # Express server entry point
├── package.json                # Dependencies
├── .env.example                # Environment variables template
├── .gitignore
├── database/
│   ├── connection.js          # PostgreSQL connection pool
│   ├── schema.sql             # Database schema
│   └── migrate.js             # Migration script
├── models/
│   ├── User.js                # User database operations
│   ├── Investment.js          # Investment database operations
│   └── Invoice.js             # Invoice database operations
├── routes/
│   ├── auth.js                # Authentication endpoints
│   ├── investments.js         # Investment endpoints
│   └── invoices.js            # Invoice endpoints
└── middleware/
    └── auth.js                # JWT authentication middleware
```

## 🛠 Setup Instructions

### Prerequisites

- Node.js v20.x or higher
- PostgreSQL 14.x or higher
- npm or yarn

### Installation

1. **Navigate to backend directory**
   ```powershell
   cd backend
   ```

2. **Install dependencies**
   ```powershell
   npm install
   ```

3. **Set up PostgreSQL database**
   ```powershell
   # Login to PostgreSQL
   psql -U postgres
   
   # Create database
   CREATE DATABASE invochain;
   
   # Exit psql
   \q
   ```

4. **Configure environment variables**
   ```powershell
   # Copy example env file
   Copy-Item .env.example .env
   
   # Edit .env with your database credentials
   notepad .env
   ```

   Update these values in `.env`:
   ```env
   DB_USER=postgres
   DB_PASSWORD=your_password
   DB_NAME=invochain
   JWT_SECRET=your_random_secret_key
   ```

5. **Run database migration**
   ```powershell
   npm run migrate
   ```

   This creates all necessary tables:
   - users
   - investments
   - invoices
   - portfolio
   - transactions

6. **Start the server**
   ```powershell
   # Development mode (with auto-restart)
   npm run dev
   
   # Production mode
   npm start
   ```

   Server will run on `http://localhost:3000`

## 📡 API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/signup` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| GET | `/api/auth/me` | Get current user | Yes |

### Investments

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/investments` | Create investment | Yes |
| GET | `/api/investments` | Get user's investments | Yes |
| GET | `/api/investments/active` | Get marketplace investments | Yes |
| GET | `/api/investments/:id` | Get investment by ID | Yes |

### Invoices

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/invoices` | Create invoice | Yes |
| GET | `/api/invoices` | Get user's invoices | Yes |
| GET | `/api/invoices/pending` | Get pending invoices | Yes |
| PUT | `/api/invoices/:id/verify` | Verify invoice | Yes |

### System

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/` | API info |

## 🧪 Testing the API

### Signup
```powershell
curl -X POST http://localhost:3000/api/auth/signup `
  -H "Content-Type: application/json" `
  -d '{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"password123\",\"full_name\":\"Test User\"}'
```

### Login
```powershell
curl -X POST http://localhost:3000/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{\"username\":\"testuser\",\"password\":\"password123\"}'
```

### Create Investment (requires token)
```powershell
curl -X POST http://localhost:3000/api/investments `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer YOUR_JWT_TOKEN" `
  -d '{\"company_name\":\"ABC Corp\",\"amount\":5000,\"expected_return\":8.5,\"risk_level\":\"medium\"}'
```

## 🗄️ Database Schema

### Users Table
```sql
- id (SERIAL PRIMARY KEY)
- username (VARCHAR UNIQUE)
- email (VARCHAR UNIQUE)
- password_hash (VARCHAR)
- full_name (VARCHAR)
- user_type ('investor' | 'sme')
- created_at, updated_at, last_login (TIMESTAMP)
```

### Investments Table
```sql
- id (SERIAL PRIMARY KEY)
- user_id (FOREIGN KEY → users)
- company_name, amount, expected_return, risk_level
- status ('active' | 'completed' | 'defaulted')
- investment_date, maturity_date
- blockchain_tx_hash (VARCHAR)
```

### Invoices Table
```sql
- id (SERIAL PRIMARY KEY)
- user_id (FOREIGN KEY → users)
- invoice_number (UNIQUE)
- buyer_company, invoice_amount, due_date
- status, verification_status
- blockchain_tx_hash
```

## 🔐 Security Features

- **Password Hashing**: bcrypt with salt rounds
- **JWT Authentication**: Secure token-based auth
- **Input Validation**: express-validator sanitization
- **SQL Injection Protection**: Parameterized queries
- **CORS Configuration**: Controlled cross-origin access
- **Environment Variables**: Sensitive data in .env

## 🚧 Development

```powershell
# Install dependencies
npm install

# Run in development mode (auto-reload)
npm run dev

# Run database migration
npm run migrate

# Start production server
npm start
```

## 📝 Environment Variables

```env
# Database
DB_USER=postgres
DB_HOST=localhost
DB_NAME=invochain
DB_PASSWORD=your_password
DB_PORT=5432

# Server
PORT=3000
NODE_ENV=development

# Security
JWT_SECRET=your_secret_key

# CORS
CORS_ORIGIN=http://localhost:5173
```

## 🔄 Next Steps

- [ ] Connect Flutter app to API endpoints
- [ ] Add blockchain integration (Ethereum/Polygon)
- [ ] Implement real-time notifications
- [ ] Add admin dashboard endpoints
- [ ] Deploy to production server
- [ ] Set up automated backups
- [ ] Add rate limiting
- [ ] Implement refresh tokens

## 📞 Support

For issues or questions, see the main project [README.md](../README.md)

---

**Status**: ✅ Fully Implemented and Ready for Use
