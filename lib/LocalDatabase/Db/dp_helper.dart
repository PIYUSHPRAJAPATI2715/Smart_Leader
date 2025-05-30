import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_leader/LocalDatabase/modals/Task.dart';
import 'package:smart_leader/LocalDatabase/modals/add_note.dart';
import 'package:smart_leader/LocalDatabase/modals/connection_type.dart';
import 'package:smart_leader/LocalDatabase/modals/connections.dart';
import 'package:smart_leader/LocalDatabase/modals/expense.dart';
import 'package:smart_leader/LocalDatabase/modals/folder.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _versoin = 1;
  static const String _tableName = "tasks";
  static const String _notesTable = "notes";
  static const String _folderTable = "folder";
  static const String _connectionTypeTable = 'connection_type';
  static const String _connectionDataTable = 'connections';

  //todo: Expense table:
  static const String _expenseTable = 'expense';

  static const String _taskQuery =
      'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, summary TEXT, date TEXT, time TEXT, color TEXT, type TEXT, reminder TEXT, isCompleted INTEGER)';

  //todo: create notes table query
  static const String _notesQuery =
      'CREATE TABLE $_notesTable(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT,folderName TEXT,createdDate TEXT)';

  //todo: create folder table query
  static const String _folderCreateQuery =
      'CREATE TABLE $_folderTable(id INTEGER PRIMARY KEY AUTOINCREMENT,folderName TEXT,createdOn TEXT)';

  //todo: create connection table query
  static const String _connectionTypeQuery =
      'CREATE TABLE $_connectionTypeTable(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,connectionCount TEXT)';

  //todo: create connection table query
  static const String _connectionQuery =
      'CREATE TABLE $_connectionDataTable(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,number TEXT,occupation TEXT, date TEXT, time TEXT, remind TEXT, connectionTypeId TEXT, meetingReq TEXT, meetingCount TEXT)';

  //todo: create Expense table
  static const String _expenseQuery =
      'CREATE TABLE $_expenseTable(id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT,amount TEXT,category TEXT,note TEXT,type TEXT, readableDate TEXT, other TEXT)';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = "${await getDatabasesPath()}smart.db";
      _db = await openDatabase(path, version: _versoin, onCreate: (db, ver) {
        _createTables(db, ver);
      });
    } catch (e) {
      if (kDebugMode) {
        print('TEsting ${e}');
      }
    }
  }

  static Future _createTables(Database db, int version) async {
    await db.execute(_taskQuery);
    await db.execute(_notesQuery);
    await db.execute(_folderCreateQuery);
    await db.execute(_connectionTypeQuery);
    await db.execute(_connectionQuery);
    await db.execute(_expenseQuery);
  }

  static Future<int> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? 100;
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    return await _db!.query(_tableName);
  }

  static Future<int> deleteTask(int id) async {
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> updateTask(Task? task) async {
    return await _db!.update(
      _tableName,
      task!.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  //todo: ----------------- CREATE TASK ------------------------

  static Future<int> insertNote(AddNote? addNote) async {
    return await _db!.insert(_notesTable, addNote!.toJson()) ?? -1;
  }

  static Future<List<Map<String, dynamic>>> getNotes(String folderName) async {
    return await _db!
        .query(_notesTable, where: 'folderName = ?', whereArgs: [folderName]);
  }

  static Future<int> deleteNote(int id) async {
    return await _db!.delete(
      _notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> updateNote(AddNote? addNote) async {
    return await _db!.update(
      _notesTable,
      addNote!.toJson(),
      where: 'id = ?',
      whereArgs: [addNote.id],
    );
  }

  //todo:  -------------------- CREATE FOLDER -------------------------------
  static Future<int> insertFolder(Folder? folder) async {
    return await _db!.insert(_folderTable, folder!.toJson()) ?? -1;
  }

  static Future<List<Map<String, dynamic>>> getFolder() async {
    return await _db!.query(_folderTable);
  }

  static Future<int> deleteFolder(int id) async {
    return await _db!.delete(
      _folderTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //todo: CREATE CONNECTION TYPE------------------------------------------

  static Future<int> insertConnectionType(
      ConnectionType? connectionType) async {
    await _db!.delete(_connectionTypeTable);
    return await _db!.insert(_connectionTypeTable, connectionType!.toJson());
  }

  static Future<List<Map<String, dynamic>>> getConnectionType() async {
    return await _db!.query(_connectionTypeTable);
  }

  //todo: CREATE CONNECTIONS
  static Future<int> insertConnection(Connections? connectionType) async {
    return await _db!.insert(_connectionDataTable, connectionType!.toJson());
  }

  static Future<List<Map<String, dynamic>>> getConnections(
      String connectionId) async {
    return await _db!.query(_connectionDataTable,
        where: 'connectionTypeId = ?', whereArgs: [connectionId]);
  }

  static Future<int> updateConnection(Connections? connections) async {
    return await _db!.update(
      _connectionDataTable,
      connections!.toJson(),
      where: 'id = ?',
      whereArgs: [connections.id],
    );
  }

  static Future<int> deleteConnections(int id) async {
    return await _db!.delete(
      _connectionDataTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //todo: CREATE EXPENSE------------------------------------------------------
  static Future<int> insertExpense(Expense expense) async {
    return await _db!.insert(_expenseTable, expense.toJson());
  }

  static Future<List<Expense>> getExpense() async {
    List<Map<String, dynamic>> expenseMap = await _db!.query(_expenseTable);
    return expenseMap.map((e) => Expense.fromJson(e)).toList();
  }

  static Future<List<Expense>> getExpenseByMonth(String date) async {
    List<Map<String, dynamic>> expenseMap = await _db!
        .query(_expenseTable, where: 'readableDate = ?', whereArgs: [date]);

    return expenseMap.map((e) => Expense.fromJson(e)).toList();
  }

  static Future<List<Expense>> getWeeklyExpense(String date) async {
    DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    String formattedDate = sevenDaysAgo.toIso8601String().substring(0, 10);

    List<Map<String, dynamic>> expenseMap = await _db!
        .query(_expenseTable, where: 'date >= ?', whereArgs: [formattedDate]);

    print('Expense $expenseMap');

    return expenseMap.map((e) => Expense.fromJson(e)).toList();
  }
}
