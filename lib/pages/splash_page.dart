// Import Flutter's material design and cupertino (iOS-style) design libraries.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/pages/home.dart'; // Import the Home page.

// Declaration of the SplashPage widget, which is a StatefulWidget to allow for mutable state.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key}); // Constructor with an optional key parameter.

  @override
  State<SplashPage> createState() => _SplashPageState(); // Creating state for the widget.
}

// State class for the SplashPage widget.
class _SplashPageState extends State<SplashPage> {
  // Build method that constructs the UI of the widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold is used to create the basic visual structure of the screen.
      body: Container(
        // Container for padding around the edges.
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          // Column widget to arrange its children vertically.
          children: [
            Material(
              // Material widget provides visual structure such as elevation.
              elevation: 3.0,
              borderRadius: BorderRadius.circular(30), // Rounded corners.
              child: ClipRRect(
                // ClipRRect is used to clip the child with rounded corners.
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "images/building.jpg", // Loads an image from assets.
                  width: MediaQuery.of(context).size.width, // Sets image width to the width of the device screen.
                  height: MediaQuery.of(context).size.height / 1.7, // Sets height relative to device height.
                  fit: BoxFit.cover, // Covers the area of the box without changing the aspect ratio.
                ),
              ),
            ),
            SizedBox(height: 20.0), // Provides a fixed amount of space between widgets.
            Text(
              "News from around the\n               globe", // Text widget to display a string of text.
              style: TextStyle(
                color: Colors.black,
                fontSize: 26.0,
                fontWeight: FontWeight.bold, // Bold text for emphasis.
              ),
            ),
            Text(
              "There is never a better time to read, take\n   a moment to fill yourself in the world", // Additional descriptive text.
              style: TextStyle(
                color: Colors.black45,
                fontSize: 18.0,
                fontWeight: FontWeight.w500, // Slightly bold.
              ),
            ),
            SizedBox(height: 40.0), // More spacing.
            GestureDetector(
              onTap: () {
                // GestureDetector to detect tap gestures.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), // Navigates to Home page when tapped.
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2, // Container width.
                child: Material(
                  borderRadius: BorderRadius.circular(30), // Rounded corners.
                  elevation: 5.0, // Shadow effect.
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0), // Padding inside the container.
                    decoration: BoxDecoration(
                      color: Colors.deepPurple, // Background color.
                      borderRadius: BorderRadius.circular(30), // Rounded corners.
                    ),
                    child: Center(
                      child: Text(
                        "Get Started", // Text inside the button.
                        style: TextStyle(
                          color: Colors.white, // Text color.
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500, // Slightly bold.
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
