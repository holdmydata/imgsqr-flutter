class WallpaperModel{
    
    int id;
    String photographer;
    String photographer_url;
    int photographer_id;
    SrcModel src;

    WallpaperModel({this.id, this.photographer, this.photographer_id, this.photographer_url, this.src});
// Get Json Data and return info needed for listing photos
    factory WallpaperModel.fromMap(Map<String, dynamic> jsonData){
      return WallpaperModel(
        src: SrcModel.fromMap(jsonData["src"]),
        id: jsonData["id"],
        photographer_url: jsonData["photographer_url"],
        photographer_id: jsonData["photographer_id"],
        photographer: jsonData["photographer"]
      );
    }
}

class SrcModel{

  String original;
  String small;
  String portrait;
  
  SrcModel({this.original, this.small, this.portrait});

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData["original"],
      small: jsonData["small"],
      portrait: jsonData["portrait"]);
  }
}