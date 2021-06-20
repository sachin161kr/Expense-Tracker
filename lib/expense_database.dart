import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './expense.dart';

class ExpenseDatabase {
  static final ExpenseDatabase instance = ExpenseDatabase._init();
  static Database? _database;
  ExpenseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('expense.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final moneyType = 'REAL NOT NULL';
    final textType = 'TEXT NOT NULL';

    // return db.execute(
    //     'CREATE TABLE $tableExpense ( ${ExpenseFields.id} $idType , ${ExpenseFields.money} $moneyType , ${ExpenseFields.des} $textType , ${ExpenseFields.time} $textType, ) ');

    await db.execute('''CREATE TABLE $tableExpense
      (
      ${ExpenseFields.id} $idType,
      ${ExpenseFields.money} $moneyType,
      ${ExpenseFields.des} $textType,
      ${ExpenseFields.time} $textType
      )

      ''');
  }

  Future<Expense> create(Expense expense) async {
    final db = await instance.database;

    final id = await db.insert(tableExpense, expense.toJson());

    return expense.copy(id: id);
  }

  Future<Expense> readExpense(int id) async {
    final db = await database;

    final maps = await db.query(
      tableExpense,
      columns: ExpenseFields.values,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Expense.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Expense>> readAllExpenses() async {
    final db = await instance.database;

    final orderBy = '${ExpenseFields.time} DESC ';
    final result = await db.query(tableExpense, orderBy: orderBy);

    return result.map((json) => Expense.fromJson(json)).toList();
  }

  Future<int> update(Expense expense) async {
    final db = await instance.database;
    return db.update(tableExpense, expense.toJson(),
        where: '${ExpenseFields.id} = ?', whereArgs: [expense.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(tableExpense,
        where: '${ExpenseFields.id} = ?', whereArgs: [id]);
  }

  Future deleteAll() async {
    final db = await instance.database;

    return db.delete(tableExpense);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
