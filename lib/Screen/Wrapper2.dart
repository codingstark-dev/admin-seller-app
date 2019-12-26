// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sellerapp/Screen/Admin.dart';
// import 'package:sellerapp/Screen/formDetails.dart';
// import 'package:sellerapp/Screen/verification.dart';
// import 'package:sellerapp/model/user.dart';
// import 'package:sellerapp/service/dbapi.dart';
// import 'package:sellerapp/service/streamfiles.dart';
// import 'LoginOrSignUp/Signup.dart';

// class Wrapper2 extends StatefulWidget {
//   @override
//   _Wrapper2State createState() => _Wrapper2State();
// }

// class _Wrapper2State extends State<Wrapper2> {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);

//     final db = DatabaseService(uid: user?.uid);
//     // .forEach((doc) => doc.verificationDone);

//     //  ! return ethier Home or auth widget
//     if (user == null) {
//       return Signup();
//     } else {
//       return StreamBuilder<UserDetails>(
//           stream: db.documentSnapshot,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               if (snapshot.data.formDetaiVerify == true) {
//                if (snapshot.data.verificationWaiting == true) {
//                  return Admin();
//                }else{
//                  return VerificationDb();
//                }
//               } else {
//                 return FormDetails();
//               }
//             } else if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else{
//               return Container();
//             }
//           });
//     }
//   }
// }
