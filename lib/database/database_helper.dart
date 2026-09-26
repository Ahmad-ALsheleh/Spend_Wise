import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

/// طبقة الوصول الوحيدة لقاعدة بيانات SQLite المحلية.

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  static const String _tableName = 'transactions';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'spendwise.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category_key TEXT NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ---------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------

  Future<TransactionModel> insertTransaction(TransactionModel tx) async {
    final db = await database;
    final id = await db.insert(
      _tableName,
      tx.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return tx.copyWith(id: id);
  }

  Future<int> updateTransaction(TransactionModel tx) async {
    final db = await database;
    return db.update(
      _tableName,
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// كل المعاملات (تُستخدم بقسم Recent بالشاشة الرئيسية - غير مقيدة بالشهر)
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final rows = await db.query(_tableName, orderBy: 'date DESC, id DESC');
    return rows.map((e) => TransactionModel.fromMap(e)).toList();
  }

  /// معاملات شهر محدد فقط (تُستخدم بشاشتي Overview - البطاقة، وHistory)
  Future<List<TransactionModel>> getTransactionsByMonth(
      int year,
      int month,
      ) async {
    final db = await database;
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await db.query(
      _tableName,
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC, id DESC',
    );
    return rows.map((e) => TransactionModel.fromMap(e)).toList();
  }

  /// معاملات نطاق تاريخ محدد (تُستخدم بوضع Week بشاشة Analytics)
  Future<List<TransactionModel>> getTransactionsByRange(
      DateTime start,
      DateTime endExclusive,
      ) async {
    final db = await database;
    final rows = await db.query(
      _tableName,
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), endExclusive.toIso8601String()],
      orderBy: 'date DESC, id DESC',
    );
    return rows.map((e) => TransactionModel.fromMap(e)).toList();
  }
}