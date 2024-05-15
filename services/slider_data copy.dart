import 'dart:convert';
import 'package:round2newsapp/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:round2newsapp/models/slider_model.dart';

//Think of this as a more barebones version of show_category_news.dart (only for slider)
class NewsSlider{
  List<sliderModel> sliders = [];
  Future<void> getSliders() async{
    String url="yourNewsKey";
    var response = await http.get(Uri.parse(url));

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status']== 'ok'){
      jsonResponse["articles"].forEach((element) {
        if(element["urlToImage"]!= null && element['description']!= null){
          sliderModel slidermodel = sliderModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          sliders.add(slidermodel);
        }
      });
    }
  }
}