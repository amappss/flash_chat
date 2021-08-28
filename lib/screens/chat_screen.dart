import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const id = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final fireStore = Firestore.instance;
  final fireBaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;

  String text;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    _user = await fireBaseAuth.currentUser();
  }

  void getMessages() async {
    var collections = await fireStore.collection('messages').getDocuments();
    for (var message in collections.documents) {
      print(message.data);
    }
  }

  void getMessagesStream() async {
    await for (var snapshot in fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getMessagesStream();
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: fireStore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(
                    backgroundColor: Colors.lightBlue,
                  );
                }
                List<MsgBubble> messagesList = [];
                for (var message in snapshot.data.documents.reversed) {
                  String sender = message.data['sender'];
                  String text = message.data['text'];
                  // print(sender);
                  final textBubble = MsgBubble(
                    sender: sender,
                    text: text,
                    isMe: sender == _user.email,
                  );
                  messagesList.add(textBubble);
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.all(10),
                    children: messagesList,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        text = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.

                      messageTextController.clear();
                      fireStore
                          .collection('messages')
                          .add({'sender': _user.email, 'text': text});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MsgBubble extends StatelessWidget {
  final text;
  final sender;
  final bool isMe;
  MsgBubble({@required this.text, @required this.sender, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sender,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(20) : Radius.circular(0),
                  topRight: isMe ? Radius.circular(0) : Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: isMe ? Colors.lightBlue : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  text,
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black54,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ));
  }
}
