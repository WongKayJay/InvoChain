const { pool } = require('../database/connection');

class Invoice {
  /**
   * Create a new invoice
   */
  static async create(userId, invoiceData) {
    const {
      invoice_number,
      buyer_company,
      invoice_amount,
      due_date,
      description
    } = invoiceData;

    const query = `
      INSERT INTO invoices 
      (user_id, invoice_number, buyer_company, invoice_amount, due_date, description)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
    `;

    try {
      const result = await pool.query(query, [
        userId,
        invoice_number,
        buyer_company,
        invoice_amount,
        due_date,
        description
      ]);
      return result.rows[0];
    } catch (err) {
      if (err.code === '23505') { // Unique violation
        throw new Error('Invoice number already exists');
      }
      throw err;
    }
  }

  /**
   * Get all invoices for a user
   */
  static async getUserInvoices(userId) {
    const query = `
      SELECT * FROM invoices 
      WHERE user_id = $1 
      ORDER BY created_at DESC
    `;
    const result = await pool.query(query, [userId]);
    return result.rows;
  }

  /**
   * Get invoice by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM invoices WHERE id = $1';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  /**
   * Get invoice by invoice number
   */
  static async findByInvoiceNumber(invoiceNumber) {
    const query = 'SELECT * FROM invoices WHERE invoice_number = $1';
    const result = await pool.query(query, [invoiceNumber]);
    return result.rows[0];
  }

  /**
   * Update invoice status
   */
  static async updateStatus(id, status) {
    const query = `
      UPDATE invoices 
      SET status = $1 
      WHERE id = $2 
      RETURNING *
    `;
    const result = await pool.query(query, [status, id]);
    return result.rows[0];
  }

  /**
   * Verify invoice
   */
  static async verify(id) {
    const query = `
      UPDATE invoices 
      SET verification_status = 'verified', 
          verified_at = CURRENT_TIMESTAMP 
      WHERE id = $1 
      RETURNING *
    `;
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  /**
   * Get pending invoices
   */
  static async getPending(limit = 50) {
    const query = `
      SELECT * FROM invoices 
      WHERE status = 'pending' 
      ORDER BY created_at DESC 
      LIMIT $1
    `;
    const result = await pool.query(query, [limit]);
    return result.rows;
  }
}

module.exports = Invoice;
