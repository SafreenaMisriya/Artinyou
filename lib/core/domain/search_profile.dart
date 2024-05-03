
 import 'package:art_inyou/core/data/model/profilemodel.dart';

List<ProfileModel> getFilteredProfiles(List<ProfileModel>? allProfiles,String search) {
    String searchQuery = search.toLowerCase();
    if (searchQuery.isEmpty) {
      // If search query is empty, return all profiles
      return allProfiles ?? [];
    }else {
      // If search query is not empty, filter profiles based on username
      return (allProfiles ?? []).where((profile) => profile.username.toLowerCase().contains(searchQuery)).toList();
    }
  }