import 'package:flutter/material.dart';
import 'package:imgsqr/services/auth.dart';
import 'package:imgsqr/views/home.dart';
import 'package:imgsqr/views/wrapper.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Img Squared',
//       theme: ThemeData(

//         primaryColor: Colors.white,
//       ),
//       home: Home(),
//     );
//   }
// }
  Widget build(BuildContext context) {
    // Listen to Services Stream for user login
    return StreamProvider<User>.value(
      value: AuthService().user,
          child: MaterialApp(
          home: Wrapper(),
   
      ),
    );}
}


