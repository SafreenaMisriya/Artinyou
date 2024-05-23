class PaymentModel {
  final String amount;
  final String time;
  String status;
  final String id;
  final String postid;
   final String hardcopy;
  String userid;
  String imageurl;
  String title;
  PaymentModel({
    required this.hardcopy,
    required this.amount,
    required this.time,
    this.status = "",
    required this.postid,
    this.userid = "",
    this.imageurl = "",
    this.title = "",
    this.id = " ",
  });
  factory PaymentModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return PaymentModel(
      amount: json['amount'] ?? '',
      time: json['payedtime'] ?? '',
      status: json['status'] ?? '',
      postid: json['postid'] ?? '',
      imageurl: json['image'] ?? '',
      userid: json['userid'] ?? "",
      title: json['title'] ?? "",
      hardcopy: json['hardcopy']??"",
      id: id,
    );
  }
  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}
