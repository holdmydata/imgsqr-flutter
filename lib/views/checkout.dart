import 'package:flutter/material.dart';
import 'package:imgsqr/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/blockchain.dart';


class Checkout extends StatefulWidget {
  final String imgUrl;
  final String photographerId; 
  final String id;

  Checkout({@required this.id, this.imgUrl, this.photographerId});



  @override
  void initState(){
  
  }
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {


  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),),

      
      
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80.0,),
        Padding(padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), 
        child: Text("Artist ID: ${widget.photographerId}",
          style: TextStyle(fontSize: 30),),
          ),
        Padding(padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), 
        child: Text("Price: 10ETH",
          style: TextStyle(fontSize: 30),),
          ),
        Padding(padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), 
        child: Text("Your ID : ${widget.id}",
          style: TextStyle(fontSize: 30),),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), 
        child: Text("Picture ID : ${widget.hashCode}",
          style: TextStyle(fontSize: 30),),
          )
      ,SizedBox(height: 200.0),
      RaisedButton(
                color: Colors.blue[400],
                child: Text(
                  'Complete Purchase',
                  style: TextStyle(color: Colors.white),
                ), onPressed: (){},
              ),
      ],
      
      ),
      ),
          
      
    );
  }
}
