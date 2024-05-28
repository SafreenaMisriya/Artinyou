import 'package:art_inyou/models/model/postmodel.dart';

Future<List<PostModel>> fetchPosts(String priceRange) async {
  List<PostModel> posts = [];
  try {
    if (priceRange == 'All') {
    } else if (priceRange == 'More than 800') {
    } else if (priceRange == "Free") {
    } else if (priceRange == 'Less than 100') {
    } else {
      List<String> range = priceRange.split(' - ');
      double.parse(range[0].replaceAll('Less than ', '').trim());
    }
  } catch (e) {
    throw Exception('Failed to fetch posts: $e');
  }
  return posts;
}
