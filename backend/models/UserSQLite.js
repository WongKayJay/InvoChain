const { run, query } = require('../database/connection-sqlite');
const bcrypt = require('bcrypt');

class User {
  /**
   * Create a new user
   */
  static async create(userData) {
    const { username, email, password, full_name, user_type = 'investor', phone, company_name } = userData;

    // Hash password
    const password_hash = await bcrypt.hash(password, 10);

    const sql = `
      INSERT INTO users (username, email, password_hash, full_name, user_type, phone, company_name)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `;

    try {
      const result = await run(sql, [username, email, password_hash, full_name, user_type, phone, company_name]);
      
      // Fetch the created user
      const user = await this.findById(result.lastID);
      return user;
    } catch (err) {
      if (err.message.includes('UNIQUE constraint failed: users.username')) {
        throw new Error('Username already exists');
      }
      if (err.message.includes('UNIQUE constraint failed: users.email')) {
        throw new Error('Email already exists');
      }
      throw err;
    }
  }

  /**
   * Find user by ID
   */
  static async findById(id) {
    const sql = 'SELECT id, username, email, full_name, user_type, phone, company_name, created_at, last_login FROM users WHERE id = ?';
    const result = await query(sql, [id]);
    return result.rows[0];
  }

  /**
   * Find user by username
   */
  static async findByUsername(username) {
    const sql = 'SELECT * FROM users WHERE username = ?';
    const result = await query(sql, [username]);
    return result.rows[0];
  }

  /**
   * Find user by email
   */
  static async findByEmail(email) {
    const sql = 'SELECT * FROM users WHERE email = ?';
    const result = await query(sql, [email]);
    return result.rows[0];
  }

  /**
   * Verify user password
   */
  static async verifyPassword(plainPassword, hashedPassword) {
    return await bcrypt.compare(plainPassword, hashedPassword);
  }

  /**
   * Update user profile
   */
  static async update(id, updateData) {
    const { full_name, phone, company_name } = updateData;
    
    const sql = `
      UPDATE users 
      SET full_name = COALESCE(?, full_name),
          phone = COALESCE(?, phone),
          company_name = COALESCE(?, company_name),
          updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `;

    await run(sql, [full_name, phone, company_name, id]);
    return await this.findById(id);
  }

  /**
   * Update last login timestamp
   */
  static async updateLastLogin(id) {
    const sql = 'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?';
    await run(sql, [id]);
  }

  /**
   * Delete user
   */
  static async delete(id) {
    const sql = 'DELETE FROM users WHERE id = ?';
    await run(sql, [id]);
    return { id };
  }

  /**
   * Get all users (admin function)
   */
  static async getAll(limit = 100, offset = 0) {
    const sql = `
      SELECT id, username, email, full_name, user_type, created_at, last_login 
      FROM users 
      ORDER BY created_at DESC 
      LIMIT ? OFFSET ?
    `;
    const result = await query(sql, [limit, offset]);
    return result.rows;
  }

  /**
   * Count total users
   */
  static async count() {
    const sql = 'SELECT COUNT(*) as count FROM users';
    const result = await query(sql);
    return parseInt(result.rows[0].count);
  }
}

module.exports = User;
