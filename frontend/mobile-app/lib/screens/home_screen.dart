import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/action_card.dart';
import '../services/app_data_provider.dart';
import 'main_navigation.dart';
import 'blockchain_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appData = context.watch<AppDataProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.link,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('InvoChain'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Transparent, secure invoice financing',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats
            Text(
              'Quick Stats',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Invested',
                    value: '\$${appData.totalInvested.toStringAsFixed(0)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Active Investments',
                    value: '${appData.activeInvestments}',
                    icon: Icons.trending_up,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Invoices',
                    value: '${appData.totalInvoices}',
                    icon: Icons.description,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Avg Return',
                    value: '${appData.averageReturn.toStringAsFixed(1)}%',
                    icon: Icons.percent,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ActionCard(
              title: 'Submit Invoice',
              subtitle: 'Upload and verify your invoices',
              icon: Icons.upload_file,
              color: theme.colorScheme.primary,
              onTap: () {
                // Navigate to Invoices tab (index 1)
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const MainNavigation(initialIndex: 1),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ActionCard(
              title: 'Browse Investments',
              subtitle: 'Explore verified invoice opportunities',
              icon: Icons.search,
              color: theme.colorScheme.secondary,
              onTap: () {
                // Navigate to Invest tab (index 2)
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const MainNavigation(initialIndex: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ActionCard(
              title: 'Track On-Chain',
              subtitle: 'View blockchain audit trail',
              icon: Icons.timeline,
              color: Colors.orange,
              onTap: () {
                // Navigate to Blockchain transactions screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BlockchainScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
