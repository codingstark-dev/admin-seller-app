
class UserDetails {
  final String referalId;
  final bool formDetaiVerify;
  final bool verificationWaiting;
  final String userName;
  final String uid;
  // final String points;
  UserDetails({
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
