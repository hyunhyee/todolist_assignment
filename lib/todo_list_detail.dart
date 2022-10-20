import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist_assignment/main.dart';

class TodoListDetail extends StatefulWidget {
  final TodoModel todo;

  const TodoListDetail({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoListDetail> createState() => _TodoListDetailState();
}

class _TodoListDetailState extends State<TodoListDetail> {
  final _todoUpdateController = TextEditingController();
  TodoModel? todo;

  late DateTime pickedDate;

  @override
  void initState() {
    super.initState();
    todo = TodoModel(
        //   title: widget.todo.title, content: widget.todo!.content, isDone: false);
        title: widget.todo.title,
        isDone: widget.todo.isDone);
    _todoUpdateController.text = todo!.title;
    pickedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () {
              Navigator.of(context).pop('Delete');
            },
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _todoUpdateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: [
              Text('완료여부'),
            ],
          ),
          Row(
            children: [
              Text('마감기한'),
              Text('${pickedDate.year}-${pickedDate.month}-${pickedDate.day}'),
              OutlinedButton(
                onPressed: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: pickedDate,
                    firstDate: DateTime(DateTime.now().year - 5),
                    lastDate: DateTime(DateTime.now().year + 5),
                  );
                  if (date != null)
                    setState(() {
                      pickedDate = date;
                    });
                },
                child: const Text('마감 기한 설정'),
              ),
            ],
          ),
          FloatingActionButton(onPressed: () {
            setState(() {
              todo!.title = _todoUpdateController.text;
            });
            Navigator.of(context).pop('Update');
          }),
        ],
      ),
    );
  }
}
