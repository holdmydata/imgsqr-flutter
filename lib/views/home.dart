import 'dart:convert';
import 'package:imgsqr/views/image_view.dart';

import 'category.dart';
import 'package:flutter/material.dart';
import 'package:imgsqr/data/data.dart';
import 'package:imgsqr/model/wallpaper_model.dart';
import 'package:imgsqr/views/search.dart';
import 'package:imgsqr/widgets/widget.dart';
import 'package:imgsqr/model/category_model.dart';
import 'search.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();

  //Load trending images
  getTrendingWallpapers() async {
    var response = await http.get(
        'https://api.pexels.com/v1/curated?per_page=15&page=1',
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

//Initialize into getting the Categories on load
  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                      GestureDetector(onTap:(){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Search(
                              searchQuery: searchController.text,
                            ) 
                          ));
                        },
                        child: Container(
                          child: Icon(Icons.search)
                          )
                        )
                    ],
                  ),
                ),
                // Boxes for Categories
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 80,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      itemCount: categories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          title: categories[index].categoryName,
                          imgUrl: categories[index].imgUrl,
                        );
                      }),
                ),
                wallpapersList(wallpapers: wallpapers, context: context)
              ],
            ),
          ),
        ));
  }
}

class CategoryTile extends StatelessWidget {
  final String imgUrl, title;
  CategoryTile({@required this.imgUrl, @required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
        builder: (context) => Category(
          categoryName: title.toLowerCase(),
          ),
          ));
      },
          child: Container(
          margin: EdgeInsets.only(right: 4),
          child: Stack(
            children: <Widget>[

              ClipRRect(
                       borderRadius: BorderRadius.circular(8),
                  child: Image.network(imgUrl,
                      height: 50, width: 100, fit: BoxFit.cover)),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8)),
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
              ),
            ],
          )),
    );
  }
}
