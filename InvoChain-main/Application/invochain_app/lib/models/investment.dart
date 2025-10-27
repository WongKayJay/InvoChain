import 'package:flutter/material.dart';

class InvestmentOpportunity {
  final String id;
  final String company;
  final String industry;
  final String grade;
  final double amount;
  final double returnRate;
  final int tenorDays;
  final String description;
  final double fundedPercentage;
  final int investors;
  final String blockchainHash;
  final DateTime listedDate;
  final bool isShariahCompliant;
  final List<String> documents;

  InvestmentOpportunity({
    required this.id,
    required this.company,
    required this.industry,
    required this.grade,
    required this.amount,
    required this.returnRate,
    required this.tenorDays,
    required this.description,
    required this.fundedPercentage,
    required this.investors,
    required this.blockchainHash,
    required this.listedDate,
    this.isShariahCompliant = false,
    this.documents = const [],
  });

  Color get gradeColor {
    switch (grade) {
      case 'Grade A':
        return const Color(0xFF10B981); // Green
      case 'Grade B':
        return const Color(0xFF3B82F6); // Blue
      case 'Grade C':
        return const Color(0xFFF59E0B); // Orange
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  String get tenor => '$tenorDays days';
  
  String get formattedAmount => '\$${amount.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
    (Match m) => '${m[1]},'
  )}';
  
  String get formattedReturn => '${returnRate.toStringAsFixed(1)}%';

  InvestmentOpportunity copyWith({
    String? id,
    String? company,
    String? industry,
    String? grade,
    double? amount,
    double? returnRate,
    int? tenorDays,
    String? description,
    double? fundedPercentage,
    int? investors,
    String? blockchainHash,
    DateTime? listedDate,
    bool? isShariahCompliant,
    List<String>? documents,
  }) {
    return InvestmentOpportunity(
      id: id ?? this.id,
      company: company ?? this.company,
      industry: industry ?? this.industry,
      grade: grade ?? this.grade,
      amount: amount ?? this.amount,
      returnRate: returnRate ?? this.returnRate,
      tenorDays: tenorDays ?? this.tenorDays,
      description: description ?? this.description,
      fundedPercentage: fundedPercentage ?? this.fundedPercentage,
      investors: investors ?? this.investors,
      blockchainHash: blockchainHash ?? this.blockchainHash,
      listedDate: listedDate ?? this.listedDate,
      isShariahCompliant: isShariahCompliant ?? this.isShariahCompliant,
      documents: documents ?? this.documents,
    );
  }
}

class UserInvestment {
  final String id;
  final String opportunityId;
  final String company;
  final double investedAmount;
  final double returnRate;
  final DateTime investedDate;
  final DateTime maturityDate;
  final String status; // 'active', 'matured', 'pending'
  final String blockchainHash;
  final List<BlockchainEvent> chainEvents;

  UserInvestment({
    required this.id,
    required this.opportunityId,
    required this.company,
    required this.investedAmount,
    required this.returnRate,
    required this.investedDate,
    required this.maturityDate,
    required this.status,
    required this.blockchainHash,
    this.chainEvents = const [],
  });

  String get formattedAmount => '\$${investedAmount.toStringAsFixed(2)}';
  
  double get expectedReturn => investedAmount * (returnRate / 100);
  
  String get formattedExpectedReturn => '\$${expectedReturn.toStringAsFixed(2)}';
  
  int get daysRemaining => maturityDate.difference(DateTime.now()).inDays;
  
  double get progressPercentage {
    final totalDays = maturityDate.difference(investedDate).inDays;
    final daysPassed = DateTime.now().difference(investedDate).inDays;
    return (daysPassed / totalDays * 100).clamp(0, 100);
  }
}

class BlockchainEvent {
  final String type;
  final String description;
  final DateTime timestamp;
  final String transactionHash;

  BlockchainEvent({
    required this.type,
    this.description = '',
    required this.timestamp,
    required this.transactionHash,
  });
}
