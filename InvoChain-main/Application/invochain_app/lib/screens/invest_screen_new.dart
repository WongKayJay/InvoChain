import 'package:flutter/material.dart';
import '../models/investment.dart';

class InvestScreen extends StatefulWidget {
  const InvestScreen({super.key});

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _sortBy = 'Latest';

  // Sample data - would come from backend/database in production
  final List<InvestmentOpportunity> _allOpportunities = [
    InvestmentOpportunity(
      id: '1',
      company: 'Tech Solutions Ltd.',
      industry: 'Technology',
      grade: 'Grade A',
      amount: 35000,
      returnRate: 3.5,
      tenorDays: 45,
      description: 'Invoice financing for enterprise software development project. Low risk, established client base.',
      fundedPercentage: 65.5,
      investors: 12,
      blockchainHash: '0x7d3c4f2a1b8e9d6c5a4f3e2d1c0b9a8e7d6c5b4a',
      listedDate: DateTime.now().subtract(const Duration(days: 5)),
      isShariahCompliant: false,
      documents: ['Invoice.pdf', 'Contract.pdf', 'Credit Report.pdf'],
    ),
    InvestmentOpportunity(
      id: '2',
      company: 'Green Manufacturing Corp.',
      industry: 'Manufacturing',
      grade: 'Grade B',
      amount: 52000,
      returnRate: 4.2,
      tenorDays: 60,
      description: 'Sustainable manufacturing equipment purchase. Verified supply chain and ESG compliant.',
      fundedPercentage: 42.8,
      investors: 8,
      blockchainHash: '0x3e5d7a9c2f4b6e8a1d3c5f7b9e2a4c6d8f1b3e5a',
      listedDate: DateTime.now().subtract(const Duration(days: 3)),
      isShariahCompliant: true,
      documents: ['Invoice.pdf', 'ESG Certificate.pdf'],
    ),
    InvestmentOpportunity(
      id: '3',
      company: 'Retail Group Inc.',
      industry: 'Retail',
      grade: 'Grade A',
      amount: 28500,
      returnRate: 3.8,
      tenorDays: 30,
      description: 'Inventory financing for seasonal stock. Fast turnover, established retail chain.',
      fundedPercentage: 88.2,
      investors: 15,
      blockchainHash: '0x9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b',
      listedDate: DateTime.now().subtract(const Duration(days: 8)),
      isShariahCompliant: false,
      documents: ['Invoice.pdf', 'Inventory Report.pdf'],
    ),
    InvestmentOpportunity(
      id: '4',
      company: 'Healthcare Plus Ltd.',
      industry: 'Healthcare',
      grade: 'Grade A',
      amount: 45000,
      returnRate: 3.2,
      tenorDays: 90,
      description: 'Medical equipment financing for hospital expansion. Government-backed, highly secure.',
      fundedPercentage: 25.0,
      investors: 5,
      blockchainHash: '0x5c7e9a1b3d5f7a9c2e4f6b8d0a2c4e6f8a1c3e5d',
      listedDate: DateTime.now().subtract(const Duration(days: 1)),
      isShariahCompliant: true,
      documents: ['Invoice.pdf', 'Government Contract.pdf', 'Credit Report.pdf'],
    ),
    InvestmentOpportunity(
      id: '5',
      company: 'Construction Builders Co.',
      industry: 'Construction',
      grade: 'Grade C',
      amount: 68000,
      returnRate: 5.5,
      tenorDays: 120,
      description: 'Construction material financing for commercial project. Higher returns, moderate risk.',
      fundedPercentage: 15.3,
      investors: 3,
      blockchainHash: '0x2d4f6a8c1e3a5c7e9b1d3f5a7c9e2b4d6f8a1c3e',
      listedDate: DateTime.now().subtract(const Duration(hours: 12)),
      isShariahCompliant: false,
      documents: ['Invoice.pdf', 'Project Plan.pdf'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<InvestmentOpportunity> get _filteredOpportunities {
    var filtered = _allOpportunities.where((opp) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!opp.company.toLowerCase().contains(query) &&
            !opp.industry.toLowerCase().contains(query) &&
            !opp.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Grade filter
      if (_selectedFilter != 'All') {
        if (_selectedFilter == 'Shariah' && !opp.isShariahCompliant) {
          return false;
        } else if (_selectedFilter != 'Shariah' && opp.grade != _selectedFilter) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case 'Latest':
        filtered.sort((a, b) => b.listedDate.compareTo(a.listedDate));
        break;
      case 'Highest Return':
        filtered.sort((a, b) => b.returnRate.compareTo(a.returnRate));
        break;
      case 'Lowest Amount':
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case 'Ending Soon':
        filtered.sort((a, b) => a.tenorDays.compareTo(b.tenorDays));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Opportunities'),
            Tab(text: 'Track On-Chain'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Latest', child: Text('Latest')),
              const PopupMenuItem(value: 'Highest Return', child: Text('Highest Return')),
              const PopupMenuItem(value: 'Lowest Amount', child: Text('Lowest Amount')),
              const PopupMenuItem(value: 'Ending Soon', child: Text('Ending Soon')),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOpportunitiesTab(theme),
          _buildOnChainTrackingTab(theme),
        ],
      ),
    );
  }

  Widget _buildOpportunitiesTab(ThemeData theme) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search companies, industries...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip(theme, 'All'),
              const SizedBox(width: 8),
              _buildFilterChip(theme, 'Grade A'),
              const SizedBox(width: 8),
              _buildFilterChip(theme, 'Grade B'),
              const SizedBox(width: 8),
              _buildFilterChip(theme, 'Grade C'),
              const SizedBox(width: 8),
              _buildFilterChip(theme, 'Shariah'),
            ],
          ),
        ),
        
        const SizedBox(height: 8),

        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${_filteredOpportunities.length} opportunities',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'Sorted by: $_sortBy',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        // Investment cards list
        Expanded(
          child: _filteredOpportunities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No opportunities found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredOpportunities.length,
                  itemBuilder: (context, index) {
                    return _buildInvestmentCard(
                      theme,
                      _filteredOpportunities[index],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(ThemeData theme, String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (value) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: theme.colorScheme.primary.withOpacity(0.2),
      checkmarkColor: theme.colorScheme.primary,
      showCheckmark: true,
    );
  }

  Widget _buildInvestmentCard(ThemeData theme, InvestmentOpportunity opportunity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showInvestmentDetails(opportunity),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.company,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              opportunity.industry,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (opportunity.isShariahCompliant) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.green[700]!,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Shariah',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: opportunity.gradeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: opportunity.gradeColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      opportunity.grade,
                      style: TextStyle(
                        color: opportunity.gradeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                opportunity.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Funding progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Funded: ${opportunity.fundedPercentage.toStringAsFixed(1)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${opportunity.investors} investors',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: opportunity.fundedPercentage / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'Amount',
                      opportunity.formattedAmount,
                      theme,
                      Icons.attach_money,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'Returns',
                      opportunity.formattedReturn,
                      theme,
                      Icons.trending_up,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'Tenor',
                      opportunity.tenor,
                      theme,
                      Icons.schedule,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showInvestmentDetails(opportunity),
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Details'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () => _showInvestmentDialog(opportunity),
                      icon: const Icon(Icons.wallet, size: 18),
                      label: const Text('Invest Now'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, ThemeData theme, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // On-Chain Tracking Tab
  Widget _buildOnChainTrackingTab(ThemeData theme) {
    // Sample user investments
    final List<UserInvestment> myInvestments = [
      UserInvestment(
        id: '1',
        opportunityId: '1',
        company: 'Tech Solutions Ltd.',
        investedAmount: 5000,
        returnRate: 3.5,
        investedDate: DateTime.now().subtract(const Duration(days: 20)),
        maturityDate: DateTime.now().add(const Duration(days: 25)),
        status: 'active',
        blockchainHash: '0x7d3c4f2a1b8e9d6c5a4f3e2d1c0b9a8e7d6c5b4a',
        chainEvents: [
          BlockchainEvent(
            type: 'Investment',
            description: 'Investment recorded on blockchain',
            timestamp: DateTime.now().subtract(const Duration(days: 20)),
            transactionHash: '0x7d3c4f2a1b8e9d6c5a4f3e2d1c0b9a8e7d6c5b4a',
          ),
          BlockchainEvent(
            type: 'Verification',
            description: 'Invoice verified by smart contract',
            timestamp: DateTime.now().subtract(const Duration(days: 19)),
            transactionHash: '0x8e4d5g3b2c9f0e7d6c5b4a3f2e1d0c9b8a7e6d5c',
          ),
        ],
      ),
      UserInvestment(
        id: '2',
        opportunityId: '3',
        company: 'Retail Group Inc.',
        investedAmount: 3500,
        returnRate: 3.8,
        investedDate: DateTime.now().subtract(const Duration(days: 25)),
        maturityDate: DateTime.now().add(const Duration(days: 5)),
        status: 'active',
        blockchainHash: '0x9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b',
        chainEvents: [
          BlockchainEvent(
            type: 'Investment',
            description: 'Investment recorded on blockchain',
            timestamp: DateTime.now().subtract(const Duration(days: 25)),
            transactionHash: '0x9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b',
          ),
        ],
      ),
    ];

    return myInvestments.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No active investments',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start investing to track on-chain',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    _tabController.animateTo(0);
                  },
                  child: const Text('Browse Opportunities'),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myInvestments.length,
            itemBuilder: (context, index) {
              return _buildInvestmentTrackingCard(theme, myInvestments[index]);
            },
          );
  }

  Widget _buildInvestmentTrackingCard(ThemeData theme, UserInvestment investment) {
    final statusColor = investment.status == 'active'
        ? Colors.green
        : investment.status == 'matured'
            ? Colors.blue
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    investment.company,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor, width: 1.5),
                  ),
                  child: Text(
                    investment.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Investment amount and returns
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invested',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          investment.formattedAmount,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expected Return',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          investment.formattedExpectedReturn,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${investment.daysRemaining} days remaining',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${investment.progressPercentage.toStringAsFixed(0)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: investment.progressPercentage / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Blockchain info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.link,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Blockchain Hash',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    investment.blockchainHash,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showBlockchainDetails(investment),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('View Blockchain Events'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvestmentDetails(InvestmentOpportunity opportunity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          opportunity.company,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: opportunity.gradeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: opportunity.gradeColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          opportunity.grade,
                          style: TextStyle(
                            color: opportunity.gradeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        opportunity.industry,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About this Opportunity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opportunity.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Key metrics
                  Text(
                    'Key Metrics',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          theme,
                          'Amount',
                          opportunity.formattedAmount,
                          Icons.attach_money,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          theme,
                          'Return',
                          opportunity.formattedReturn,
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          theme,
                          'Tenor',
                          opportunity.tenor,
                          Icons.schedule,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          theme,
                          'Investors',
                          '${opportunity.investors}',
                          Icons.people,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Blockchain info
                  Text(
                    'Blockchain Verification',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified,
                              color: Colors.green[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Verified on Blockchain',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Hash:',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          opportunity.blockchainHash,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Documents
                  Text(
                    'Documents',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...opportunity.documents.map((doc) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              doc,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            Icons.download,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Invest button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showInvestmentDialog(opportunity);
                      },
                      icon: const Icon(Icons.wallet),
                      label: const Text('Invest Now'),
                      style: FilledButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildMetricCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showInvestmentDialog(InvestmentOpportunity opportunity) {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Invest in ${opportunity.company}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter investment amount:',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  hintText: '1000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Return Rate:', style: theme.textTheme.bodySmall),
                        Text(
                          opportunity.formattedReturn,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tenor:', style: theme.textTheme.bodySmall),
                        Text(
                          opportunity.tenor,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Investment successful! Track it in the On-Chain tab.'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
                // Switch to Track On-Chain tab
                _tabController.animateTo(1);
              },
              child: const Text('Confirm Investment'),
            ),
          ],
        );
      },
    );
  }

  void _showBlockchainDetails(UserInvestment investment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
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
                      Expanded(
                        child: Text(
                          'Blockchain Events',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Text(
                    investment.company,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Blockchain hash
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blockchain Hash',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          investment.blockchainHash,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Timeline of events
                  Text(
                    'Transaction History',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...investment.chainEvents.asMap().entries.map((entry) {
                    final event = entry.value;
                    final isLast = entry.key == investment.chainEvents.length - 1;
                    
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 80,
                                color: Colors.grey[300],
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        event.type,
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatDateTime(event.timestamp),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  event.description,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'TX: ${event.transactionHash.substring(0, 20)}...',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
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
}
