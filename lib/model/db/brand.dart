import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BrandService extends ChangeNotifier {
  String ref = 'brands';

  Firestore _firestore = Firestore.instance;

  void createBrand(String name, String uid) async {
    var id = Uuid();
    String brandId = id.v1();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    _firestore
        .collection("Sellers")
        .document(uid)
        .collection("Brand")
        .document(name)
        .setData({'brand': name, "id": uid});
  }

  Future<List<DocumentSnapshot>> getBrands() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return _firestore
        .collection("Sellers")
        .document(uid)
        .collection("Brand")
        .getDocuments()
        .then((snaps) {
      print(snaps.documents.length);
      notifyListeners();
      return snaps.documents;
    });
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => _firestore
          .collection(ref)
          .where('brand', isEqualTo: suggestion)
          .getDocuments()
          .then((snap) {
        return snap.documents;
      });
}
