import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/todos.dart';
import 'package:flutter_todo_app/widgets/todo_widget.dart';
import 'package:provider/provider.dart';

class TodoListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<TodosProvider>(context);
    final todos = providerr.todos;

    return todos.isEmpty
        ? Center(
            child: Text(
              'No todos.',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            separatorBuilder: (BuildContext context, int index) =>
                Container(height: 8),
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = todos[index];

              return TodoWidget(todo: todo);
            },
          );
  }
}
