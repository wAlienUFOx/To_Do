import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _userToDo = '';
  List toDoList = [];
  List check = [];
  int counter = 0;


  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0);
      int i = 0;
      while (i < counter){
        toDoList.add(prefs.getString('toDo$i'));
        check.add(prefs.getBool('check$i'));
        i++;
      }
    });
  }

  void increment(String string) async{
    final prefs = await SharedPreferences.getInstance();
    toDoList.clear();
    check.clear();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0) + 1;
      int i = 0;
      while (i < counter - 1){
        toDoList.add(prefs.getString("toDo$i"));
        check.add(prefs.getBool('check$i'));
        i++;
      }
      toDoList.add(string);
      check.add(false);
      i = 0;
      while (i < counter){
        prefs.setString('toDo$i', toDoList[i]);
        prefs.setBool('check$i', check[i]);
        i++;
      }
      prefs.setInt('counter', counter);
    });
  }

  void checked(int id) async{
    final prefs = await SharedPreferences.getInstance();
    check.clear();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0);
      int i = 0;
      while (i < counter){
        check.add(prefs.getBool('check$i'));
        i++;
      }
      check[id] = !check[id];
      i = 0;
      while (i < counter){
        prefs.setBool('check$i', check[i]);
        i++;
      }
    });
  }

  void decrement(int id) async{
    final prefs = await SharedPreferences.getInstance();
    toDoList.clear();
    check.clear();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0) - 1;
      int i = 0;
      while (i <= counter){
        toDoList.add(prefs.getString('toDo$i'));
        check.add(prefs.getBool('check$i'));
        i++;
      }
      toDoList.removeAt(id);
      check.removeAt(id);
      i = 0;
      while (i < counter){
        prefs.setString('toDo$i', toDoList[i]);
        prefs.setBool('check$i', check[i]);
        i++;
      }
      prefs.setInt('counter', counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("To do list"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
                key: Key(toDoList[index]),
                child: Card(
                  child: ListTile(
                    title: Text(toDoList[index]),
                    trailing: Checkbox(
                      value: check[index],
                      activeColor: Colors.amber,
                      onChanged: (value){
                          checked(index);
                      },
                    ),
                  ),
                ),
                onDismissed: (direction){
                    decrement(index);
            },
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Add element'),
              content: TextField(
                onChanged: (String value){
                  _userToDo = value;
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    increment(_userToDo);
                    Navigator.of(context).pop();
                    },
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber
                  ),
                )
              ],
            );
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
