class PaymentModel{
  final String amount;
  final String time;
  // final String paymentid;
  final String id;
  final String postid;
  String userid;
  String imageurl;
  String title;
  PaymentModel({
    required this.amount,
    required this.time,
    // required this.paymentid,
    required this.postid,
   this.userid="",
  this.imageurl="",
  this.title="",
    this. id=" ",
  });
    factory PaymentModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return PaymentModel(
      amount: json['amount'] ?? '',
      time: json['payedtime'] ?? '',
      // paymentid: json['paymentid'] ?? '',
      postid: json['postid'] ?? '',
      imageurl: json['image']?? '',
      userid: json['userid']?? "",
      title: json['title']??"",
      id:id,

    );
  }
   double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}