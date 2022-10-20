import 'package:flutter/material.dart';
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
                return listItemCardWidget(_todoList[index]);
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

  Widget listItemCardWidget(TodoModel todo) {
    return Card(
      child: ListTile(
        onTap: () async {
          _todoUpdateController.text = todo.title;
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoListDetail(todo: todo),
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
          if (result == 'Delete') {
            setState(() {
              _todoList.remove(todo);
            });
          } else if (result == 'Update') {
            setState(() {
              todo.title = _todoUpdateController.text;
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
