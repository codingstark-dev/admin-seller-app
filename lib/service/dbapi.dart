class UserDetails {
  final String referalId;
  final bool formDetaiVerify;
  final bool verificationWaiting;
  final String userName;
  final String uid;
  final int rewards;
  final bool bankDetailBool;
  // final String points;
  UserDetails({
    this.rewards,
    this.bankDetailBool,
    this.uid,
    this.verificationWaiting,
    this.formDetaiVerify,
    this.referalId,
    this.userName,
    // this.points,
  });

  // factory UserDetails.fromFirestore(DocumentSnapshot doc) {
  //   Map data = doc.data;
  //   return UserDetails(

  //       // referalId: data["id"] ?? "987",
  //       // points: data['points'] ?? '',
  //       // userName: data['name'] ?? 0,
  //       verification: data["Verification"] ?? true);
  // }
}

class UserData {
  final String referalId;
  final bool verification;
  final String userName;

  // final String points;
  UserData({
    this.verification,
    this.referalId,
    this.userName,
    // this.points,
  });
}

class ProductListsView {
  final String uid;
  final String price;
  final String brand;
  final String category;
  final String images;
  final String quantity;
  final String sizes;
  final String userName;
  final String name;
  final String documentID;

  ProductListsView(
      {this.price,
      this.documentID,
      this.name,
      this.uid,
      this.userName,
      this.brand,
      this.category,
      this.images,
      this.quantity,
      this.sizes});
}
