import 'package:flutter/material.dart';
import 'package:test_invennico_todo_list/Model/Todo.dart';
import 'package:test_invennico_todo_list/Model/TodoItem.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _AddItem = TextEditingController();

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Task '),
          content: TextField(
            controller: _AddItem,
            decoration: const InputDecoration(hintText: 'Type your task'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_AddItem.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayEditDialog(int index) async {
    _AddItem.text =
        _todos[index].name; // Pre-fill the dialog with the current task's name.
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: _AddItem,
            decoration: const InputDecoration(hintText: 'Type your task'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                _editTodoItem(index, _AddItem.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Todo list',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final Todo todo = _todos[index];
          return Dismissible(
            key: Key(todo.name),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                _todos.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${todo.name} removed")));
            },
            background: Container(
              color: Colors.red,
              child: const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
            child: TodoItem(
              todo: todo,
              onTodoChanged: _handleTodoChange,
              onLongPress: () {
                _displayEditDialog(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => _displayDialog(),
          tooltip: 'Add Item',
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _AddItem.clear();
  }

  void _editTodoItem(int index, String newName) {
    setState(() {
      _todos[index].name = newName;
    });
    _AddItem.clear();
  }
}
