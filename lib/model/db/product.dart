import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellerapp/service/dbapi.dart';

import 'package:uuid/uuid.dart';

class ProductService {
  String ref = 'ProductListID';
  String appid = "CityGrow Product List";
 

  Firestore _firestore = Firestore.instance;
  void uploadProduct(Map<String, dynamic> data) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    final String name = user?.displayName;
    var id = Uuid();
    String productId = uid;
    String productIds = id.v1();
    data["PersonID"] = productId;
    _firestore
        .collection(ref)
        .document(appid)
        .collection(name)
        .document(productId)
        .collection("productsAdded")
        .document(productIds)
        .setData(data);
  }
}
