import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/app_settings.dart';
import '../models/transaction_model.dart';

/// طبقة الوصول الوحيدة لقاعدة بيانات SQLite المحلية.
///
/// سجل النسخ:
/// - 1: جدول transactions.
/// - 2: جدول settings (اللغة والمظهر). الترحيل لا يمس المعاملات الموجودة.
/// - 3: عمود currency بجدول transactions؛ المعاملات الموجودة تصبح USD.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  static const int _version = 3;
  static const String _tableName = 'transactions';
  static const String _settingsTable = 'settings';

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
      version: _version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category_key TEXT NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL,
            currency TEXT NOT NULL DEFAULT 'USD'
          )
        ''');
        await _createSettingsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _createSettingsTable(db);
        if (oldVersion < 3) {
          // كل ما سُجّل قبل دعم الليرة كان بالدولار.
          await db.execute(
            "ALTER TABLE $_tableName ADD COLUMN currency TEXT NOT NULL DEFAULT 'USD'",
          );
        }
      },
    );
  }

  Future<void> _createSettingsTable(DatabaseExecutor db) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS $_settingsTable (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
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

  /// كل المعاملات مرتبة من الأحدث.
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final rows = await db.query(_tableName, orderBy: 'date DESC, id DESC');
    return rows.map((e) => TransactionModel.fromMap(e)).toList();
  }

  /// معاملات شهر محدد فقط (Overview وHistory ووضع Month بشاشة Analytics)
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

  // ---------------------------------------------------------------------
  // الإعدادات
  // ---------------------------------------------------------------------

  Future<AppSettings> getSettings() async {
    final db = await database;
    final rows = await db.query(_settingsTable);
    return AppSettings.fromMap({
      for (final row in rows) row['key'] as String: row['value'] as String,
    });
  }

  Future<void> saveSettings(AppSettings settings) async {
    final db = await database;
    final batch = db.batch();
    settings.toMap().forEach((key, value) {
      batch.insert(
        _settingsTable,
        {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit(noResult: true);
  }
}
