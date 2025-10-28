const { run, query } = require('../database/connection-sqlite');

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

    const sql = `
      INSERT INTO investments 
      (user_id, company_name, amount, expected_return, risk_level, maturity_date, description)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `;

    const result = await run(sql, [
      userId,
      company_name,
      amount,
      expected_return,
      risk_level,
      maturity_date,
      description
    ]);

    return await this.findById(result.lastID);
  }

  /**
   * Get all investments for a user
   */
  static async getUserInvestments(userId) {
    const sql = `
      SELECT * FROM investments 
      WHERE user_id = ? 
      ORDER BY investment_date DESC
    `;
    const result = await query(sql, [userId]);
    return result.rows;
  }

  /**
   * Get investment by ID
   */
  static async findById(id) {
    const sql = 'SELECT * FROM investments WHERE id = ?';
    const result = await query(sql, [id]);
    return result.rows[0];
  }

  /**
   * Update investment status
   */
  static async updateStatus(id, status) {
    const sql = `
      UPDATE investments 
      SET status = ?, updated_at = CURRENT_TIMESTAMP 
      WHERE id = ?
    `;
    await run(sql, [status, id]);
    return await this.findById(id);
  }

  /**
   * Get all active investments
   */
  static async getActive(limit = 50) {
    const sql = `
      SELECT * FROM investments 
      WHERE status = 'active' 
      ORDER BY investment_date DESC 
      LIMIT ?
    `;
    const result = await query(sql, [limit]);
    return result.rows;
  }

  /**
   * Get user's total investment amount
   */
  static async getUserTotalInvestment(userId) {
    const sql = `
      SELECT COALESCE(SUM(amount), 0) as total 
      FROM investments 
      WHERE user_id = ? AND status IN ('active', 'completed')
    `;
    const result = await query(sql, [userId]);
    return parseFloat(result.rows[0].total);
  }
}

module.exports = Investment;
