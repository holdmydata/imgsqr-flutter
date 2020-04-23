class User {

  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String age;
  final String status;



  User({ this.uid, this.displayName, this.email, this.phoneNumber, this.age, this.status });
}

class UserData {
  
  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String age;
  final String status;
  final String providerId;
  final String photoUrl;
  UserData({this.uid, this.displayName, this.email, this.phoneNumber, this.age, this.status, this.providerId, this.photoUrl});
}