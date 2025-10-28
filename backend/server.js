const express = require('express');
const cors = require('cors');
require('dotenv').config();

const { testConnection } = require('./database/connection-sqlite');
const authRoutes = require('./routes/auth');
const investmentRoutes = require('./routes/investments');
const invoiceRoutes = require('./routes/invoices');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/investments', investmentRoutes);
app.use('/api/invoices', invoiceRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    database: 'SQLite'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'InvoChain API Server',
    version: '1.0.0',
    database: 'SQLite (Development)',
    endpoints: {
      auth: '/api/auth',
      investments: '/api/investments',
      invoices: '/api/invoices',
      health: '/health'
    },
    demoAccounts: {
      investor: { username: 'demo_investor', password: 'demo123' },
      sme: { username: 'demo_sme', password: 'demo123' }
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({ 
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Start server
const startServer = async () => {
  try {
    // SQLite database is initialized in connection-sqlite.js
    console.log('🔄 Initializing SQLite database...');
    
    // Give database time to initialize
    await new Promise(resolve => setTimeout(resolve, 1000));

    // Start Express server
    app.listen(PORT, () => {
      console.log('\n' + '='.repeat(60));
      console.log('🚀 InvoChain API Server Running');
      console.log('='.repeat(60));
      console.log(`📍 Server: http://localhost:${PORT}`);
      console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🗄️  Database: SQLite (invochain.db)`);
      console.log('\n👤 Demo Accounts:');
      console.log('   Investor: demo_investor / demo123');
      console.log('   SME:      demo_sme / demo123');
      console.log('\n📚 API Endpoints:');
      console.log('   POST   /api/auth/signup');
      console.log('   POST   /api/auth/login');
      console.log('   GET    /api/auth/me');
      console.log('   GET    /api/investments');
      console.log('   POST   /api/investments');
      console.log('   GET    /api/invoices');
      console.log('   POST   /api/invoices');
      console.log('   GET    /health');
      console.log('   GET    /  (API info)');
      console.log('='.repeat(60) + '\n');
      console.log('💡 Try: http://localhost:3000 in your browser\n');
    });
  } catch (err) {
    console.error('Failed to start server:', err);
    process.exit(1);
  }
};

startServer();
