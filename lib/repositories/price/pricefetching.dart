import 'package:art_inyou/models/model/postmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Helper function to apply price range filter
Query applyPriceRangeFilter(Query query, String priceRange) {
  if (priceRange == 'Less than 100') {
    return query.where('hardprice', isLessThan: 100);
  } else if (priceRange == '200 - 400') {
    return query.where('hardprice', isGreaterThanOrEqualTo: 200).where('hardprice', isLessThanOrEqualTo: 400);
  } else if (priceRange == '500 - 800') {
    return query.where('hardprice', isGreaterThanOrEqualTo: 500).where('hardprice', isLessThanOrEqualTo: 800);
  } else if (priceRange == 'More than 800') {
    return query.where('hardprice', isGreaterThan: 800);
  } else if (priceRange == 'Free') {
    return query.where('hardprice', isEqualTo: 0);
  } else {
    return query; // No filter applied
  }
}

Future<List<PostModel>> fetchPosts(String priceRange) async {
  List<PostModel> posts = [];
  try {
    Query query = FirebaseFirestore.instance.collection('posts');
    
    // Apply price range filter if not 'All'
    if (priceRange != 'All') {
      query = applyPriceRangeFilter(query, priceRange);
    }

    QuerySnapshot querySnapshot = await query.get();

    for (var doc in querySnapshot.docs) {
      print("Processing document ID: ${doc.id}"); // Debug print
      print("Document data: ${doc.data()}"); // Debug print
      PostModel post = PostModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
      posts.add(post);
    }

    print("Fetched ${querySnapshot.docs.length} documents."); // Debug print

  } catch (e) {
    print("Error fetching posts: $e"); // Debug print
    throw Exception('Failed to fetch posts: $e');
  }
  return posts;
}
