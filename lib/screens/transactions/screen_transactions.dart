import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management/db/category/category_db.dart';
import 'package:money_management/db/transaction/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    CategoryDB.instance.refreshUI();

    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransacationModel> newlist, _) {
        return ListView.separated(
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            final value = newlist[index];
            return Slidable(
              key: Key(value.id!),
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    foregroundColor: Colors.red,
                    onPressed: (context) {
                      TransactionDB.instance.deleteTransaction(value.id!);
                    },
                    icon: Icons.delete_rounded,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: value.type == CategoryType.income
                        ? const Color.fromARGB(255, 12, 234, 19)
                        : const Color.fromARGB(255, 239, 45, 32),
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          parseDate(
                            value.date,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'RS.${value.amount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(value.category.name),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 5,
            );
          },
          itemCount: newlist.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.yMMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.elementAt(1)}${_splitedDate.first}\n${_splitedDate.last}';
  }
}
