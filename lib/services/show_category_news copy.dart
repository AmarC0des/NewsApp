import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:round2newsapp/models/show_category.dart';

// Class to handle fetching news and generating summaries for a given category.
class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];// List to store news articles of a specific category.
  String summary = '';  // Define the summary variable here
  final apiKey = 'yourGeminiKey';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: 'yourGeminiKey');

  // Asynchronous method to fetch news based on a given category.
  Future<void> getCategoriesNews(String category) async {
    String url = "yourNewsKey";
    var response = await http.get(Uri.parse(url));// Making a GET request to the URL.
    var jsonResponse = jsonDecode(response.body);// Decoding the JSON response body to a Dart object.

    // Checking if the API request was successful.
    if (jsonResponse['status'] == 'ok') {
      jsonResponse["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ShowCategoryModel categoryModel = ShowCategoryModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          categories.add(categoryModel);
        }
      });
    }
    // Fetching and storing the summary of articles in the specified category using the AI model.
    summary = await fetchSummary(category); // Fetch and store the summary
  }

  // Asynchronous method to generate a summary for a given category using generative AI.
  Future<String> fetchSummary(String category) async {
    final prompt = "Summarize the latest news in the $category category in a paragraph.";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    if (response.text != null) {
      return response.text!;
    } else {
      throw Exception('Failed to generate summary');
    }
  }
}
