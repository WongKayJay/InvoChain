const { run, query } = require('../database/connection-sqlite');

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

    const sql = `
      INSERT INTO invoices 
      (user_id, invoice_number, buyer_company, invoice_amount, due_date, description)
      VALUES (?, ?, ?, ?, ?, ?)
    `;

    try {
      const result = await run(sql, [
        userId,
        invoice_number,
        buyer_company,
        invoice_amount,
        due_date,
        description
      ]);
      return await this.findById(result.lastID);
    } catch (err) {
      if (err.message.includes('UNIQUE constraint failed: invoices.invoice_number')) {
        throw new Error('Invoice number already exists');
      }
      throw err;
    }
  }

  /**
   * Get all invoices for a user
   */
  static async getUserInvoices(userId) {
    const sql = `
      SELECT * FROM invoices 
      WHERE user_id = ? 
      ORDER BY created_at DESC
    `;
    const result = await query(sql, [userId]);
    return result.rows;
  }

  /**
   * Get invoice by ID
   */
  static async findById(id) {
    const sql = 'SELECT * FROM invoices WHERE id = ?';
    const result = await query(sql, [id]);
    return result.rows[0];
  }

  /**
   * Get invoice by invoice number
   */
  static async findByInvoiceNumber(invoiceNumber) {
    const sql = 'SELECT * FROM invoices WHERE invoice_number = ?';
    const result = await query(sql, [invoiceNumber]);
    return result.rows[0];
  }

  /**
   * Update invoice status
   */
  static async updateStatus(id, status) {
    const sql = `
      UPDATE invoices 
      SET status = ?, updated_at = CURRENT_TIMESTAMP 
      WHERE id = ?
    `;
    await run(sql, [status, id]);
    return await this.findById(id);
  }

  /**
   * Verify invoice
   */
  static async verify(id) {
    const sql = `
      UPDATE invoices 
      SET verification_status = 'verified', 
          verified_at = CURRENT_TIMESTAMP,
          updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `;
    await run(sql, [id]);
    return await this.findById(id);
  }

  /**
   * Get pending invoices
   */
  static async getPending(limit = 50) {
    const sql = `
      SELECT * FROM invoices 
      WHERE status = 'pending' 
      ORDER BY created_at DESC 
      LIMIT ?
    `;
    const result = await query(sql, [limit]);
    return result.rows;
  }
}

module.exports = Invoice;
