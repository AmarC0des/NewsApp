//this file was more a testing template which was implemented in show_category_news.dart
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  const apiKey = 'your-api-key'; // Replace with your actual API key
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final prompt = 'Your prompt here.';
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
}
