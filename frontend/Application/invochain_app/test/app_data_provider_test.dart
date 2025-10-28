#!/usr/bin/env dart
// InvoChain Data Flow Test
// This script verifies that the database and state management work correctly

import 'package:flutter_test/flutter_test.dart';
import 'package:invochain_app/services/app_data_provider.dart';
import 'package:invochain_app/models/investment.dart';
import 'package:invochain_app/models/invoice.dart';

void main() {
  group('AppDataProvider Data Flow Tests', () {
    late AppDataProvider provider;

    setUp(() {
      provider = AppDataProvider();
    });

    test('Initial data should be loaded', () {
      expect(provider.allOpportunities.length, greaterThan(0));
      expect(provider.userInvestments.length, greaterThan(0));
      expect(provider.invoices.length, greaterThan(0));
    });

    test('Portfolio calculations should work', () {
      final totalValue = provider.totalPortfolioValue;
      final totalInvested = provider.totalInvested;
      final totalReturns = provider.totalReturns;
      
      expect(totalValue, greaterThan(0));
      expect(totalInvested, greaterThan(0));
      expect(totalReturns, greaterThanOrEqualTo(0));
      expect(totalValue, equals(totalInvested + totalReturns));
    });

    test('Adding investment should update portfolio', () {
      final initialPortfolioValue = provider.totalPortfolioValue;
      final initialInvestmentCount = provider.userInvestments.length;
      final opportunity = provider.allOpportunities.first;
      final investmentAmount = 5000.0;

      provider.addInvestment(opportunity, investmentAmount);

      expect(provider.userInvestments.length, equals(initialInvestmentCount + 1));
      expect(provider.totalPortfolioValue, greaterThan(initialPortfolioValue));
    });

    test('Adding investment should update opportunity funding', () {
      final opportunity = provider.allOpportunities.first;
      final initialFundingPercentage = opportunity.fundedPercentage;
      final initialInvestorCount = opportunity.investors;
      
      provider.addInvestment(opportunity, 1000.0);
      
      final updatedOpportunity = provider.allOpportunities
          .firstWhere((opp) => opp.id == opportunity.id);
      
      expect(updatedOpportunity.fundedPercentage, greaterThan(initialFundingPercentage));
      expect(updatedOpportunity.investors, equals(initialInvestorCount + 1));
    });

    test('Adding invoice should update invoice count', () {
      final initialInvoiceCount = provider.totalInvoices;
      
      provider.addInvoice(
        company: 'Test Company',
        amount: 10000,
        tenorDays: 30,
        returnRate: 3.5,
      );
      
      expect(provider.totalInvoices, equals(initialInvoiceCount + 1));
      expect(provider.invoices.first.company, equals('Test Company'));
    });

    test('Updating invoice status should work', () {
      final invoice = provider.invoices.first;
      final initialStatus = invoice.status;
      
      provider.updateInvoiceStatus(
        invoice.id, 
        InvoiceStatus.funded,
        investmentId: 'test-inv-1',
      );
      
      final updatedInvoice = provider.invoices
          .firstWhere((inv) => inv.id == invoice.id);
      
      expect(updatedInvoice.status, equals(InvoiceStatus.funded));
      expect(updatedInvoice.status, isNot(equals(initialStatus)));
      expect(updatedInvoice.blockchainHash, isNotNull);
    });

    test('Listener notification should trigger on data changes', () {
      var notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.addInvoice(
        company: 'Test Company 2',
        amount: 15000,
        tenorDays: 45,
        returnRate: 4.0,
      );

      expect(notificationCount, equals(1));
    });
  });

  group('Data Interconnection Tests', () {
    test('Investment affects multiple data points', () {
      final provider = AppDataProvider();
      final opportunity = provider.allOpportunities.first;
      
      final beforeStats = {
        'portfolioValue': provider.totalPortfolioValue,
        'totalInvested': provider.totalInvested,
        'activeInvestments': provider.activeInvestments,
        'fundingPercentage': opportunity.fundedPercentage,
        'investorCount': opportunity.investors,
      };

      provider.addInvestment(opportunity, 3000.0);

      final afterStats = {
        'portfolioValue': provider.totalPortfolioValue,
        'totalInvested': provider.totalInvested,
        'activeInvestments': provider.activeInvestments,
        'fundingPercentage': provider.allOpportunities
            .firstWhere((opp) => opp.id == opportunity.id)
            .fundedPercentage,
        'investorCount': provider.allOpportunities
            .firstWhere((opp) => opp.id == opportunity.id)
            .investors,
      };

      // Verify all related data points updated
      expect(afterStats['portfolioValue']!, greaterThan(beforeStats['portfolioValue']!));
      expect(afterStats['totalInvested']!, greaterThan(beforeStats['totalInvested']!));
      expect(afterStats['activeInvestments']!, greaterThan(beforeStats['activeInvestments']!));
      expect(afterStats['fundingPercentage']!, greaterThan(beforeStats['fundingPercentage']!));
      expect(afterStats['investorCount']!, greaterThan(beforeStats['investorCount']!));
    });
  });
}

/*
EXPECTED OUTPUT:

✅ Initial data should be loaded
✅ Portfolio calculations should work
✅ Adding investment should update portfolio
✅ Adding investment should update opportunity funding
✅ Adding invoice should update invoice count
✅ Updating invoice status should work
✅ Listener notification should trigger on data changes
✅ Investment affects multiple data points

RESULT: All tests should pass, confirming:
1. Database (AppDataProvider) is operational
2. Data is interconnected and updates dynamically
3. State management triggers UI updates
4. All calculations are accurate
*/
