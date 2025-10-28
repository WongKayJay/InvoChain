import 'package:flutter/foundation.dart';
import '../models/investment.dart';
import '../models/invoice.dart';

class AppDataProvider extends ChangeNotifier {
  // Investments
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

  final List<UserInvestment> _userInvestments = [
    UserInvestment(
      id: 'ui1',
      opportunityId: '3',
      company: 'Retail Group Inc.',
      investedAmount: 5000,
      returnRate: 3.8,
      investedDate: DateTime.now().subtract(const Duration(days: 22)),
      maturityDate: DateTime.now().add(const Duration(days: 8)),
      status: 'active',
      blockchainHash: '0x9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b',
      chainEvents: [
        BlockchainEvent(
          type: 'Transaction Created',
          description: 'Investment transaction initiated',
          timestamp: DateTime.now().subtract(const Duration(days: 22)),
          transactionHash: '0x9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b',
        ),
        BlockchainEvent(
          type: 'Funds Locked',
          description: 'Funds secured in smart contract',
          timestamp: DateTime.now().subtract(const Duration(days: 22, hours: -2)),
          transactionHash: '0xa2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1',
        ),
        BlockchainEvent(
          type: 'Investment Active',
          description: 'Investment is now active',
          timestamp: DateTime.now().subtract(const Duration(days: 22, hours: -4)),
          transactionHash: '0xb3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2',
        ),
      ],
    ),
    UserInvestment(
      id: 'ui2',
      opportunityId: '1',
      company: 'Tech Solutions Ltd.',
      investedAmount: 10000,
      returnRate: 3.5,
      investedDate: DateTime.now().subtract(const Duration(days: 15)),
      maturityDate: DateTime.now().add(const Duration(days: 30)),
      status: 'active',
      blockchainHash: '0x7d3c4f2a1b8e9d6c5a4f3e2d1c0b9a8e7d6c5b4a',
      chainEvents: [
        BlockchainEvent(
          type: 'Transaction Created',
          description: 'Investment transaction initiated',
          timestamp: DateTime.now().subtract(const Duration(days: 15)),
          transactionHash: '0x7d3c4f2a1b8e9d6c5a4f3e2d1c0b9a8e7d6c5b4a',
        ),
        BlockchainEvent(
          type: 'Funds Locked',
          description: 'Funds secured in smart contract',
          timestamp: DateTime.now().subtract(const Duration(days: 15, hours: -1)),
          transactionHash: '0xc4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3',
        ),
        BlockchainEvent(
          type: 'Investment Active',
          description: 'Investment is now active',
          timestamp: DateTime.now().subtract(const Duration(days: 15, hours: -3)),
          transactionHash: '0xd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4',
        ),
      ],
    ),
  ];

  final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-2025-001',
      company: 'Tech Corp Ltd.',
      amount: 25000,
      status: InvoiceStatus.funded,
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      fundedDate: DateTime.now().subtract(const Duration(days: 28)),
      blockchainHash: '0xf1e2d3c4b5a6978e9d0c1b2a3f4e5d6c7b8a9e0d',
      tenorDays: 45,
      returnRate: 3.5,
      investmentId: '1',
    ),
    Invoice(
      id: 'INV-2025-002',
      company: 'Global Supplies Inc.',
      amount: 15500,
      status: InvoiceStatus.pending,
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      tenorDays: 30,
      returnRate: 3.8,
    ),
    Invoice(
      id: 'INV-2025-003',
      company: 'Manufacturing Co.',
      amount: 42000,
      status: InvoiceStatus.underReview,
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      tenorDays: 60,
      returnRate: 4.2,
    ),
  ];

  // Getters
  List<InvestmentOpportunity> get allOpportunities => List.unmodifiable(_allOpportunities);
  List<UserInvestment> get userInvestments => List.unmodifiable(_userInvestments);
  List<Invoice> get invoices => List.unmodifiable(_invoices);

  // Stats calculations
  double get totalPortfolioValue {
    double investedAmount = _userInvestments.fold(0, (sum, inv) => sum + inv.investedAmount);
    double expectedReturns = _userInvestments.fold(0, (sum, inv) => sum + inv.expectedReturn);
    return investedAmount + expectedReturns;
  }

  double get totalInvested {
    return _userInvestments.fold(0, (sum, inv) => sum + inv.investedAmount);
  }

  double get totalReturns {
    return _userInvestments.fold(0, (sum, inv) => sum + inv.expectedReturn);
  }

  int get activeInvestments {
    return _userInvestments.where((inv) => inv.maturityDate.isAfter(DateTime.now())).length;
  }

  int get totalInvoices {
    return _invoices.length;
  }

  int get fundedInvoices {
    return _invoices.where((inv) => inv.status == InvoiceStatus.funded || inv.status == InvoiceStatus.completed).length;
  }

  int get pendingInvoices {
    return _invoices.where((inv) => inv.status == InvoiceStatus.pending || inv.status == InvoiceStatus.underReview).length;
  }

  double get averageReturn {
    if (_userInvestments.isEmpty) return 0;
    double totalReturn = _userInvestments.fold(0, (sum, inv) {
      return sum + (inv.expectedReturn / inv.investedAmount * 100);
    });
    return totalReturn / _userInvestments.length;
  }

  // Methods to add/update data
  void addInvestment(InvestmentOpportunity opportunity, double amount) {
    // Update the opportunity's funded percentage
    final index = _allOpportunities.indexWhere((opp) => opp.id == opportunity.id);
    if (index != -1) {
      final currentFunded = (opportunity.fundedPercentage / 100) * opportunity.amount;
      final newFunded = currentFunded + amount;
      final newPercentage = (newFunded / opportunity.amount) * 100;

      _allOpportunities[index] = opportunity.copyWith(
        fundedPercentage: newPercentage,
        investors: opportunity.investors + 1,
      );
    }

    // Add to user investments
    final newInvestment = UserInvestment(
      id: 'ui${_userInvestments.length + 1}',
      opportunityId: opportunity.id,
      company: opportunity.company,
      investedAmount: amount,
      returnRate: opportunity.returnRate,
      investedDate: DateTime.now(),
      maturityDate: DateTime.now().add(Duration(days: opportunity.tenorDays)),
      status: 'active',
      blockchainHash: _generateBlockchainHash(),
      chainEvents: [
        BlockchainEvent(
          type: 'Transaction Created',
          description: 'Investment transaction initiated',
          timestamp: DateTime.now(),
          transactionHash: _generateBlockchainHash(),
        ),
        BlockchainEvent(
          type: 'Funds Locked',
          description: 'Funds secured in smart contract',
          timestamp: DateTime.now().add(const Duration(minutes: 2)),
          transactionHash: _generateBlockchainHash(),
        ),
        BlockchainEvent(
          type: 'Investment Active',
          description: 'Investment is now active',
          timestamp: DateTime.now().add(const Duration(minutes: 5)),
          transactionHash: _generateBlockchainHash(),
        ),
      ],
    );

    _userInvestments.insert(0, newInvestment);
    notifyListeners();
  }

  void addInvoice({
    required String company,
    required double amount,
    required int tenorDays,
    required double returnRate,
  }) {
    final newInvoice = Invoice(
      id: 'INV-2025-${(_invoices.length + 1).toString().padLeft(3, '0')}',
      company: company,
      amount: amount,
      status: InvoiceStatus.pending,
      createdDate: DateTime.now(),
      tenorDays: tenorDays,
      returnRate: returnRate,
    );

    _invoices.insert(0, newInvoice);
    notifyListeners();
  }

  void updateInvoiceStatus(String invoiceId, InvoiceStatus status, {String? investmentId}) {
    final index = _invoices.indexWhere((inv) => inv.id == invoiceId);
    if (index != -1) {
      _invoices[index] = _invoices[index].copyWith(
        status: status,
        fundedDate: status == InvoiceStatus.funded ? DateTime.now() : null,
        blockchainHash: status == InvoiceStatus.funded ? _generateBlockchainHash() : null,
        investmentId: investmentId,
      );
      notifyListeners();
    }
  }

  void addInvestmentOpportunity({
    required String company,
    required String industry,
    required String grade,
    required double amount,
    required double returnRate,
    required int tenorDays,
    required String description,
    required bool isShariahCompliant,
    List<String>? documents,
  }) {
    final newOpp = InvestmentOpportunity(
      id: (_allOpportunities.length + 1).toString(),
      company: company,
      industry: industry,
      grade: grade,
      amount: amount,
      returnRate: returnRate,
      tenorDays: tenorDays,
      description: description,
      fundedPercentage: 0,
      investors: 0,
      blockchainHash: _generateBlockchainHash(),
      listedDate: DateTime.now(),
      isShariahCompliant: isShariahCompliant,
      documents: documents ?? ['Invoice.pdf'],
    );

    _allOpportunities.insert(0, newOpp);
    notifyListeners();
  }

  String _generateBlockchainHash() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return '0x${random.toRadixString(16).padLeft(40, '0')}';
  }

  // Get user investment for a specific opportunity
  UserInvestment? getUserInvestmentForOpportunity(String opportunityId) {
    try {
      return _userInvestments.firstWhere((inv) => inv.opportunityId == opportunityId);
    } catch (e) {
      return null;
    }
  }

  // Check if user has invested in an opportunity
  bool hasInvestedIn(String opportunityId) {
    return _userInvestments.any((inv) => inv.opportunityId == opportunityId);
  }
}
