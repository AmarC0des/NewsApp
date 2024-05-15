// Importing necessary Flutter and application-specific packages.
import 'package:flutter/material.dart';
import '/models/slider_model.dart'; // Model for slider data.
import '/models/article_model.dart'; // Model for article data.
import 'package:round2newsapp/services/news.dart'; // Service for fetching news.
import 'package:round2newsapp/services/slider_data.dart'; // Service for fetching slider data.
import 'package:cached_network_image/cached_network_image.dart'; // Package for efficient image loading.
import 'package:round2newsapp/pages/article_view.dart'; // Page to view an individual article.

// Definition of the AllNews widget, which is a StatefulWidget to handle dynamic content based on the type of news.
class AllNews extends StatefulWidget {
  String news; // Variable to determine the type of news to display (e.g., "Breaking").
  AllNews({required this.news}); // Constructor requiring a type of news.

  @override
  State<AllNews> createState() => _AllNewsState(); // Creating state for the widget.
}

// State class for the AllNews widget.
class _AllNewsState extends State<AllNews> {
  List<sliderModel> sliders = []; // List to store slider items.
  List<ArticleModel> articles = []; // List to store articles.
  bool _loading = true; // Loading flag to show a progress indicator while data is loading.

  @override
  void initState() {
    super.initState(); // Call the initState of the superclass.
    getSliders(); // Fetch slider data.
    getNewsFeed(); // Fetch news articles.
  }

  // Asynchronous method to fetch news articles.
  getNewsFeed() async {
    News newsClass = News(); // Creating an instance of the News service.
    await newsClass.getNewsFeed(); // Fetching news data.
    articles = newsClass.newsFeed; // Storing the fetched articles.
    setState(() {
      _loading = false; // Update loading state.
    });
  }

  // Asynchronous method to fetch slider data.
  getSliders() async {
    NewsSlider slider = NewsSlider(); // Creating an instance of the NewsSlider service.
    await slider.getSliders(); // Fetching slider data.
    sliders = slider.sliders; // Storing the fetched sliders.
    setState(() {
      _loading = false; // Update loading state.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.news + " News", // Displaying the type of news in the AppBar.
            style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(), // Improves scrolling on devices.
              itemCount: widget.news == "Breaking" ? sliders.length : articles.length, // Count depends on news type.
              itemBuilder: (context, index) {
                // Conditional rendering based on news type.
                return AllNewsSection(
                  Image: widget.news == "Breaking" ? sliders[index].urlToImage! : articles[index].urlToImage!,
                  desc: widget.news == "Breaking" ? sliders[index].description! : articles[index].description!,
                  title: widget.news == "Breaking" ? sliders[index].title! : articles[index].title!,
                  url: widget.news == "Breaking" ? sliders[index].url! : articles[index].url!,
                );
              }),
        )
    );
  }
}

// StatelessWidget for displaying individual news or slider items.
class AllNewsSection extends StatelessWidget {
  String Image, desc, title, url; // Variables to hold data for each item.
  AllNewsSection({required this.Image, required this.desc, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation to the ArticleView page on tap.
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        child: Column(children: [
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
            title, // Display the title of the news/slider item.
            maxLines: 2,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          Text(desc, maxLines: 3,), // Display the description of the item.
          SizedBox(height: 20.0,), // Space after the description.
        ]),
      ),
    );
  }
}
