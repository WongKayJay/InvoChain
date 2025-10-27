import 'package:flutter/material.dart';

class Invoice {
  final String id;
  final String company;
  final double amount;
  final InvoiceStatus status;
  final DateTime createdDate;
  final DateTime? fundedDate;
  final String? blockchainHash;
  final int tenorDays;
  final double returnRate;
  final String? investmentId; // Link to investment if funded through platform

  Invoice({
    required this.id,
    required this.company,
    required this.amount,
    required this.status,
    required this.createdDate,
    this.fundedDate,
    this.blockchainHash,
    required this.tenorDays,
    required this.returnRate,
    this.investmentId,
  });

  Invoice copyWith({
    String? id,
    String? company,
    double? amount,
    InvoiceStatus? status,
    DateTime? createdDate,
    DateTime? fundedDate,
    String? blockchainHash,
    int? tenorDays,
    double? returnRate,
    String? investmentId,
  }) {
    return Invoice(
      id: id ?? this.id,
      company: company ?? this.company,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      fundedDate: fundedDate ?? this.fundedDate,
      blockchainHash: blockchainHash ?? this.blockchainHash,
      tenorDays: tenorDays ?? this.tenorDays,
      returnRate: returnRate ?? this.returnRate,
      investmentId: investmentId ?? this.investmentId,
    );
  }

  Color get statusColor {
    switch (status) {
      case InvoiceStatus.funded:
        return Colors.green;
      case InvoiceStatus.pending:
        return Colors.orange;
      case InvoiceStatus.underReview:
        return Colors.blue;
      case InvoiceStatus.rejected:
        return Colors.red;
      case InvoiceStatus.completed:
        return Colors.purple;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case InvoiceStatus.funded:
        return Icons.check_circle;
      case InvoiceStatus.pending:
        return Icons.pending;
      case InvoiceStatus.underReview:
        return Icons.schedule;
      case InvoiceStatus.rejected:
        return Icons.cancel;
      case InvoiceStatus.completed:
        return Icons.done_all;
    }
  }

  String get statusText {
    switch (status) {
      case InvoiceStatus.funded:
        return 'Funded';
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.underReview:
        return 'Under Review';
      case InvoiceStatus.rejected:
        return 'Rejected';
      case InvoiceStatus.completed:
        return 'Completed';
    }
  }
}

enum InvoiceStatus {
  pending,
  underReview,
  funded,
  rejected,
  completed,
}
