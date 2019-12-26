// import 'dart:collection';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:sellerapp/service/dbapi.dart';

// class DbNotifier with ChangeNotifier {
//   List<UserDetails> dataList  = [];
//   UserDetails currentData;

//   UnmodifiableListView<UserDetails> get userList =>
//       UnmodifiableListView(dataList);

//   UserDetails get currentUser => currentData;

//   set userList(List<UserDetails> userList) {
//     dataList = userList;
//     notifyListeners();
//   }

//   set currentFood(UserDetails data) {
//     currentData = data;
//     notifyListeners();
//   }

//   addFood(UserDetails data) {
//     dataList.insert(0, data);
//     notifyListeners();
//   }

//   // deleteFood(UserDetails data) {
//   //   dataList.removeWhere((_user) => _user.userName == data.userName);
//   //   notifyListeners();
//   // }
// }

// getDataDb(DbNotifier dbNotifier) async {
//   QuerySnapshot snapshot =
//       await Firestore.instance.collection('users').getDocuments();

//   List<UserDetails> userList = [];

//   snapshot.documents.forEach((document) {
//     // UserDetails userDetails = UserDetails.fromMap(document.data);
//     // userList.add(userDetails);
//   });

//   dbNotifier.userList = userList;
// }
