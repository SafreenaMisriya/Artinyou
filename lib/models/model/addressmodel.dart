class AddressModel {
  final String name;
  final String phone;
  final String house;
  final String state;
  final String city;
  final String pincode;
  final String price;
  final String postid;
  final String id;

  AddressModel({
    this.id='',
    required this.name,
    required this.phone,
    required this.price,
    required this.house,
    required this.state,
    required this.city,
    required this.pincode,
    required this.postid,
  });
    factory  AddressModel.fromJson(Map<String, dynamic> json, {String id = ''} ) {
    return  AddressModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      price: json['price'] ?? '',
      house: json['house'] ?? '',
      state: json['state'] ?? '',
      postid: json['postid']?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '', 
      id: id,
    );
  }
}
