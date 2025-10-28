const { pool } = require('../database/connection');

class Investment {
  /**
   * Create a new investment
   */
  static async create(userId, investmentData) {
    const {
      company_name,
      amount,
      expected_return,
      risk_level,
      maturity_date,
      description
    } = investmentData;

    const query = `
      INSERT INTO investments 
      (user_id, company_name, amount, expected_return, risk_level, maturity_date, description)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
    `;

    const result = await pool.query(query, [
      userId,
      company_name,
      amount,
      expected_return,
      risk_level,
      maturity_date,
      description
    ]);

    return result.rows[0];
  }

  /**
   * Get all investments for a user
   */
  static async getUserInvestments(userId) {
    const query = `
      SELECT * FROM investments 
      WHERE user_id = $1 
      ORDER BY investment_date DESC
    `;
    const result = await pool.query(query, [userId]);
    return result.rows;
  }

  /**
   * Get investment by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM investments WHERE id = $1';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  /**
   * Update investment status
   */
  static async updateStatus(id, status) {
    const query = `
      UPDATE investments 
      SET status = $1 
      WHERE id = $2 
      RETURNING *
    `;
    const result = await pool.query(query, [status, id]);
    return result.rows[0];
  }

  /**
   * Get all active investments
   */
  static async getActive(limit = 50) {
    const query = `
      SELECT * FROM investments 
      WHERE status = 'active' 
      ORDER BY investment_date DESC 
      LIMIT $1
    `;
    const result = await pool.query(query, [limit]);
    return result.rows;
  }

  /**
   * Get user's total investment amount
   */
  static async getUserTotalInvestment(userId) {
    const query = `
      SELECT COALESCE(SUM(amount), 0) as total 
      FROM investments 
      WHERE user_id = $1 AND status IN ('active', 'completed')
    `;
    const result = await pool.query(query, [userId]);
    return parseFloat(result.rows[0].total);
  }
}

module.exports = Investment;
