import 'package:flutter/material.dart';

void main() {
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const Page(title: 'To-Do List'),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key, required this.title});

  final String title;

  @override
  State<Page> createState() => _PageState();
}

class Item {
  String name;
  String description;
  String date;
  String time;
  
  Item(
      this.name,
      this.description,
      this.date,
      this.time, );
}

class _PageState extends State<Page> {
  final List<Item> _todoList = <Item>[];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _todoList.map((Item i) => Tile(i)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddDialog(Item("", "", "", "")),
        child: Icon(Icons.add)
      ),
    );
  }

  Widget Tile(Item todo) {
    return ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(4, 2, 2, 4),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(todo.name), Text(todo.description)],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(todo.date),
                  Text(todo.time),
                ],
              ),
            )
          ],
        ),
        trailing: Column(
          children: [
            GestureDetector(
              onTap: () {
                _displayAddDialog(todo);
              },
              child: Text("Edit"),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _todoList.remove(todo);
                });
              },
              child: Text("Delete"),
            )
          ],
        ));
  }

  Future<void> _displayAddDialog(Item todo) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          children: [
            AlertDialog(
              content: Column(
                children: [
                  TextField( // NAME
                    controller: nameController,
                  ),
                  
                  TextField( // DESCRIPTION
                    controller: descriptionController,
                  ),
                  
                  TextField( // DATE
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1999),
                          lastDate: DateTime(2400));
                      if (date != null) {
                        setState(() {
                          dateController.text = "${date.month}/${date.day}/${date.year}";
                        });
                      }
                    },
                  ),
                  
                  TextField( // TIME
                    controller: timeController,
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());

                      if (time != null) {
                        setState(() {
                          timeController.text =
                              "${time.hour}:${time.minute}";
                        });
                      }
                    },
                  ),
                ],
              ),
              
              
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    nameController.clear();
                    descriptionController.clear();
                    dateController.clear();
                    timeController.clear();
                  },
                ),

                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _todoList.add(Item(nameController.text, descriptionController.text, dateController.text, timeController.text));
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}