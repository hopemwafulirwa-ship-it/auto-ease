class Transaction {
  final String id;
  final String jobId;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String description;

  const Transaction({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.date,
    required this.type,
    required this.description,
  });
}

enum TransactionType {
  earning,
  payout,
  bonus,
}
