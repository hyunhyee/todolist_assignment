import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist_assignment/main.dart';

class todoList_detail extends StatefulWidget {
  TodoModel todo;
  final String? restorationId;

  todoList_detail({Key? key, required this.todo, this.restorationId})
      : super(key: key);

  @override
  State<todoList_detail> createState() => _todoList_detailState();
}

class _todoList_detailState extends State<todoList_detail>
    with RestorationMixin {

  final _todoUpdateController = TextEditingController();
  late TodoModel todo;

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2022),
          lastDate: DateTime(2023),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
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
              print('delete delete');
              setState(() {
                _todoList.remove(todo);
              });
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
              // hintText: todo.title,
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
              Text(
                  '${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}'),
              OutlinedButton(
                onPressed: () {
                  _restorableDatePickerRouteFuture.present();
                },
                child: const Text('마감 기한 설정'),
              ),
            ],
          ),
          FloatingActionButton(onPressed: () {}),
        ],
      ),
    );
  }
}
