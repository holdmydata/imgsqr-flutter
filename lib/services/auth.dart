import 'package:firebase_auth/firebase_auth.dart';
import 'package:imgsqr/model/user.dart';
import 'package:imgsqr/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //authentication change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user)=> _userFromFirebaseUser(user));
  }

  // Sign In Anon IF NEEDED
Future signInAnon() async {
  try {
   AuthResult result =  await _auth.signInAnonymously();
   FirebaseUser user = result.user;
   return _userFromFirebaseUser(user);
  } catch(e) {
    print(e.toString());
    return null;
  }
}
  //Sign In with Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
     try {
      AuthResult result  = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  
  }
  //Register with Email and Password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result  = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;


      //Create document in Firebase Cloud Firestore
      await DatabaseService(uid: user.uid).updateUserData("", email, "", "", "Email","");
      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  }
  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}