import 'dart:convert';

import 'package:round2newsapp/models/article_model.dart';
import 'package:http/http.dart' as http;

//base news template that others will follow
class News{
  List<ArticleModel> newsFeed = [];
  Future<void> getNewsFeed() async{
    String url="yourNewsKey";
    var response = await http.get(Uri.parse(url));

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status']== 'ok'){
      jsonResponse["articles"].forEach((element) {
        if(element["urlToImage"]!= null && element['description']!= null){
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          newsFeed.add(articleModel);
        }
      });
    }
  }
}