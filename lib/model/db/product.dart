import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uuid/uuid.dart';

class ProductService {
  String ref = 'ProductListID';
  String appid = "CityGrow Product List";

  Firestore _firestore = Firestore.instance;
  void uploadPromocode() {}
  void uploadProduct(Map<String, dynamic> data, String username,
      Map<String, dynamic> promo) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    // final String name = user?.displayName;
    var id = Uuid();

    String productId = uid;
    String productIds = id.v1();
    data["PersonID"] = productId;
    // ProductListsView(uid: uid, userName: username, name: name);
    _firestore.collection(ref).document(productIds).setData(data);
    _firestore
        .collection(ref)
        .document(productIds)
        .collection("promocode")
        .document(productIds)
        .setData(promo);
  }

  void updateProduct(Map<String, dynamic> data, String documentID,Map<String, dynamic> promo) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    // final String name = user?.displayName;
    // var id = Uuid();

    String productId = uid;
    // String productIds = id.v1();
    data["PersonID"] = productId;

    _firestore
        .collection(ref)
        .document(documentID)
        .updateData(data)
        .whenComplete(() {
      Fluttertoast.showToast(msg: 'Product Updated');
    });
     _firestore
        .collection(ref)
        .document(documentID)
        .collection("promocode")
        .document(documentID)
        .updateData(promo);
  }
}
