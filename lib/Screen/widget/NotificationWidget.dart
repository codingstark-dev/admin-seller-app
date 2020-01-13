// import 'dart:convert';

// import 'package:http/http.dart';
// import 'package:meta/meta.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:sellerapp/Screen/LoginOrSignUp/Login.dart';
// import 'package:sellerapp/Screen/LoginOrSignUp/Signup.dart';
// class MessagingWidget extends StatefulWidget {
//   @override
//   _MessagingWidgetState createState() => _MessagingWidgetState();
// }

// class _MessagingWidgetState extends State<MessagingWidget> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final TextEditingController titleController =
//       TextEditingController(text: 'Title');
//   final TextEditingController bodyController =
//       TextEditingController(text: 'Body123');
//   final List<Message> messages = [];

//   @override
//   void initState() {
//     super.initState();

//     _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
//     _firebaseMessaging.getToken();

//     _firebaseMessaging.subscribeToTopic('all');

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         final notification = message['notification'];
//         setState(() {
//           messages.add(Message(
//               title: notification['title'], body: notification['body']));
//         });

//         handleRouting(notification);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");

//         final notification = message['data'];
//         setState(() {
//           messages.add(Message(
//             title: '${notification['title']}',
//             body: '${notification['body']}',
//           ));
//         });

//         handleRouting(notification);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         final notification = message['data'];
//         handleRouting(notification);
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));
//   }

//   void handleRouting(dynamic notification) {
//     switch (notification['title']) {
//       case 'first':
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (BuildContext context) => Signup()));
//         break;
//       case 'second':
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => LoginScreen()));
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Material(
//       child: ListView(
//           children: [
//             TextFormField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             TextFormField(
//               controller: bodyController,
//               decoration: InputDecoration(labelText: 'Body'),
//             ),
//             RaisedButton(
//               onPressed: sendNotification,
//               child: Text('Send notification to all'),
//             ),
//           ]..addAll(messages.map(buildMessage).toList()),
//         ),
//   );

//   Widget buildMessage(Message message) => ListTile(
//         title: Text('Title: ${message.title}'),
//         subtitle: Text('Body: ${message.body}'),
//       );

//   Future sendNotification() async {
//     final response = await Messaging.sendToAll(
//       title: titleController.text,
//       body: bodyController.text,
//       // fcmToken: fcmToken,
//     );

//     if (response.statusCode != 200) {
//       Scaffold.of(context).showSnackBar(SnackBar(
//         content:
//             Text('[${response.statusCode}] Error message: ${response.body}'),
//       ));
//     }
//   }

//   void sendTokenToServer(String fcmToken) {
//     print('Token: $fcmToken');
//     // send key to your server to allow server to use
//     // this token to send push notifications
//   }
// }

// class Messaging {
//   static final Client client = Client();

//   // from 'https://console.firebase.google.com'
//   // --> project settings --> cloud messaging --> "Server key"
//   static const String serverKey =
//       'AAAA8tbPBA4:APA91bGCjwtEnTM9HQzjmQguzdPO4t020YEV3eKIoY35xxPhT6jzzjajSAP6Xa0mUhI0nIdIlB5A_5OXlrHLf8XfyCe_Mtseq6-6wbQLIhYuKYpdNYzY-74XHh0sCPNbGF9FtEKE4htP';

//   static Future<Response> sendToAll({
//     @required String title,
//     @required String body,
//   }) =>
//       sendToTopic(title: title, body: body, topic: 'all');

//   static Future<Response> sendToTopic(
//           {@required String title,
//           @required String body,
//           @required String topic}) =>
//       sendTo(title: title, body: body, fcmToken: '/topics/$topic');

//   static Future<Response> sendTo({
//     @required String title,
//     @required String body,
//     @required String fcmToken,
//   }) =>
//       client.post(
//         'https://fcm.googleapis.com/fcm/send',
//         body: json.encode({
//           'notification': {'body': '$body', 'title': '$title'},
//           'priority': 'high',
//           'data': {
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'id': '1',
//             'status': 'done',
//           },
//           'to': '$fcmToken',
//         }),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey',
//         },
//       );
// }

// @immutable
// class Message {
//   final String title;
//   final String body;

//   const Message({
//     @required this.title,
//     @required this.body,
//   });
// }
