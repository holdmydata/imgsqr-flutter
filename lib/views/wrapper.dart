import 'package:flutter/material.dart';
import 'package:imgsqr/model/user.dart';
import 'package:imgsqr/views/authenticate/authenticate.dart';
import 'package:imgsqr/views/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    print(user);
    
    //return either Home or Authenticate Widget
   if ( user == null) {
     return Authenticate();
   } else {
     return Home();
   }
      
    
  }
}