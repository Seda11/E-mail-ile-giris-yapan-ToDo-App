import 'package:flutter/cupertino.dart';
import 'package:flutter_todo_app/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [
    Todo(
      createdTime: DateTime.now(),
      title: 'Ev',
      description: '''- Tamirci Çağır
- priz al''',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'İş',
      description: '''- alınacakları listele
- projeyi teslim et''',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Market',
      description: '''- domates
- biber
- patlıcan''',
    ),
  ];

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
}
