import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PromoBase {
  final firestore = Firestore.instance;
  final uuid = Uuid().v1();

  Future addPromocode(
      String promocode, String uid, String uploder, double price) async {
    final promo = await firestore
        .collection("Promocode")
        .document(uuid)
        .setData({
      "Price": price,
      "Promocode": promocode,
      "uid": uid,
      "Uploder Name": uploder
    });
    return promo;
  }

  Future updatePromocode(
      String promocode, String uid, String uploder, double price) async {
    final promo = await firestore
        .collection("Promocode")
        .document(uuid)
        .updateData({
      "Price": price,
      "Promocode": promocode,
      "uid": uid,
      "Uploder Name": uploder
    });
    return promo;
  }

  Future deletePromocode(String documentID, String uid, String uploder) async {
    final deletepromo =
        await firestore.collection("Promocode").document(documentID).delete();
    return deletepromo;
  }
}
