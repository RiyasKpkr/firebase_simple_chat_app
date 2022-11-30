// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebse_login/Screens/chat_page.dart';
import 'package:firebse_login/constants/constant.dart';
import 'package:firebse_login/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FutureBuilder(
              future: function(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error');
                } else {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    foregroundImage:
                        NetworkImage(Constant.photoURL ?? 'no Image'),
                  );
                }
              },
            ),
          ),
          backgroundColor: Colors.green,
          title: FutureBuilder(
            future: function(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error');
              } else {
                return Text(Constant.username ?? 'NO name');
              }
            },
          ),
          actions: [
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Constant.email = null;
                  Constant.photoURL = null;
                  Constant.uid = null;
                  Constant.username = null;
                });
                GoogleSignIn().signOut().then(
                      (value) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const HomePage();
                          },
                        ),
                      ),
                    );
              },
              child: const Icon(Icons.logout),
            ),
          ],
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('UsersData').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              var userList = snapshot.data!.docs;
              userList.forEach((e) {
                // print(e.data()['Username']);
                print(e.data()['PhotoUrl']);
                // print(e.data()['uid']);
              });
              print(
                '>>>>>>>>>>$userList',
              );
              return ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  if (Constant.uid != userList[index]['uid']) {
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserChatPage(
                            PhotoUrl: userList[index]['PhotoUrl'],
                            UserName: userList[index]['Username'],
                            oppositeUser: userList[index],
                          ),
                        ),
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            userList[index]['Username'],
                          ),
                          leading: CircleAvatar(
                            foregroundImage: NetworkImage(
                              userList[index]['PhotoUrl'],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  function() async {
    var FireBaseData =
        await FirebaseFirestore.instance.collection('UsersData').get();
    List user = FireBaseData.docs;
    for (int i = 0; i < user.length; i++) {
      if (user[i]['email'] == Constant.email) {
        Constant.username = user[i]['Username'];
        Constant.photoURL = user[i]['PhotoUrl'];
      }
    }
    // print('>>>>>>>>>>>>>>>>${user}');
    return user;
  }
}
