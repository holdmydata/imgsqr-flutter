import 'package:imgsqr/model/category_model.dart';

String apiKey = "563492ad6f917000010000016199c5bc165040a082a3a6a2d1d76d58";


List<CategoryModel> getCategory(){

  List<CategoryModel> categories = new List();
  CategoryModel categoryModel = new CategoryModel();



//
  categoryModel.imgUrl = 'https://www.eastshore.xyz/wp-content/uploads/2019/09/The-Impossible-Triangle-A-Lie-about-Blockchain-IMG-00.png';
  categoryModel.categoryName = 'Blockchain';
  categories.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.imgUrl = 'https://www.freedigitalphotos.net/images/category-images/131.jpg';
  categoryModel.categoryName = 'Food';
  categories.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.imgUrl = 'https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE2uCzt?ver=eb50&q=90&m=2&h=768&w=1024&b=%23FFFFFFFF&aim=true';
  categoryModel.categoryName = 'Office';
  categories.add(categoryModel);
  categoryModel = new CategoryModel();

print(categories);
return categories;

}
