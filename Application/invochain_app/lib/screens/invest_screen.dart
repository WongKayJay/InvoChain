import 'package:flutter/material.dart';

class InvestScreen extends StatelessWidget {
  const InvestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(context, 'All', true),
                const SizedBox(width: 8),
                _buildFilterChip(context, 'Grade A', false),
                const SizedBox(width: 8),
                _buildFilterChip(context, 'Grade B', false),
                const SizedBox(width: 8),
                _buildFilterChip(context, 'Shariah', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          _buildInvestmentCard(
            context,
            'Tech Solutions Ltd.',
            'Grade A',
            '\$35,000',
            '3.5%',
            '45 days',
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildInvestmentCard(
            context,
            'Manufacturing Corp.',
            'Grade B',
            '\$52,000',
            '4.2%',
            '60 days',
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildInvestmentCard(
            context,
            'Retail Group Inc.',
            'Grade A',
            '\$28,500',
            '3.8%',
            '30 days',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool selected) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) {},
      selectedColor: theme.colorScheme.primary.withOpacity(0.2),
      checkmarkColor: theme.colorScheme.primary,
    );
  }

  Widget _buildInvestmentCard(
    BuildContext context,
    String company,
    String grade,
    String amount,
    String returns,
    String tenor,
    Color gradeColor,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    company,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: gradeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gradeColor, width: 1.5),
                  ),
                  child: Text(
                    grade,
                    style: TextStyle(
                      color: gradeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    'Amount',
                    amount,
                    theme,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    'Returns',
                    returns,
                    theme,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    'Tenor',
                    tenor,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Invest Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
