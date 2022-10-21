import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/screens/add_task.dart';
import 'package:todoapp/screens/task_description.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = "";
  @override
  void initState() {
    super.initState();
    getuid();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo-App'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 190, 218, 231),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("tasks")
              .doc(uid)
              .collection("mytasks")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final docs = snapshot.data?.docs;

              return ListView.builder(
                  itemCount: docs?.length,
                  itemBuilder: (context, index) {
                    var time =
                        (docs?[index]['timeStamp'] as Timestamp).toDate();

                    return Dismissible(
                      onDismissed: ((direction) async => await FirebaseFirestore
                          .instance
                          .collection("tasks")
                          .doc(uid)
                          .collection("mytasks")
                          .doc(docs![index]["time"])
                          .delete()),
                      key: Key(docs![index].toString()),
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(docs[index]['title']),
                          subtitle:
                              Text(DateFormat.yMd().add_jm().format(time)),
                          trailing: IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("tasks")
                                    .doc(uid)
                                    .collection("mytasks")
                                    .doc(docs[index]["time"])
                                    .delete();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Description(
                                        title: docs[index]["title"],
                                        task: docs[index]["task"])));
                          },
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const AddTask())));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
