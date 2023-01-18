import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransacationModel obj);
  Future<List<TransacationModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransacationModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransacationModel obj) async {
    final _db = await Hive.openBox<TransacationModel>(TRANSACTION_DB_NAME);
    _db.put(obj.id, obj);
  }

  Future<void> refreshUI() async {
    final _list = await getAllTransactions();
    _list.sort(
      (a, b) => b.date.compareTo(a.date),
    );
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransacationModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransacationModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransacationModel>(TRANSACTION_DB_NAME);
    _db.delete(id);
    refreshUI();
  }
}
