import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  // Tracks whether the current post is marked as favorite
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus(); // Check saved favorites on screen load
  }

  /// Loads the saved favorite status from SharedPreferences for this post
  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritePosts = prefs.getStringList('favoritePosts');
    if (favoritePosts != null) {
      setState(() {
        // If this post's ID exists in saved favorites, mark it as favorite
        isFavorite = favoritePosts.contains(widget.post.id.toString());
      });
    }
  }

  /// Toggles the favorite status and updates SharedPreferences
  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePosts = prefs.getStringList('favoritePosts') ?? [];

    setState(() {
      if (isFavorite) {
        // If currently favorite, remove from favorites
        favoritePosts.remove(widget.post.id.toString());
        isFavorite = false;

        // Show Snackbar notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from your favourites'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        // If not favorite, add to favorites
        favoritePosts.add(widget.post.id.toString());
        isFavorite = true;

        // Show Snackbar notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post saved to your favourites'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    // Save the updated favorite list persistently
    await prefs.setStringList('favoritePosts', favoritePosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18191F), // Dark theme background
      appBar: AppBar(
        backgroundColor: const Color(0xFF18191F),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Article Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          // Favorite button with dynamic icon and color
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Title
              Text(
                widget.post.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // Post Body inside a rounded container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF21222A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.post.body,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
