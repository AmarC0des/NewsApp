// Importing Flutter's material design library and the WebView plugin.
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Definition of ArticleView as a StatefulWidget to handle dynamic content.
class ArticleView extends StatefulWidget {
  String blogUrl; // Variable to store the URL of the blog to be displayed.
  ArticleView({required this.blogUrl}); // Constructor requiring a URL.

  @override
  State<ArticleView> createState() => _ArticleViewState(); // Creating state for the widget.
}

// State class for ArticleView.
class _ArticleViewState extends State<ArticleView> {
  // Build method to construct the UI elements.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the high-level structure for a screen.
      appBar: AppBar(
        // AppBar to show a title and handle navigation.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Aligns the AppBar title to the center.
          children: [
            Text("News"), // Part of the AppBar title.
            Text(
              "AI", // Another part of the AppBar title with styling.
              style: TextStyle(
                color: Colors.deepPurple, // Sets the color to deep purple.
                fontWeight: FontWeight.bold, // Makes the font bold.
              ),
            )
          ],
        ),
        centerTitle: true, // Centers the title within the AppBar.
        elevation: 0.0, // Removes the shadow under the AppBar for a flat design.
      ),
      body: Container(
        // Container to hold the WebView.
        child: WebView(
          initialUrl: widget.blogUrl, // Sets the initial URL of the WebView to the blog URL passed to the widget.
          javascriptMode: JavascriptMode.unrestricted, // Allows JavaScript execution within the WebView.
        ),
      ),
    );
  }
}
