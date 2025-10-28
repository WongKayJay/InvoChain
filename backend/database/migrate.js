const fs = require('fs');
const path = require('path');
const { pool } = require('./connection');

async function runMigration() {
  console.log('🔄 Starting database migration...\n');

  try {
    // Read the schema file
    const schemaPath = path.join(__dirname, 'schema.sql');
    const schema = fs.readFileSync(schemaPath, 'utf8');

    // Execute the schema
    await pool.query(schema);

    console.log('✅ Database migration completed successfully!');
    console.log('\nCreated tables:');
    console.log('  - users');
    console.log('  - investments');
    console.log('  - invoices');
    console.log('  - portfolio');
    console.log('  - transactions');
    console.log('\nCreated indexes for optimized queries');
    console.log('Created triggers for automatic timestamp updates\n');

    // Verify tables were created
    const result = await pool.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name;
    `);

    console.log('Current database tables:');
    result.rows.forEach(row => console.log(`  - ${row.table_name}`));

    process.exit(0);
  } catch (err) {
    console.error('❌ Migration failed:', err.message);
    console.error('\nMake sure PostgreSQL is running and credentials in .env are correct');
    process.exit(1);
  }
}

runMigration();
