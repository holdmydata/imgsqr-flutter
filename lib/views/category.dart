import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imgsqr/data/data.dart';
import 'package:imgsqr/model/wallpaper_model.dart';
import 'package:imgsqr/widgets/widget.dart';

class Category extends StatefulWidget {

final String categoryName;
Category({this.categoryName});


  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> { 
  
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();

  
  getSearchWallpapers(String query) async {
    var response = await http.get(
        'https://api.pexels.com/v1/search?query=$query&per_page=15&page=1',
        headers: {"Authorization": apiKey});
    //Get JSON from response and parse
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    //Loop through Photos using model
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }


@override
  void initState() {
    getSearchWallpapers(widget.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: brandName(),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                wallpapersList(wallpapers: wallpapers, context: context),
              ],
            ),
          ),
        ));
      
    
  }
}