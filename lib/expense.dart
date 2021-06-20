final String tableExpense = 'expenses';

class ExpenseFields {
  static final List<String> values = [id, money, des, time];

  static final String id = '_id';
  static final String money = 'money';
  static final String des = 'des';
  static final String time = 'time';
}

class Expense {
  final int? id;
  final num money;
  final String des;
  final DateTime createdTime;

  const Expense({
    this.id,
    required this.money,
    required this.des,
    required this.createdTime,
  });

  Expense copy({
    int? id,
    num? money,
    String? des,
    DateTime? createdTime,
  }) =>
      Expense(
        id: id,
        money: money!,
        des: des!,
        createdTime: createdTime!,
      );

  static Expense fromJson(Map<String, Object?> json) => Expense(
        id: json[ExpenseFields.id] as int?,
        money: json[ExpenseFields.money] as num,
        des: json[ExpenseFields.des] as String,
        createdTime: DateTime.parse(json[ExpenseFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        ExpenseFields.id: id,
        ExpenseFields.money: money,
        ExpenseFields.des: des,
        ExpenseFields.time: createdTime.toIso8601String(),
      };
}
