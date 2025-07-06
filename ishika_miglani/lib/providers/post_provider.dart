import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await ApiService.fetchPosts();
    } catch (e) {
      print('Error fetching posts: $e'); // shows in debug console
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }
}
