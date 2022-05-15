import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_task/editTask.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  const TaskList({required this.doc, required this.email});
  final List<DocumentSnapshot> doc;
  final String email;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doc.length,
      itemBuilder: (context, i) {
        String title = doc[i]["title"];
        String date = doc[i]["datetext"];
        String data = doc[i]["data"];
        return Dismissible(
          key: Key(doc[i].id),
          onDismissed: (direction) {
            FirebaseFirestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(doc[i].reference);
              await transaction.delete(snapshot.reference);
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "TASK DELTED",
                style: TextStyle(fontFamily: "Original-Factory", fontSize: 18),
              ),
              duration: Duration(milliseconds: 900),
            ));
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 2, color: Colors.red))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Icon(
                  Icons.title,
                  color: Color.fromARGB(255, 250, 155, 155),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontFamily: "Aesthetic-Notes",
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditTask(
                                email: email,
                                title: title,
                                date: doc[i]["datetext"],
                                tdata: data,
                                index: doc[i].reference,
                              )));
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.red,
                      size: 30,
                    ))
              ]),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Icon(Icons.calendar_today,
                    color: Color.fromARGB(255, 250, 155, 155)),
                SizedBox(
                  width: 10,
                ),
                Text(
                  date,
                  style: TextStyle(
                      fontFamily: "Aesthetic-Notes",
                      fontSize: 20,
                      color: Colors.white),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Text(
                data,
                style: TextStyle(
                    fontFamily: "Aesthetic-Notes",
                    fontSize: 20,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
        );
      },
    );
  }
}
