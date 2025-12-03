import 'package:flutter/material.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/features/mechanic/data/mock_transactions.dart';
import 'package:auto_ease/src/features/mechanic/domain/transaction.dart';
import 'package:intl/intl.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const todayEarnings = 345.0;
    const weekEarnings = 1240.0;
    const monthEarnings = 4850.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Earnings Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildEarningsCard(
                      context,
                      label: 'Today',
                      amount: todayEarnings,
                      icon: Icons.today,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEarningsCard(
                      context,
                      label: 'This Week',
                      amount: weekEarnings,
                      icon: Icons.date_range,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildEarningsCard(
                context,
                label: 'This Month',
                amount: monthEarnings,
                icon: Icons.calendar_month,
                isLarge: true,
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      label: 'Jobs Completed',
                      value: '24',
                      icon: Icons.assignment_turned_in,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      label: 'Avg. Per Job',
                      value: '\$${(monthEarnings / 24).toStringAsFixed(0)}',
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Transaction History
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...kMockTransactions
                  .map((txn) => _buildTransactionCard(context, txn)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsCard(
    BuildContext context, {
    required String label,
    required double amount,
    required IconData icon,
    bool isLarge = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassCard(
      padding: EdgeInsets.all(isLarge ? 24 : 20),
      child: isLarge
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.green, size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${amount.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.secondary, size: 20),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction txn) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPositive = txn.amount > 0;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getTransactionColor(txn.type).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTransactionIcon(txn.type),
              color: _getTransactionColor(txn.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(txn.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}\$${txn.amount.abs().toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.earning:
        return Colors.green;
      case TransactionType.payout:
        return Colors.blue;
      case TransactionType.bonus:
        return Colors.amber;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.earning:
        return Icons.add_circle_outline;
      case TransactionType.payout:
        return Icons.account_balance;
      case TransactionType.bonus:
        return Icons.stars;
    }
  }
}
