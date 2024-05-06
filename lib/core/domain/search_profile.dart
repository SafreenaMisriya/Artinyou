
 import 'package:art_inyou/core/data/model/profilemodel.dart';

List<ProfileModel> getFilteredProfiles(List<ProfileModel>? allProfiles,String search) {
    String searchQuery = search.toLowerCase();
    if (searchQuery.isEmpty) {
      return allProfiles ?? [];
    }else {
      return (allProfiles ?? []).where((profile) => profile.username.toLowerCase().contains(searchQuery)).toList();
    }
  }