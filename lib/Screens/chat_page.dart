// ignore_for_file: prefer_const_constructors

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebse_login/constants/constant.dart';
import 'package:flutter/material.dart';
// import 'dart:convert';

class UserChatPage extends StatefulWidget {
  UserChatPage({
    super.key,
    required this.UserName,
    required this.PhotoUrl,
    required this.oppositeUser,
  });

  String UserName;
  String PhotoUrl;
  var oppositeUser;

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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            foregroundImage: NetworkImage(widget.PhotoUrl), //comment
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(widget.UserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Message')
                  .doc('${Constant.uid}')
                  .collection('${widget.oppositeUser['uid']}')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  var userChat = snapshot.data!.docs;
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Message')
                        .doc('${widget.oppositeUser['uid']}')
                        .collection('${Constant.uid}')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var oppositeUserChat = snapshot.data!.docs;
                        List chatList = new List.from(userChat)
                          ..addAll(oppositeUserChat);
                        chatList.sort(
                          (b, a) {
                            var _first = DateTime.parse(a.data()['Time']);
                            var _second = DateTime.parse(b.data()['Time']);
                            return _first.compareTo(_second);
                          },
                        );
                        return ListView.separated(
                          reverse: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: chatList.length,
                          itemBuilder: (context, index) {
                            String? user = Constant.uid;
                            print('>>>>>>>>>>>>${user}>>>>>>>>');
                            print(
                                '>>>>>>>>>>>${widget.oppositeUser['uid']}>>>>>>>>');
                            return Bubble(
                              color: Colors.amber,
                              margin: BubbleEdges.only(left: 5),
                              alignment: user == chatList[index]['uid']
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              nip: user == chatList[index]['uid']
                                  ? BubbleNip.rightTop
                                  : BubbleNip.leftTop,
                              child: Text(
                                '${chatList[index].data()['message']}',
                                // .toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  backgroundColor: Colors.amber,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Text('');
                      }
                    },
                  );
                }
              },
            ),
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
                          FirebaseFirestore.instance
                              .collection('Message')
                              .doc('${Constant.uid}')
                              .collection('${widget.oppositeUser['uid']}')
                              .add({
                            'email': Constant.email,
                            'uid': Constant.uid,
                            'message': messageController.text,
                            'Time': DateTime.now().toString(),
                            // 'uid': user.uid,
                          });
                          setState(() {
                            chat.add(messageController.text);
                            messageController.text = '';
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.grey,
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



// body: StreamBuilder(
      // stream: FirebaseFirestore.instance
      //     .collection('Message')
      //     .doc('${Constant.uid}')
      //     .collection('${widget.oppositeUser['uid']}')
      //     .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(
      //           color: Colors.red,
      //           backgroundColor: Colors.green,
      //         ),
      //       );
      //     } else if (snapshot.hasError) {
      //       return Text(snapshot.error.toString());
      //     } else {
      //       var userChat = snapshot.data!.docs;
      //       return Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           Container(
      //               // height: double.infinity, //comment
      //               // child: Text(''),    //comment
      //               ),
      //           Expanded(
      //             child: StreamBuilder(
      // stream: FirebaseFirestore.instance
      //     .collection('Message')
      //     .doc('${widget.oppositeUser['uid']}')
      //     .collection('${Constant.uid}')
      //     .snapshots(),
      //                 builder: (context, snapshot) {
      //                   if (snapshot.hasData) {
      //                     var oppositeUserChat = snapshot.data!.docs;
      //                     List chatList = new List.from(userChat)
      //                       ..addAll(oppositeUserChat);
      //                     chatList.sort(
      //                       (a, b) {
      //                         var _first = DateTime.parse(a.data()['time']);
      //                         var _second = DateTime.parse(b.data()['time']);
      //                         return _first.compareTo(_second);
      //                       },
      //                     );
      //                     return ListView.separated(
      //                       itemCount: chatList.length,
      //                       separatorBuilder: (context, index) {
      //                         return SizedBox(
      //                           height: 5,
      //                         );
      //                       },
      //                       reverse: true,
      //                       itemBuilder: (context, index) {
      //                         String? user = Constant.uid;
      //                         print('${user} >>>>>>>>>>>>>>>>>> user');
      //                         print(
      //                             '${widget.oppositeUser['uid']}>>>>>>>>>>>>>Opposite User');
      //                         if (snapshot.hasData) {
      //                           String? user =
      //                               oppositeUserChat[index].data()['username'];
      //                           return Row(
      //                             mainAxisAlignment:
      //                                 chatList[index].data()['uid']
      //                                     ? MainAxisAlignment.end
      //                                     : MainAxisAlignment.start,
      //                             children: [
      //                               Bubble(
      //                                 // nip: BubbleNip.rightTop,    //comment
      //                                 nip: user == chatList[index].data()['uid']
      //                                     ? BubbleNip.rightTop
      //                                     : BubbleNip.leftTop,
      //                                 color: Color.fromRGBO(225, 255, 199, 1.0),
      //                                 child: Text(
      //                                   '${chatList[index].data()['Message']}'
      //                                       .toString(),
      //                                   textAlign: TextAlign.right,
      //                                   style: TextStyle(
      //                                     // color: Colors.black,    //comment
      //                                     fontSize: 20,
      //                                     // backgroundColor:          //comment
      //                                     // Color.fromARGB(255, 103, 101, 101),   //comment
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           );
      //                         }
      //                       },
      //                     );
      //                   } else {
      //                     return Text('  ');
      //                   }
      //                 }),
      //           ),
      //               Row(
      //                 children: [
      //                   Expanded(
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(10),
      //                       child: TextField(
      //                         controller: messageController,
      //                         decoration: InputDecoration(
      //                           prefixIcon: Icon(
      //                             Icons.message,
      //                             color: Color.fromARGB(255, 98, 96, 96),
      //                           ),
      //                           filled: true,
      //                           fillColor: Colors.purple[100],
      //                           hintText: 'Message',
      //                           enabled: true,
      //                           contentPadding: EdgeInsets.only(
      //                             left: 14,
      //                             bottom: 8,
      //                             top: 8,
      //                           ),
      //                           focusedBorder: OutlineInputBorder(
      //                             borderSide: BorderSide(color: Colors.purple),
      //                             borderRadius: BorderRadius.circular(10),
      //                           ),
      //                           enabledBorder: UnderlineInputBorder(
      //                             borderSide: BorderSide(color: Colors.purple),
      //                             borderRadius: BorderRadius.circular(10),
      //                           ),
      //                           suffixIcon: GestureDetector(
      //                             onTap: () {
      //                               FirebaseFirestore.instance
      //                                   .collection('Message')
      //                                   .doc('${Constant.uid}')
      //                                   .collection('${widget.oppositeUser['uid']}')
      //                                   .add({
      //                                 'email': Constant.email,
      //                                 'uid': Constant.uid,
      //                                 'message': messageController.text,
      //                                 'Time': DateTime.now().toString(),
      //                                 // 'uid': user.uid,
      //                               });
      //                               setState(() {
      //                                 chat.add(messageController.text);
      //                                 messageController.text = '';
      //                               });
      //                             },
      //                             child: Icon(
      //                               Icons.send,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      // };
      //     //       );
      //     //     }
      //     //   },
      //     // ),