const { pool } = require('../database/connection');
const bcrypt = require('bcrypt');

class User {
  /**
   * Create a new user
   */
  static async create(userData) {
    const { username, email, password, full_name, user_type = 'investor', phone, company_name } = userData;

    // Hash password
    const password_hash = await bcrypt.hash(password, 10);

    const query = `
      INSERT INTO users (username, email, password_hash, full_name, user_type, phone, company_name)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id, username, email, full_name, user_type, phone, company_name, created_at
    `;

    try {
      const result = await pool.query(query, [
        username,
        email,
        password_hash,
        full_name,
        user_type,
        phone,
        company_name
      ]);
      return result.rows[0];
    } catch (err) {
      if (err.code === '23505') { // Unique violation
        if (err.constraint === 'users_username_key') {
          throw new Error('Username already exists');
        }
        if (err.constraint === 'users_email_key') {
          throw new Error('Email already exists');
        }
      }
      throw err;
    }
  }

  /**
   * Find user by ID
   */
  static async findById(id) {
    const query = 'SELECT id, username, email, full_name, user_type, phone, company_name, created_at, last_login FROM users WHERE id = $1';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  /**
   * Find user by username
   */
  static async findByUsername(username) {
    const query = 'SELECT * FROM users WHERE username = $1';
    const result = await pool.query(query, [username]);
    return result.rows[0];
  }

  /**
   * Find user by email
   */
  static async findByEmail(email) {
    const query = 'SELECT * FROM users WHERE email = $1';
    const result = await pool.query(query, [email]);
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
    
    const query = `
      UPDATE users 
      SET full_name = COALESCE($1, full_name),
          phone = COALESCE($2, phone),
          company_name = COALESCE($3, company_name)
      WHERE id = $4
      RETURNING id, username, email, full_name, user_type, phone, company_name, updated_at
    `;

    const result = await pool.query(query, [full_name, phone, company_name, id]);
    return result.rows[0];
  }

  /**
   * Update last login timestamp
   */
  static async updateLastLogin(id) {
    const query = 'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1';
    await pool.query(query, [id]);
  }

  /**
   * Delete user
   */
  static async delete(id) {
    const query = 'DELETE FROM users WHERE id = $1 RETURNING id';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  /**
   * Get all users (admin function)
   */
  static async getAll(limit = 100, offset = 0) {
    const query = `
      SELECT id, username, email, full_name, user_type, created_at, last_login 
      FROM users 
      ORDER BY created_at DESC 
      LIMIT $1 OFFSET $2
    `;
    const result = await pool.query(query, [limit, offset]);
    return result.rows;
  }

  /**
   * Count total users
   */
  static async count() {
    const query = 'SELECT COUNT(*) FROM users';
    const result = await pool.query(query);
    return parseInt(result.rows[0].count);
  }
}

module.exports = User;
