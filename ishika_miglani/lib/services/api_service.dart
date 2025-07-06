import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

String email = 'hariom';

class ApiService {
  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        print('yes');
        List jsonData = json.decode(response.body);
        return jsonData.map((e) => Post.fromJson(e)).toList();
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e'); // This will show the real exception
      rethrow;
    }
  }
}
