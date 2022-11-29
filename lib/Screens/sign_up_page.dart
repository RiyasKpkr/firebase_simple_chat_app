// ignore_for_file: prefer_const_constructors

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebse_login/Screens/user_list_page.dart';
import 'package:firebse_login/Widgets/circleAvatharIcon.dart';
import 'package:firebse_login/Widgets/container.dart';
import 'package:firebse_login/Widgets/icon.dart';
import 'package:firebse_login/Widgets/text.dart';
import 'package:firebse_login/constants/constant.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool sign = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNamecontroller = TextEditingController();

  signFunction({required email, required password}) async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Constant.email = value.user!.email;
      Constant.photoURL =
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.pngitem.com%2Fpimgs%2Fm%2F78-786293_1240-x-1240-0-avatar-profile-icon-png.png&f=1&nofb=1&ipt=68be7f187c7dda5acf6dc98313833971b645a4921c3c0c26d4c6660d19d93773&ipo=images';
      Constant.uid = value.user!.uid;
      Constant.username = userNamecontroller.text;

      FirebaseFirestore.instance.collection('UsersData').add({
        'Username': Constant.username,
        'email': Constant.email,
        'uid': Constant.uid,
        'PhotoUrl': Constant.photoURL,
      });
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return UserListPage();
        },
      ));
      return value;
    });

    user.user!.uid;
  }

  loginFunction({required email, required password}) async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          Constant.email = value.user!.email;
          Constant.uid = value.user!.uid;
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return UserListPage();
        },
      ));
      return value;
    });

    user.user!.uid;
  }

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Constant.email = googleUser?.email;
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential).then(
      (value) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UserListPage();
            },
          ),
        );
        return value;
      },
    );

    Constant.email = userCredential.user!.email;
    Constant.photoURL = userCredential.user!.photoURL;
    Constant.uid = userCredential.user!.uid;
    Constant.username = userCredential.user!.displayName;

    var firebaseCollection =
        await FirebaseFirestore.instance.collection('UsersData').get();
    var usersList = firebaseCollection.docs;
    print(usersList);
    bool newUser = true;
    for (int i = 0; i < usersList.length; i++) {
      print(usersList[i]['email']);
      if (Constant.email == usersList[i]['email']) {
        newUser = false;
      }
    }
    if (newUser == true) {
      FirebaseFirestore.instance.collection('UsersData').add({
        'email': Constant.email,
        'PhotoUrl': Constant.photoURL,
        'uid': Constant.uid,
        'Username': Constant.username,
      });
    }
    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    if (sign) {
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconWidget(
                icons: Icons.android,
                iconSize: 90,
                iconColor: Colors.purple,
              ),
              // SizedBox(
              //   height: 50,
              // ),
              //title
              textWidget(
                textdata: 'welcome back again.!'.toUpperCase(),
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 5,
              ),
              textWidget(
                textdata: 'Connect and share with the people in your life.',
                fontSize: 14,
                // fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: 27,
              ),

              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ContainerWidget(
                  passwordController: emailController,
                  containerColor: Color.fromARGB(255, 245, 242, 242),
                  containerBorder: Border.all(color: Colors.white),
                  containerRadius: BorderRadius.circular(12),
                  inputBorder: InputBorder.none,
                  hintText: 'Email',
                  icon: Icons.email,
                  iconColor: Colors.grey,
                  obscureText: false,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ContainerWidget(
                  passwordController: passwordController,
                  containerBorder: Border.all(color: Colors.white),
                  containerRadius: BorderRadius.circular(12),
                  inputBorder: InputBorder.none,
                  hintText: 'Password',
                  icon: Icons.lock,
                  iconColor: Colors.grey,
                  obscureText: true,
                  containerColor: Color.fromARGB(255, 245, 242, 242),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        loginFunction(
                            email: emailController.text,
                            password: passwordController.text);
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),

              //signup page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sign = !sign;
                      setState(() {});
                    },
                    child: Text(
                      '  Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      signInWithGoogle();
                      print('!!!!!!!!!!!!!!!!!');

                      // final pref = await SharedPreferences.getInstance();
                      // pref.setString('email', userCredential.user!.email!);
                    },
                    child: CircleImage(
                      assetImage: 'assets/logo/google.png',
                      backgroundColor: Color.fromARGB(255, 184, 181, 181),
                      circleRadius: 25,
                      imageHeight: 35,
                      imageScale: 2.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // signInWithFacebook();
                    },
                    child: CircleImage(
                      backgroundColor: Color.fromARGB(255, 184, 181, 181),
                      circleRadius: 25,
                      assetImage: 'assets/logo/facebook.png',
                      imageHeight: 35,
                      imageScale: 2.5,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconWidget(
                iconColor: Colors.purple,
                iconSize: 90,
                icons: Icons.android,
              ),
              //title
              textWidget(
                textdata: 'Hello..!'.toUpperCase(),
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 5,
              ),
              textWidget(
                textdata: 'It\'s quick and easy.',
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
              // Text(widget.uNmae),
              SizedBox(
                height: 27,
              ),
              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ContainerWidget(
                  obscureText: false,
                  passwordController: userNamecontroller,
                  containerColor: Color.fromARGB(255, 245, 242, 242),
                  containerBorder: Border.all(color: Colors.white),
                  containerRadius: BorderRadius.circular(12),
                  inputBorder: InputBorder.none,
                  hintText: 'User name',
                  icon: Icons.person,
                  iconColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //userName
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ContainerWidget(
                  obscureText: false,
                  passwordController: emailController,
                  containerColor: Color.fromARGB(255, 245, 242, 242),
                  containerBorder: Border.all(color: Colors.white),
                  containerRadius: BorderRadius.circular(12),
                  inputBorder: InputBorder.none,
                  hintText: 'Email',
                  icon: Icons.email,
                  iconColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ContainerWidget(
                  obscureText: true,
                  passwordController: passwordController,
                  containerColor: Color.fromARGB(255, 245, 242, 242),
                  containerBorder: Border.all(color: Colors.white),
                  containerRadius: BorderRadius.circular(12),
                  inputBorder: InputBorder.none,
                  hintText: 'Password',
                  icon: Icons.lock,
                  iconColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        signFunction(
                            email: emailController.text,
                            password: passwordController.text);
                      },
                      child: textWidget(
                        textdata: 'Sign Up',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),

              //signup page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                    textdata: 'Already A Member.',
                    fontWeight: FontWeight.bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      sign = !sign;
                      setState(() {});
                    },
                    child: textWidget(
                      textdata: ' Login Now',
                      fontColor: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: CircleImage(
                      assetImage: 'assets/logo/google.png',
                      backgroundColor: Color.fromARGB(255, 184, 181, 181),
                      circleRadius: 25,
                      imageHeight: 35,
                      imageScale: 2.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // signInWithFacebook();
                    },
                    child: CircleImage(
                      backgroundColor: Color.fromARGB(255, 184, 181, 181),
                      circleRadius: 25,
                      assetImage: 'assets/logo/facebook.png',
                      imageHeight: 35,
                      imageScale: 2.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
