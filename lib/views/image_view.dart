import 'package:flutter/material.dart';
import 'package:imgsqr/views/checkout.dart';

class ImageView extends StatefulWidget {
  final String id;
  final String imgUrl;
  final String photographerId; 

  ImageView({@required this.id, this.imgUrl, this.photographerId});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Hero(
          tag: widget.imgUrl,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              )),
        ),
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //Box for Clicking
                //Background of gradiant blackened for bright pictures
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Checkout(imgUrl: widget.imgUrl, id: widget.id, photographerId: widget.photographerId,)));
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white60, width: 1),
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xff1c1B1B).withOpacity(0.8))),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white60, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF)
                            ])),
                        child: Column(
                          children: <Widget>[
                            Text("Purchase",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70)),
                            Text("Will be Saved to Cart",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            )),
      ],
    ));
  }
}
