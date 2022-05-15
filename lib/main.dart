import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:super_task/googleprovider.dart';
import 'package:super_task/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const SuperTask());
}

class SuperTask extends StatelessWidget {
  const SuperTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => GoogleSignInProvider()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomePage();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Something Went Wrong"),
          );
        } else {
          return SignUp();
        }
      },
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  @override
  Widget build(BuildContext context) {
    // GoogleSignInAccount? user = _googleSignIn.currentUser;
    return Scaffold(
        backgroundColor: HexColor('#0b0b0b'),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/super task background.jpg",
                  ),
                  fit: BoxFit.contain)),
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 50),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googlelogin();
              },
              child: const Image(
                image: AssetImage("assets/images/Signin button.png"),
                width: 250,
              ),
            ),
          ),
        ));
  }
}
