// Importing necessary Flutter and application-specific packages.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:round2newsapp/models/show_category.dart';
import 'package:round2newsapp/pages/article_view.dart';
import 'package:round2newsapp/services/show_category_news.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Declaration of the CategoryNews widget, a StatefulWidget to manage dynamic content based on category.
class CategoryNews extends StatefulWidget {
  final String name; // The category name to display and fetch news for.
  CategoryNews({required this.name}); // Constructor requiring a category name.

  @override
  State<CategoryNews> createState() => _CategoryNewsState(); // Creating state for the widget.
}

// State class for the CategoryNews widget.
class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = []; // List to store news articles.
  String summary = ''; // Variable to store an AI-generated summary.
  bool _loading = true; // Loading flag to show a progress indicator while data is loading.

  @override
  void initState() {
    super.initState(); // Calling initState of the superclass.
    getNewsFeed(); // Method to fetch news articles based on the category.
  }

  // Asynchronous method to fetch news feed for a specific category.
  getNewsFeed() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews(); // Creating instance of service class.
    await showCategoryNews.getCategoriesNews(widget.name.toLowerCase()); // Fetching news with category name.
    categories = showCategoryNews.categories; // Storing the fetched categories.
    summary = showCategoryNews.summary; // Storing the fetched summary.
    setState(() {
      _loading = false; // Set loading to false after fetching data.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name, style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0.0, // No shadow for a flat appearance.
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is loading.
          : Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
            itemCount: categories.length + 1, // Adding one for the summary at the start of the list.
            itemBuilder: (context, index) {
              if (index == 0) { // Check if the current item is the first to display the summary.
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'images/aisummary.jpg', // Hardcoded image for display.
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        summary, // Displaying the AI-generated summary.
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                );
              }
              ShowCategoryModel category = categories[index - 1]; // Adjusting index since the first item is the summary.
              return ShowCategory(
                Image: category.urlToImage!,
                desc: category.description!,
                title: category.title!,
                url: category.url!,
              );
            }),
      ),
    );
  }
}

// StatelessWidget to display individual news articles in the list.
class ShowCategory extends StatelessWidget {
  final String Image, desc, title, url; // Variables to hold article details.
  ShowCategory({required this.Image, required this.desc, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url))); // Navigate to article view on tap.
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10), // Space between article containers.
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded corners for the image.
              child: CachedNetworkImage(
                imageUrl: Image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover, // Cover fit for images.
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              title, // Article title.
              maxLines: 2,
              style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              desc, // Article description.
              maxLines: 3,
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
