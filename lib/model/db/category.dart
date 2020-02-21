import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  String ref = 'categories';

  Firestore _firestore = Firestore.instance;

  void createCategory(String name, String id) async {
    // var id = Uuid();
    // String categoryId = id.v1();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    _firestore
        .collection("Sellers")
        .document(uid)
        .collection("Category")
        .document(name)
        .setData({'category': name, "id": id});
  }

  Future<List<DocumentSnapshot>> getCategories() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return _firestore
        .collection("Sellers")
        .document(uid)
        .collection("Category")
        .getDocuments()
        .then((snaps) {
      return snaps.documents;
    });
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => _firestore
          .collection("Sellers")
          .where('category', isEqualTo: suggestion)
          .getDocuments()
          .then((snap) {
        return snap.documents;
      });
}
