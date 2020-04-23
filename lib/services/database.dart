import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:imgsqr/model/user.dart';
import 'package:imgsqr/model/image.dart'; 

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Collection Reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference photoCollection =
      Firestore.instance.collection('uploads');

  Future updateUserData(String displayName, String email, String phoneNumber,
      String profileUrl, String providerId, String status) async {
    return await userCollection.document(uid).setData({
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileUrl': profileUrl,
      'providerId': providerId,
      'userStatus': status,
    });
  }

// Get list of users from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(
          displayName: doc.data['displayName'] ?? '',
          email: doc.data['email'] ?? '',
          phoneNumber: doc.data['phoneNumber'] ?? '');
    }).toList();
  }

// userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      displayName: snapshot.data['displayName'],
      email: snapshot.data['email'],
      phoneNumber: snapshot.data['phoneNumber'],
      age: snapshot.data['age'],
      status: snapshot.data['status'],
    );
  }

  //Get user stream
  Stream<List<User>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

//get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

// *** PHOTO WORK ***

// Get list of photos from snapshot
  List<Photo> _photoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Photo(
          imgName: doc.data['imgName'] ?? '',
        createdOn: doc.data['createdOn'],
        imgCategory: doc.data['imgCategory'],
        imgDescription: doc.data['imgDescription'],
        imgPrice: doc.data['imgPrice'],
        key: doc.data['key'],
        name: doc.data['name'],
        url: doc.data['url'],
        ownerID: doc.data['ownerID'],
    );}).toList();
  }

// photoData from snapshot
  PhotoData _photoDataFromSnapshot(DocumentSnapshot snapshot) {
    var photoData = PhotoData(
        createdOn: snapshot.data['createdOn'],
        imgCategory: snapshot.data['imgCategory'],
        imgDescription: snapshot.data['imgDescription'],
        imgName: snapshot.data['imgName'],
        imgPrice: snapshot.data['imgPrice'],
        key: snapshot.data['key'],
        name: snapshot.data['name'],
        url: snapshot.data['url'],
        ownerID: snapshot.data['ownerID'],
    );
    return photoData;
  }


    //Get photo stream
  Stream<List<Photo>> get photos {
    return photoCollection.snapshots().map(_photoListFromSnapshot);
  }

//get photo doc stream
  Stream<PhotoData> get photoData {
    return photoCollection.document(uid).snapshots().map(_photoDataFromSnapshot);
  }

}
