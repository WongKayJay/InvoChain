const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const Invoice = require('../models/InvoiceSQLite');
const { authenticate } = require('../middleware/auth');

/**
 * @route   POST /api/invoices
 * @desc    Create new invoice
 * @access  Private
 */
router.post('/', authenticate, [
  body('invoice_number').trim().notEmpty().withMessage('Invoice number is required'),
  body('buyer_company').trim().notEmpty().withMessage('Buyer company is required'),
  body('invoice_amount').isFloat({ min: 0.01 }).withMessage('Amount must be greater than 0'),
  body('due_date').isISO8601().withMessage('Valid due date is required')
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const invoice = await Invoice.create(req.user.userId, req.body);
    res.status(201).json({ message: 'Invoice created', invoice });
  } catch (err) {
    console.error('Create invoice error:', err);
    res.status(400).json({ error: err.message });
  }
});

/**
 * @route   GET /api/invoices
 * @desc    Get user's invoices
 * @access  Private
 */
router.get('/', authenticate, async (req, res) => {
  try {
    const invoices = await Invoice.getUserInvoices(req.user.userId);
    res.json({ invoices });
  } catch (err) {
    console.error('Get invoices error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

/**
 * @route   GET /api/invoices/pending
 * @desc    Get pending invoices (marketplace)
 * @access  Private
 */
router.get('/pending', authenticate, async (req, res) => {
  try {
    const invoices = await Invoice.getPending();
    res.json({ invoices });
  } catch (err) {
    console.error('Get pending invoices error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

/**
 * @route   PUT /api/invoices/:id/verify
 * @desc    Verify invoice
 * @access  Private (admin only in production)
 */
router.put('/:id/verify', authenticate, async (req, res) => {
  try {
    const invoice = await Invoice.verify(req.params.id);
    if (!invoice) {
      return res.status(404).json({ error: 'Invoice not found' });
    }
    res.json({ message: 'Invoice verified', invoice });
  } catch (err) {
    console.error('Verify invoice error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
