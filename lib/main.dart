import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebse_login/Screens/chat_page.dart';
// import 'package:firebse_login/Screens/sign_up_page.dart';
import 'package:firebse_login/Screens/user_list_page.dart';
import 'package:firebse_login/constants/constant.dart';
// import 'package:firebse_login/Screens/sign_up_page.dart';
import 'package:firebse_login/home_page.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:  StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            print(snapshot.data!.photoURL);
            Constant.photoURL = snapshot.data!.photoURL;
            Constant.email = snapshot.data!.email;
            Constant.uid = snapshot.data!.uid;
            Constant.username = snapshot.data!.displayName;
            return UserListPage();
          }else{
          return HomePage();
          }
        }
      ),
    );
  }
}

