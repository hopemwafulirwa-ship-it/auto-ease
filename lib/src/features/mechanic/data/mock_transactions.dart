import 'package:auto_ease/src/features/mechanic/domain/transaction.dart';

final kMockTransactions = [
  Transaction(
    id: 'txn_001',
    jobId: 'job_101',
    amount: 150.00,
    date: DateTime.now().subtract(const Duration(hours: 2)),
    type: TransactionType.earning,
    description: 'Full Service - Toyota Camry',
  ),
  Transaction(
    id: 'txn_002',
    jobId: 'job_102',
    amount: 75.00,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    type: TransactionType.earning,
    description: 'Oil Change - Honda Accord',
  ),
  Transaction(
    id: 'txn_003',
    jobId: 'job_103',
    amount: 120.00,
    date: DateTime.now().subtract(const Duration(days: 1)),
    type: TransactionType.earning,
    description: 'Battery Replacement - Ford F-150',
  ),
  Transaction(
    id: 'txn_004',
    jobId: 'payout_001',
    amount: -500.00,
    date: DateTime.now().subtract(const Duration(days: 2)),
    type: TransactionType.payout,
    description: 'Weekly Payout',
  ),
  Transaction(
    id: 'txn_005',
    jobId: 'bonus_001',
    amount: 50.00,
    date: DateTime.now().subtract(const Duration(days: 3)),
    type: TransactionType.bonus,
    description: 'Performance Bonus',
  ),
];
