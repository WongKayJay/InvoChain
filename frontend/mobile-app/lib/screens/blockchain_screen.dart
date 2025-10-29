import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_data_provider.dart';

class BlockchainScreen extends StatefulWidget {
  const BlockchainScreen({super.key});

  @override
  State<BlockchainScreen> createState() => _BlockchainScreenState();
}

class _BlockchainScreenState extends State<BlockchainScreen> {
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appData = Provider.of<AppDataProvider>(context);
    final allTransactions = _getAllTransactions(appData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blockchain Transactions'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Transactions')),
              const PopupMenuItem(value: 'investment', child: Text('Investments')),
              const PopupMenuItem(value: 'invoice', child: Text('Invoices')),
              const PopupMenuItem(value: 'payment', child: Text('Payments')),
              const PopupMenuItem(value: 'verification', child: Text('Verifications')),
            ],
          ),
        ],
      ),
      body: allTransactions.isEmpty
          ? _buildEmptyState(theme)
          : _buildTransactionsList(theme, allTransactions),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Blockchain Transactions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start investing or uploading invoices\nto see your blockchain activity',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(ThemeData theme, List<BlockchainTransaction> transactions) {
    final filteredTransactions = _filterType == 'all'
        ? transactions
        : transactions.where((tx) => tx.type.toLowerCase() == _filterType).toList();

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No ${_filterType == 'all' ? '' : _filterType} transactions found',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return _buildTransactionCard(theme, transaction);
      },
    );
  }

  Widget _buildTransactionCard(ThemeData theme, BlockchainTransaction transaction) {
    final typeColor = _getTypeColor(transaction.type);
    final typeIcon = _getTypeIcon(transaction.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showTransactionDetails(transaction),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                transaction.type.toUpperCase(),
                                style: TextStyle(
                                  color: typeColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateTime(transaction.timestamp),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tag, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        transaction.transactionHash,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: () {
                        // Copy to clipboard functionality would go here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transaction hash copied!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              if (transaction.blockNumber != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.layers, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Block #${transaction.blockNumber}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Confirmed',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BlockchainTransaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final typeColor = _getTypeColor(transaction.type);
        final typeIcon = _getTypeIcon(transaction.type);

        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(typeIcon, color: typeColor, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transaction Details',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              transaction.type.toUpperCase(),
                              style: TextStyle(
                                color: typeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildDetailRow(theme, 'Description', transaction.description),
                  const SizedBox(height: 16),
                  _buildDetailRow(theme, 'Timestamp', _formatFullDateTime(transaction.timestamp)),
                  const SizedBox(height: 16),
                  _buildDetailRow(theme, 'Transaction Hash', transaction.transactionHash, monospace: true),
                  
                  if (transaction.blockNumber != null) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(theme, 'Block Number', '#${transaction.blockNumber}'),
                  ],

                  if (transaction.from != null) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(theme, 'From', transaction.from!, monospace: true),
                  ],

                  if (transaction.to != null) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(theme, 'To', transaction.to!, monospace: true),
                  ],

                  if (transaction.amount != null) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(theme, 'Amount', transaction.amount!),
                  ],

                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified, color: Colors.green[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Blockchain Verified',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              Text(
                                'This transaction is permanently recorded on the blockchain',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value, {bool monospace = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: monospace ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'investment':
        return Colors.blue;
      case 'invoice':
        return Colors.orange;
      case 'payment':
        return Colors.green;
      case 'verification':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'investment':
        return Icons.trending_up;
      case 'invoice':
        return Icons.receipt;
      case 'payment':
        return Icons.payment;
      case 'verification':
        return Icons.verified;
      default:
        return Icons.receipt_long;
    }
  }

  List<BlockchainTransaction> _getAllTransactions(AppDataProvider appData) {
    final List<BlockchainTransaction> transactions = [];

    // Add investment transactions
    for (var investment in appData.userInvestments) {
      for (var event in investment.chainEvents) {
        transactions.add(BlockchainTransaction(
          type: 'Investment',
          description: '${event.type} - ${investment.company}',
          transactionHash: event.transactionHash,
          timestamp: event.timestamp,
          blockNumber: int.parse(event.transactionHash.substring(2, 8), radix: 16),
          from: 'Your Wallet',
          to: investment.company,
          amount: investment.formattedAmount,
        ));
      }
    }

    // Add invoice transactions
    for (var invoice in appData.invoices) {
      if (invoice.blockchainHash != null) {
        transactions.add(BlockchainTransaction(
          type: 'Invoice',
          description: 'Invoice from ${invoice.company}',
          transactionHash: invoice.blockchainHash!,
          timestamp: invoice.createdDate,
          blockNumber: int.parse(invoice.blockchainHash!.substring(2, 8), radix: 16),
          from: invoice.company,
          to: 'InvoChain Platform',
          amount: '\$${invoice.amount.toStringAsFixed(2)}',
        ));
      }
    }

    // Sort by timestamp (newest first)
    transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return transactions;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatFullDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class BlockchainTransaction {
  final String type;
  final String description;
  final String transactionHash;
  final DateTime timestamp;
  final int? blockNumber;
  final String? from;
  final String? to;
  final String? amount;

  BlockchainTransaction({
    required this.type,
    required this.description,
    required this.transactionHash,
    required this.timestamp,
    this.blockNumber,
    this.from,
    this.to,
    this.amount,
  });
}
