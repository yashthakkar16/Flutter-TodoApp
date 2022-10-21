import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titlecontrollr = TextEditingController();
  TextEditingController taskcontrollr = TextEditingController();

  //------------------------------------------------------
  //Adding task to firebase collection User Wise

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(uid)
        .collection("mytasks")
        .doc(time.toString())
        .set({
      "title": titlecontrollr.text,
      "task": taskcontrollr.text,
      "time": time.toString(),
      "timeStamp": time
    });
    Fluttertoast.showToast(msg: "Todo Added!!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: const Color.fromARGB(255, 190, 218, 231),
        child: Column(
          children: [
            TextField(
              controller: titlecontrollr,
              decoration: InputDecoration(
                  labelText: "Enter Title",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: taskcontrollr,
              decoration: InputDecoration(
                  labelText: "Enter Task",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                addtasktofirebase();
                Navigator.of(context).pop();
              },
              child: const Text("Add Task"),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(255, 7, 78, 137);
                    } //<-- SEE HERE
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
