const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const Investment = require('../models/Investment');
const { authenticate } = require('../middleware/auth');

/**
 * @route   POST /api/investments
 * @desc    Create new investment
 * @access  Private
 */
router.post('/', authenticate, [
  body('company_name').trim().notEmpty().withMessage('Company name is required'),
  body('amount').isFloat({ min: 0.01 }).withMessage('Amount must be greater than 0'),
  body('expected_return').optional().isFloat({ min: 0, max: 100 }),
  body('risk_level').optional().isIn(['low', 'medium', 'high'])
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const investment = await Investment.create(req.user.userId, req.body);
    res.status(201).json({ message: 'Investment created', investment });
  } catch (err) {
    console.error('Create investment error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

/**
 * @route   GET /api/investments
 * @desc    Get user's investments
 * @access  Private
 */
router.get('/', authenticate, async (req, res) => {
  try {
    const investments = await Investment.getUserInvestments(req.user.userId);
    res.json({ investments });
  } catch (err) {
    console.error('Get investments error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

/**
 * @route   GET /api/investments/active
 * @desc    Get all active investments (marketplace)
 * @access  Private
 */
router.get('/active', authenticate, async (req, res) => {
  try {
    const investments = await Investment.getActive();
    res.json({ investments });
  } catch (err) {
    console.error('Get active investments error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

/**
 * @route   GET /api/investments/:id
 * @desc    Get investment by ID
 * @access  Private
 */
router.get('/:id', authenticate, async (req, res) => {
  try {
    const investment = await Investment.findById(req.params.id);
    if (!investment) {
      return res.status(404).json({ error: 'Investment not found' });
    }
    res.json({ investment });
  } catch (err) {
    console.error('Get investment error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
