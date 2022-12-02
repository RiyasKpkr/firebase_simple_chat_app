// ignore_for_file: prefer_const_constructors

// import 'dart:html';

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebse_login/Screens/user_list_page.dart';
import 'package:firebse_login/Widgets/circleAvatharIcon.dart';
import 'package:firebse_login/Widgets/container.dart';
import 'package:firebse_login/Widgets/icon.dart';
import 'package:firebse_login/Widgets/text.dart';
import 'package:firebse_login/constants/constant.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

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
    //prifile iamge upload

    final storageRef = FirebaseStorage.instance.ref();
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final imagesRef = storageRef.child(imageName);
    if (imageFile != null) {
      try {
        await imagesRef.putFile(imageFile!);
        String downloadUrl = await imagesRef.getDownloadURL();

        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Constant.email = value.user!.email;
          Constant.photoURL = downloadUrl;
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
      } catch (e) {
        print(e.toString());
        String errors = e.toString();
        List<String> removeString = errors.split(' ');
        String error = removeString.sublist(1, removeString.length).join(' ');
        print(error);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 2000),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 3000),
          backgroundColor: Colors.red,
          content: Text('upload Profile Image'),
        ),
      );
    }
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

  //image picker

  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    if (sign) {
      return SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                          FocusScope.of(context).requestFocus(FocusNode());
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            content: Text(
                              'This Feature Currently Unavailable'.toString(),
                            ),
                          ),
                        );
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
        ),
      );
    } else {
      return SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                //profile image picker
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Please choose'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    log('camera');
                                    final XFile? image = await _imagePicker
                                        .pickImage(source: ImageSource.camera);
                                    Navigator.pop(context);
                                    if (image != null) {
                                      imageFile = File(image.path);
                                    }
                                  },
                                  child: Text('Camera'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    log('Gallery');
                                    final XFile? image = await _imagePicker
                                        .pickImage(source: ImageSource.gallery);
                                    Navigator.pop(context);
                                    if (image != null) {
                                      imageFile = File(image.path);
                                    }
                                  },
                                  child: Text('Gallery'),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple,
                    backgroundImage: imageFile == null
                        ? NetworkImage(
                                'https://static.vecteezy.com/system/resources/previews/000/366/953/original/edit-profile-vector-icon.jpg')
                            as ImageProvider
                        : FileImage(imageFile!),
                    // : FileImage(imageFile!) as ImageProvider,
                  ),
                ),
                SizedBox(
                  height: 30,
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
                          //uploade profile image

                          FocusScope.of(context).requestFocus(FocusNode());
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
                        FocusScope.of(context).requestFocus(FocusNode());
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
                        FocusScope.of(context).requestFocus(FocusNode());
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

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            content: Text(
                              'This Feature Currently Unavailable'.toString(),
                            ),
                          ),
                        );
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
        ),
      );
    }
  }
}

// void imagePicker() {
//   SnackBar snackbar = SnackBar(
//     backgroundColor: Colors.indigo[100],
//     duration: Duration(seconds: 6),
//     content: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () async {
//             final XFile? photo =
//                 await _imagePicker.pickImage(source: ImageSource.camera);
//             setState(
//               () {
//                 if (photo != null) {
//                   imageFile = File(photo.path);
//                 }
//               },
//             );
//           },
//           child: Text('camera'),
//           style: ButtonStyle(
//             backgroundColor: MaterialStatePropertyAll(Colors.indigo[900]),
//             foregroundColor: MaterialStatePropertyAll(Colors.white),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             final XFile? image =
//                 await _imagePicker.pickImage(source: ImageSource.gallery);
//             setState(() {
//               if (image != null) {
//                 imageFile = File(image.path);
//               }
//             });
//           },
//           child: Text('Gallery'),
//           style: ButtonStyle(
//             backgroundColor: MaterialStatePropertyAll(Colors.indigo[900]),
//             foregroundColor: MaterialStatePropertyAll(Colors.white),
//           ),
//         ),
//       ],
//     ),
//   );
// }
