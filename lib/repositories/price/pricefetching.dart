import 'package:art_inyou/models/model/postmodel.dart';
import 'package:art_inyou/repositories/post/fetching.dart';

Future<List<PostModel>> fetchPosts(String priceRange) async {
  List<PostModel> allPosts = await getPosts();
  return filterPostsByPriceRange(allPosts, priceRange);
}

List<PostModel> filterPostsByPriceRange(List<PostModel> posts, String priceRange) {
  if (priceRange == 'All') {
    return posts;
  }

  switch (priceRange) {
    case 'Less than 100':
      return posts.where((post) => _getPrice(post.softprice) < 100).toList();
    case '200 - 400':
      return posts.where((post) => _getPrice(post.softprice ) >= 200 && _getPrice(post.softprice) <= 400).toList();
    case '500 - 800':
      return posts.where((post) => _getPrice(post.hardprice) >= 500 && _getPrice(post.hardprice) <= 800).toList();
    case 'More than 800':
      return posts.where((post) => _getPrice(post.hardprice) > 800).toList();
    case 'Free':
      return posts.where((post) => int.tryParse(post.softprice) == 0).toList();
    default:
      return posts;
  }
}

int _getPrice(String priceString) {
  int? price = int.tryParse(priceString);
  if (price == null) {
    return -1;
  }
  return price;
}
