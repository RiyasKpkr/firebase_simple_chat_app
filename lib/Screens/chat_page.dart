// ignore_for_file: prefer_const_constructors

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({super.key});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  List<String> chat = [];

  TextEditingController messageController = TextEditingController();

  String? email;
  String? photoUrl;

  Future<String?> shared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString('email');
    photoUrl = preferences.getString('photoUrl');
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: shared(),
            builder: (context,snapshot) {
              return CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                foregroundImage: NetworkImage(photoUrl!),
                // radius: 25,
                // child: photoUrl==null?Image.network(photoUrl!):Icon(Icons.person),
                // child: Icon(Icons.person),
              );
            }
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: FutureBuilder(
          future: shared(),
          builder: ((context, snapshot) {
            return Text('${email}');
          }),
          // child: Text(email),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(
                Icons.logout,
              ),
              onTap: () {
                print('logout');
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
              },
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: shared(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('no email');
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    // height: double.infinity,
                    // child: Text(''),
                    ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('massage')
                          .snapshots(),
                      builder: (context, snapshot) {
                        //sorting
                        // if (snapshot.data != null) {
                        //   snapshot.data!.docs.sort(((a, b) =>
                        //       a.data()['Time'].compareTo(b.data()['Time'])));
                        // }
                        if (snapshot.data != null) {
                          var sec = snapshot.data!.docs;
                          sec.sort(((b, a) => DateTime.parse(a.data()['Time'])
                              .compareTo(DateTime.parse(b.data()['Time']))));

                          print('${snapshot.data!.docs}');
                          var temp = snapshot.data!.docs;
                          return ListView.separated(
                            reverse: true,
                            itemBuilder: (context, index) {
                              if (snapshot.hasData) {
                                var temp = snapshot.data!.docs;
                                String? user = sec[index].data()['username'];
                                return Row(
                                  mainAxisAlignment: user == email
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Bubble(
                                      // nip: BubbleNip.rightTop,
                                      nip: user == email
                                          ? BubbleNip.rightTop
                                          : BubbleNip.leftTop,
                                      color: Color.fromRGBO(225, 255, 199, 1.0),
                                      child: Text(
                                        '${sec[index].data()['massage']}'
                                            .toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          // color: Colors.black,
                                          fontSize: 20,
                                          // backgroundColor:
                                          // Color.fromARGB(255, 103, 101, 101),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Text('null');
                              }
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 5,
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          );
                        } else {
                          return Text('  ');
                        }
                      }),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.message,
                              color: Color.fromARGB(255, 98, 96, 96),
                            ),
                            filled: true,
                            fillColor: Colors.purple[100],
                            hintText: 'Message',
                            enabled: true,
                            contentPadding: EdgeInsets.only(
                              left: 14,
                              bottom: 8,
                              top: 8,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('massage')
                                      .add({
                                    'username': email,
                                    'massage': messageController.text,
                                    'Time': DateTime.now().toString(),
                                    // 'uid': user.uid,
                                  });
                                  chat.add(messageController.text);
                                  messageController.text = '';
                                });
                              },
                              child: Icon(
                                Icons.send,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
