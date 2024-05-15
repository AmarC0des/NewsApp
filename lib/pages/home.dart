// Import statements for Flutter packages and local modules.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:round2newsapp/models/article_model.dart';
import 'package:round2newsapp/pages/all_news.dart';
import 'package:round2newsapp/pages/article_view.dart';
import 'package:round2newsapp/pages/category_news.dart';
import 'package:round2newsapp/services/data.dart';
import 'package:round2newsapp/services/news.dart';
import 'package:round2newsapp/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/models/category_model.dart';
import '/models/slider_model.dart';

// Defining a StatefulWidget called Home.
class Home extends StatefulWidget {
  const Home({super.key}); // Constructor with optional key parameter.

  @override
  State<Home> createState() => _HomeState(); // Creating state for the widget.
}

// The state class for Home widget, handling its state.
class _HomeState extends State<Home> {
  // Initialization of state variables.
  List<CategoryModel> categories = [];
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  int activeIndex = 0;

  // Override the initState method to perform initial state setup.
  @override
  void initState() {
    super.initState();
    categories = getCategories(); // Load categories from a function.
    getSliders(); // Async call to load sliders.
    getNewsFeed(); // Async call to load news feed.
  }

  // Async function to fetch news articles.
  Future<void> getNewsFeed() async {
    News newsClass = News();
    await newsClass.getNewsFeed();
    if (newsClass.newsFeed != null) {
      articles = newsClass.newsFeed.where((article) => article.title != null && article.urlToImage != null).toList();
      setState(() {
        _loading = false; // Update loading state.
      });
    }
  }

  // Async function to fetch slider data.
  Future<void> getSliders() async {
    NewsSlider slider = NewsSlider();
    await slider.getSliders();
    sliders = slider.sliders;
    setState(() {
      _loading = false; // Update loading state.
    });
  }

  // Building the widget tree for this state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("News"),
            Text(
              "AI",
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category list view builder.
              Container(
                margin: EdgeInsets.only(left: 10.0),
                height: 70,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryTile(
                        image: categories[index].image,
                        categoryName: categories[index].categoryName,
                      );
                    }),
              ),
              SizedBox(
                height: 30.0,
              ),
              // Breaking news section.
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Breaking News!",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AllNews(news: "Breaking")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // Carousel slider for news images.
              CarouselSlider.builder(
                  itemCount: 5,
                  itemBuilder: (context, index, realIndex) {
                    String? res = sliders[index].urlToImage;
                    String? res1 = sliders[index].title;
                    return buildImage(res!, index, res1!);
                  },
                  options: CarouselOptions(
                      height: 250,
                      pauseAutoPlayOnManualNavigate: true,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      })),
              SizedBox(
                height: 30.0,
              ),
              Center(child: buildIndicator()),
              SizedBox(
                height: 30.0,
              ),
              // Trending news section.
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AllNews(news: "Trending")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                            color: Colors.deepPurple, fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // News articles list.
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return BlogTile(
                          url: articles[index].url!,
                          desc: articles[index].description!,
                          imageUrl: articles[index].urlToImage!,
                          title: articles[index].title!);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual slider images.
  Widget buildImage(String image, int index, String name) => Container(
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: image,
            height: 250,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Container(
          height: 250,
          padding: EdgeInsets.only(left: 10.0),
          margin: EdgeInsets.only(top: 170.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
          child: Center(
            child: Text(
              name,
              maxLines: 2,
              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    ),
  );

  // Helper method to build page indicators for the carousel.
  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: 5,
    effect: ScrollingDotsEffect(dotWidth: 15, dotHeight: 15, activeDotColor: Colors.deepPurple),
  );
}

// Widget for displaying categories in the horizontal list.
class CategoryTile extends StatelessWidget {
  final image, categoryName;

  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.black26),
              child: Center(
                  child: Text(
                    categoryName,
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

// Widget for displaying news articles in the list.
class BlogTile extends StatelessWidget {
  String imageUrl, title, desc, url;

  BlogTile({required this.desc, required this.imageUrl, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ))),
                  SizedBox(width: 8.0),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.77,
                        child: Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17.0),
                        ),
                      ),
                      SizedBox(height: 7.0),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Text(
                          desc,
                          maxLines: 3,
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
