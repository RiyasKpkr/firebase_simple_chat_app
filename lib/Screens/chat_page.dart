import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({super.key});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  List<String> chat = [];

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text('User Chat section'),
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
              },
            ),
          )
        ],
      ),
      body: Column(
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
                  if(snapshot.data!=null){
                     snapshot.data!.docs.sort(
                      ((a, b) =>DateTime.parse(a.data()['Time']).compareTo(DateTime.parse(b.data()['Time']))));
                  }

                  print('${snapshot.data!.docs}');
                  var temp = snapshot.data!.docs;
                  return ListView.separated(
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        var temp = snapshot.data!.docs;
                        String? user =
                            snapshot.data!.docs[index].data()['username'];
                        return Row(
                          mainAxisAlignment: user == 'riyas'
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Text(
                              '${temp[index].data()['massage']}'.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                backgroundColor:
                                    Color.fromARGB(255, 103, 101, 101),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('no data');
                      }
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
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
                              'username': 'riyas',
                              'massage': messageController.text,
                              'Time': DateTime.now().toString(),
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
      ),
    );
  }
}
