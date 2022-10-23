import 'package:flutter/material.dart';
import 'package:todolist_assignment/model/todo_arguments.dart';
import 'package:todolist_assignment/todo_list_detail.dart';

void main() {
  runApp(MaterialApp(
    home: TodoList(),
  ));
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class TodoModel {
  String title;
//String content;
  bool isDone;
  //TodoModel({required this.title, required this.content, required this.isDone});
  TodoModel({required this.title, required this.isDone});
}

class _TodoListState extends State<TodoList> {
  List<TodoModel> _todoList = [];

  final _todoController = TextEditingController();
  final _todoUpdateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return listItemCardWidget(_todoList[index], index, context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  ),
                ),
                const SizedBox(
                  width: 600,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      print(_todoController.text);
                      setState(() {
                        _todoList.add(TodoModel(
                          title: _todoController.text,
                          // content: _todoController.text,
                          isDone: false,
                        ));
                        _todoController.clear();
                      });
                    },
                    child: const Text('Add'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listItemCardWidget(TodoModel todo, int index, BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          _todoUpdateController.text = todo.title;
          TodoArguments? result = await Navigator.push(
            context,
            MaterialPageRoute<TodoArguments>(
              builder: (context) =>
                  TodoListDetail(args: TodoArguments(item: todo, index: index)),
            ),
          );
          /*showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(todo.title),
                  content: Container(
                    child: Expanded(
                      child: TextField(
                        controller: _todoUpdateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Title',
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('Delete');
                      },
                      child: const Text('Delete'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('Update');
                      },
                      child: const Text('Update'),
                    ),
                  ],
                );
              });*/
          print(result);
          if (result != null && result.isDelete) {
            setState(() {
              _todoList.removeAt(result.index);
            });
          } else if (result != null && result.isUpdate) {
            setState(() {
              _todoList[result.index] = result.item;
            });
          }
        },
        title: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: todo.isDone,
              onChanged: (bool? value) {
                setState(() {
                  todo.isDone = value!;
                });
              },
            ),
            Text(
              todo.title,
              style: _getTextStyle(todo.isDone),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle? _getTextStyle(bool isDone) {
  if (!isDone) return null;

  return TextStyle(
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  );
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return Colors.blue;
}
