import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imgsqr/data/data.dart';
import 'package:imgsqr/model/wallpaper_model.dart';
import 'package:imgsqr/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();

  //Load Searched images
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
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xfff5f8fd)),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "search", border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            getSearchWallpapers(searchController.text);
                          },
                          child: Container(child: Icon(Icons.search)))
                    ],
                  ),
                ),
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
