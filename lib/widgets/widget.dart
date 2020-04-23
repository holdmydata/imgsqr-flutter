import 'package:flutter/material.dart';
import 'package:imgsqr/model/wallpaper_model.dart';
import 'package:imgsqr/views/image_view.dart';

Widget brandName() {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 26,),
      children: <TextSpan>[
        TextSpan(
            text: 'Image',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        TextSpan(
            text: 'Sqr',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    ),
  );
}

Widget wallpapersList({List<WallpaperModel> wallpapers, context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ImageView(
                  imgUrl: wallpaper.src.portrait, photographerId: wallpaper.photographer_id.toString(), id: wallpaper.id.toString())));
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(wallpaper.src.portrait,
                        fit: BoxFit.cover)),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
