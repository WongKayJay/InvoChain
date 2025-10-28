const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const bcrypt = require('bcrypt');

// Create/open SQLite database
const dbPath = path.join(__dirname, 'invochain.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('❌ Error opening database:', err);
  } else {
    console.log('✅ Connected to SQLite database at:', dbPath);
  }
});

// Enable foreign keys
db.run('PRAGMA foreign_keys = ON');

// Helper function to run queries with promises
const query = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) {
        reject(err);
      } else {
        resolve({ rows });
      }
    });
  });
};

// Helper function to run single insert/update/delete
const run = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      if (err) {
        reject(err);
      } else {
        resolve({ lastID: this.lastID, changes: this.changes });
      }
    });
  });
};

// Create tables
const createTables = async () => {
  try {
    // Users table
    await run(`
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        full_name TEXT,
        user_type TEXT DEFAULT 'investor' CHECK (user_type IN ('investor', 'sme')),
        phone TEXT,
        company_name TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        last_login DATETIME
      )
    `);

    // Investments table
    await run(`
      CREATE TABLE IF NOT EXISTS investments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        company_name TEXT NOT NULL,
        amount REAL NOT NULL CHECK (amount > 0),
        expected_return REAL,
        risk_level TEXT CHECK (risk_level IN ('low', 'medium', 'high')),
        status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'defaulted', 'pending')),
        investment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        maturity_date DATETIME,
        blockchain_tx_hash TEXT,
        description TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    `);

    // Invoices table
    await run(`
      CREATE TABLE IF NOT EXISTS invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        invoice_number TEXT UNIQUE NOT NULL,
        buyer_company TEXT NOT NULL,
        invoice_amount REAL NOT NULL CHECK (invoice_amount > 0),
        due_date DATETIME NOT NULL,
        status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'verified', 'funded', 'paid', 'rejected')),
        verification_status TEXT DEFAULT 'unverified' CHECK (verification_status IN ('unverified', 'verified', 'rejected')),
        blockchain_tx_hash TEXT,
        description TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        verified_at DATETIME,
        funded_at DATETIME,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    `);

    // Portfolio table
    await run(`
      CREATE TABLE IF NOT EXISTS portfolio (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        investment_id INTEGER NOT NULL,
        current_value REAL,
        profit_loss REAL,
        return_percentage REAL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (investment_id) REFERENCES investments(id) ON DELETE CASCADE,
        UNIQUE(user_id, investment_id)
      )
    `);

    // Transactions table
    await run(`
      CREATE TABLE IF NOT EXISTS transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        transaction_type TEXT NOT NULL CHECK (transaction_type IN ('investment', 'payment', 'withdrawal', 'deposit')),
        amount REAL NOT NULL,
        blockchain_tx_hash TEXT UNIQUE,
        status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'failed')),
        reference_id INTEGER,
        reference_type TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        confirmed_at DATETIME,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    `);

    // Create indexes
    await run(`CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)`);
    await run(`CREATE INDEX IF NOT EXISTS idx_users_username ON users(username)`);
    await run(`CREATE INDEX IF NOT EXISTS idx_investments_user_id ON investments(user_id)`);
    await run(`CREATE INDEX IF NOT EXISTS idx_invoices_user_id ON invoices(user_id)`);
    await run(`CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id)`);

    console.log('✅ All database tables created successfully');

    // Insert demo users if table is empty
    const users = await query('SELECT COUNT(*) as count FROM users');
    if (users.rows[0].count === 0) {
      const demoPassword = await bcrypt.hash('demo123', 10);
      await run(`
        INSERT INTO users (username, email, password_hash, full_name, user_type)
        VALUES (?, ?, ?, ?, ?)
      `, ['demo_investor', 'investor@demo.com', demoPassword, 'Demo Investor', 'investor']);
      
      await run(`
        INSERT INTO users (username, email, password_hash, full_name, user_type)
        VALUES (?, ?, ?, ?, ?)
      `, ['demo_sme', 'sme@demo.com', demoPassword, 'Demo SME', 'sme']);
      
      console.log('✅ Created demo users:');
      console.log('   - demo_investor / demo123 (Investor account)');
      console.log('   - demo_sme / demo123 (SME account)');
    }

  } catch (err) {
    console.error('❌ Error creating tables:', err);
    throw err;
  }
};

// Initialize database
createTables();

const testConnection = async () => {
  try {
    await query('SELECT 1');
    return true;
  } catch (err) {
    console.error('Database test failed:', err);
    return false;
  }
};

module.exports = {
  db,
  query,
  run,
  testConnection
};
