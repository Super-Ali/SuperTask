import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Task extends StatefulWidget {
  const Task({this.email});

  final email;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  DateTime duedate = DateTime.now();
  String datetext = '';
  String tasktitle = '';
  String taskdata = '';

  final user = FirebaseAuth.instance.currentUser;
  Future selectduedate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: duedate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
        builder: (BuildContext context, childr) => Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      surface: Color.fromARGB(255, 112, 1, 1),
                      primary: Colors.red,
                      onPrimary: Colors.black,
                      onSurface: Color.fromARGB(255, 250, 9, 9)),
                  dialogBackgroundColor: const Color.fromARGB(255, 15, 15, 15)),
              child: childr!,
            ));

    if (picked != null) {
      setState(() {
        duedate = picked;
        datetext = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void addData() {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          FirebaseFirestore.instance.collection("Task");
      await reference.add({
        "email": user!.email,
        "title": tasktitle,
        "duedate": duedate,
        "datetext": datetext,
        "data": taskdata
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    datetext = "${duedate.day}/${duedate.month}/${duedate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        },
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 170,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Nave Bar.jpg"),
                    fit: BoxFit.cover),
                boxShadow: [BoxShadow(color: Colors.red, blurRadius: 8)],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 10, right: 10, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.immersiveSticky);
                            },
                            icon: const Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                              size: 30,
                            )),
                        const SizedBox(
                          width: 50,
                        ),
                        const Text(
                          "+ Add Your Super Task",
                          style: TextStyle(
                              fontFamily: "Aesthetic-Notes",
                              color: Colors.white,
                              fontSize: 25),
                        )
                      ],
                    ),
                    const Text("Super Tasks",
                        style: TextStyle(
                            fontFamily: "Original-Factory",
                            color: Colors.white,
                            fontSize: 30))
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: 10, top: 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/addtask.jpg"),
                fit: BoxFit.fitHeight,
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) => setState(() {
                      tasktitle = value;
                    }),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.subtitles,
                        color: Colors.red,
                      ),
                      hintText: "Title of Super Task",
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 236, 66, 53),
                          fontFamily: "Aesthetic-Notes"),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                        fontSize: 30,
                        fontFamily: "Aesthetic-Notes",
                        color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, right: 15, left: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Text(
                            "Due Date",
                            style: TextStyle(
                                color: Color.fromARGB(255, 236, 66, 53),
                                fontFamily: "Aesthetic-Notes",
                                fontSize: 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () => selectduedate(context),
                          child: Text(
                            datetext,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 236, 66, 53),
                                fontFamily: "Aesthetic-Notes",
                                fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 310,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.red)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) => setState(() {
                              taskdata = value;
                            }),
                            decoration: const InputDecoration(
                              hintText: "Your Super Task Here",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 236, 66, 53),
                                  fontFamily: "Aesthetic-Notes"),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                                fontSize: 25,
                                fontFamily: "Aesthetic-Notes",
                                color: Colors.white),
                          ),
                        ),
                        Icon(
                          Icons.list,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      addData();
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersiveSticky);
                    },
                    icon: const Icon(
                      Icons.check_circle,
                      size: 65,
                    ),
                    color: Colors.red,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
