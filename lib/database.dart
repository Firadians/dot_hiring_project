import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/category_model.dart';
import 'models/transaction_model.dart'
    as custom; // Use an alias for your custom Transaction class

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY,
        dailyExpense REAL,
        monthlyExpense REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY,
        name TEXT,
        amount REAL,
        icon TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY,
        description TEXT,
        amount REAL,
        date TEXT
      )
    ''');
  }

  Future<void> insertUser(String username) async {
    final db = await database;
    await db.insert('users', {'username': username});
  }

  Future<String?> fetchUsername() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');
    if (maps.isNotEmpty) {
      return maps.first['username'] as String?;
    }
    return null;
  }

  // Expense methods
  Future<void> insertExpenses(
      double dailyExpense, double monthlyExpense) async {
    final db = await database;
    await db.insert('expenses',
        {'dailyExpense': dailyExpense, 'monthlyExpense': monthlyExpense});
  }

  Future<Map<String, dynamic>> fetchExpenses() async {
    final db = await database;
    final maps = await db.query('expenses');
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      throw Exception('No expenses found');
    }
  }

  // Category methods
  Future<void> insertCategories(List<Category> categories) async {
    final db = await database;
    for (var category in categories) {
      await db.insert('categories', {
        'name': category.name,
        'amount': category.amount,
        'icon': category.icon,
      });
    }
  }

  Future<List<Category>> fetchCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Category(
        name: maps[i]['name'] as String,
        amount: maps[i]['amount'] as double,
        icon: maps[i]['icon'] as String,
      );
    });
  }

  // Transaction methods
  Future<void> insertTransactions(List<custom.Transaction> transactions) async {
    final db = await database;
    for (var transaction in transactions) {
      await db.insert('transactions', {
        'description': transaction.description,
        'amount': transaction.amount,
        'date': transaction.date.toIso8601String(),
      });
    }
  }

  Future<List<custom.Transaction>> fetchTransactions() async {
    final db = await database;
    final maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return custom.Transaction(
        description: maps[i]['description'] as String,
        amount: maps[i]['amount'] as double,
        date: DateTime.parse(maps[i]['date'] as String),
      );
    });
  }
}
