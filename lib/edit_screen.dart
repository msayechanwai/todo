import 'package:flutter/material.dart';
import 'package:todo/db/todo_dao.dart';
import 'package:todo/db/todo_database.dart';

import 'db/todo.dart';

class EditScreen extends StatefulWidget {
  int id;
  EditScreen(this.id);
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  late final database;
  late TodoDao todoDao;
  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnection();
  }

  getConnection() async{
   this.database= await $FloorTodoDatabase.databaseBuilder("todo_database.db").build();
   this.todoDao= database.todoDao;

   Todo? todo= await this.todoDao.findTodoById(widget.id);
   setState(() {
     this.controller= TextEditingController(text: todo!.task);
   });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Text"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: [
        Form(child: Container(
          key: key,
          padding: EdgeInsets.all(10),
          child: Column(children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: "Enter Something",
                  labelText: "To Do List"
              ),
              validator: (value){
                if (value == null || value.isEmpty){
                  return " Must Not Be Null";
                }
                return null;
              },
            )
          ],
          ),
        )),
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: OutlinedButton(
            onPressed: () async{
              setState(() {
                this.todoDao.updateById(widget.id, controller.text);
              });
              Navigator.pop(context);
            },
            child: Text("Update", style: TextStyle(color: Colors.white),),
          ),
        ),

      ],),
    );
  }
}
