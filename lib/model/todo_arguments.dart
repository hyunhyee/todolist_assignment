import 'package:todolist_assignment/main.dart';

class TodoArguments {
  final bool isUpdate;
  final bool isDelete;
  final TodoModel item;
  final int index;

  const TodoArguments(
      {this.isUpdate = false,
      this.isDelete = false,
      required this.index,
      required this.item});
}
