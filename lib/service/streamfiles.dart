import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:sellerapp/service/dbapi.dart';
import 'dart:async';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final String uid;
  final String userName;
  final String name;

  DatabaseService({
    @required this.uid,
    this.name,
    this.userName,
  });

  /// Get a stream of a single document
  // Stream<SuperHero> streamHero(String id) {
  //   return _db
  //       .collection('heroes')
  //       .document(id)
  //       .snapshots()
  //       .map((snap) => SuperHero.fromMap(snap.data));
  // }

  /// Query a subcollection
  // Stream<List<UserDetails>> streamWeapons() {
  //   var ref = _db.collection('Sellers');
  //   return ref.snapshots().map((list) =>
  //       list.documents.map((doc) => UserDetails.fromFirestore(doc)).toList());
  // }

  UserDetails collectionDataOfDb(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    return UserDetails(
        uid: uid,
        userName: data["name"] ?? "",
        referalId: data["refercode"] ?? "",
        verificationWaiting: data["Verification"] ?? false,
        rewards: data["Reward"] ?? "",
        formDetaiVerify: data["formstatus"] ?? false);
  }

  // stream of data
  Stream<UserDetails> get documentSnapshot {
    return _db
        .collection("Sellers")
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  UserDetails _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return collectionDataOfDb(snapshot);
  }

//! different 1
  // stream of data
  Stream<List<UserData>> get dataSnapshotss {
    return _db.collection("ProductListID").snapshots().map(datarefer);
  }

// list data

  List<UserData> datarefer(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserData(
          userName: doc.data["name"] ?? "",
          referalId: doc.data["usedReferCode"] ?? "",
          verification: doc.data["Verfication"] ?? "");
    }).toList();
  }

  //! different 2
  ProductListsView productcollection(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    return ProductListsView(
        userName: data["UploaderName"] ?? "",
        uid: uid,
        price: data["price"] ?? "",
        brand: data["brand"] ?? "",
        category: data["category"] ?? "",
        images: data["images"] ?? "",
        sizes: data["sizes"] ?? "",
        quantity: data["quantity"] ?? "");
  }

  // stream of data
  Stream<ProductListsView> get productSnapshot {
    return _db
        .collection("ProductListID")
        .document(uid)
        .collection(uid)
        .where("PersonID", isEqualTo: uid)
        .snapshots()
        .map(_productDataFromSnapshot);
  }

  ProductListsView _productDataFromSnapshot(snapshot) {
    return productcollection(snapshot);
  }

//  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//     return UserData(
//         userName: snapshot.data['name'] ?? "",
//         referalId: snapshot.data['usedReferCode'] ?? "",
//         verification: snapshot.data['Verfication'] ?? "");
//   }
  // // get user doc stream
  // Stream<UserData> get userData {
  //   return _db.document().snapshots().map(_userDataFromSnapshot);
  // }
  // Future<Stream> get getDataSingleStream async {
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   var ref = _db.collection('Sellers').document(user.uid).get();
  //   return await ref.then((val) => val.data["Verfication"]);
  // }

  // Stream createHero(FirebaseUser user) {
  //   // final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   var lolh =
  //       Firestore.instance.collection('Sellers').document(user.uid).snapshots();
  //   lolh.listen((DocumentSnapshot ds) {
  //     return ds.data["Verification"];
  //   });
  // }

  Future<void> addDataToDb(dynamic sellerDetails) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return _db
        .collection('Sellers')
        .document(user.uid)
        .updateData(sellerDetails);
  }

  Future<void> removeWeapon(FirebaseUser user, String id) {
    return _db
        .collection('heroes')
        .document(user.uid)
        .collection('weapons')
        .document(id)
        .delete();
  }
}
