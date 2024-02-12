import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: Home(),debugShowCheckedModeBanner: false,));
}

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<datas> l_name = [];
  TextEditingController List_Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    L_data();
  }

  L_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data_save = prefs.getStringList('To_do');
    if (data_save != null) {
        l_name = data_save.map((my_data) => datas(my_data, false)).toList();
        setState(() {});
    }
  }

  Save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = l_name.map((task) => task.title).toList();
    prefs.setStringList('To_do', taskStrings);
  }

  Add_data() {
    String titel_data = List_Controller.text.trim();
    if (titel_data != null) {
      l_name.add(datas(titel_data, false));
      setState(() {});
      Save();
      List_Controller.clear();
    }
  }
  Chekme(int index) {
      l_name[index].isdone = !l_name[index].isdone;
    setState(() {});
    Save();
  }
  Delete_data(int index) {
      l_name.removeAt(index);
    setState(() {});
    Save();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.check_box_sharp))
        ],
        title: Text('To Do List'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(margin: EdgeInsets.only(left: 20,right: 10,bottom: 10,top: 10),
                  child: TextField(
                    controller: List_Controller,
                    decoration: InputDecoration(
                      hintText: 'Enter Text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => (List_Controller.text == "")?null:Add_data(),
              ),
            ],
          ),
          Expanded(
            child: Container(margin: EdgeInsets.all(30),decoration: BoxDecoration(color: Colors.purpleAccent.shade100,borderRadius: BorderRadius.circular(30)),
              child: ListView.builder(
                itemCount: l_name.length,
                itemBuilder: (context, index) {
                  return ListTile(leading: Checkbox(
                      value: l_name[index].isdone,
                      onChanged: (value) => Chekme(index),
                    ),
                    title: Text(l_name[index].title),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => Delete_data(index),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class datas {
  String title;
  bool isdone;

  datas(this.title, this.isdone);
}
