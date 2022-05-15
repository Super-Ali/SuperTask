import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:super_task/task.dart';
import 'package:super_task/taskList.dart';
import 'googleprovider.dart';
import 'package:provider/provider.dart';
import 'package:super_task/main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  void accSignOut() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      content: SizedBox(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                user!.photoURL!,
              ),
              radius: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Really SignOut ?",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Aesthetic-Notes"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logOut();
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.check,
                          color: Color.fromARGB(255, 29, 219, 55)),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text("YES",
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 219, 55),
                                fontFamily: "Original-Factory")),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.close,
                          color: Color.fromARGB(255, 230, 31, 31)),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text("NO",
                            style: TextStyle(
                                color: Color.fromARGB(255, 230, 31, 31),
                                fontFamily: "Original-Factory")),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 68, 24, 24),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Task(email: user!.email!)));
          },
          child: const Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 158, 37, 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        elevation: 25.5,
        shape: CircularNotchedRectangle(),
        notchMargin: 2,
        color: Color.fromARGB(255, 143, 25, 16),
        child: ButtonBar(children: <Widget>[Text("")]),
      ),
      body: GestureDetector(
        onTap: (() {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        }),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(user!.photoURL!),
                                  fit: BoxFit.cover)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome",
                                  style: TextStyle(
                                      fontFamily: "Aesthetic-Notes",
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                Text(
                                  user!.displayName!,
                                  style: const TextStyle(
                                      fontFamily: "Aesthetic-Notes",
                                      color: Colors.white,
                                      fontSize: 24),
                                )
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () => accSignOut(),
                            icon: const Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                              size: 30,
                            ))
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
              padding: const EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 150),
              width: double.infinity,
              height: 610,
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/Cover.jpg",
                  ),
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 121, 14, 6), BlendMode.modulate),
                ),
              ),
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Task")
                        .where("email", isEqualTo: user!.email!)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return TaskList(
                        doc: snapshot.data!.docs,
                        email: user!.email!,
                      );
                    },
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








// appBar: AppBar(
//         title: Text(
//           user!.email!,
//           style: TextStyle(fontFamily: "Original-Factory", fontSize: 30),
//         ),
//         backgroundColor: Color.fromARGB(255, 46, 46, 46),
//         actions: [
//           Text(user.displayName!),
//           Image(image: NetworkImage(user.photoURL!)),
//           ElevatedButton(
//               onPressed: () {
//                 final provider =
//                     Provider.of<GoogleSignInProvider>(context, listen: false);
//                 provider.logOut();
//               },
//               child: Text("Logout"))
//         ],
//       ),