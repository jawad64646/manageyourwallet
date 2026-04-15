
class Transaction {
  String? id;
  String? title;
  String? amount;
  String? type;
  String? categoryName;


  Transaction({this.id, this.title, this.amount, this.type, this.categoryName,});

  // Factory to create a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      type: json['type'],
      categoryName: json['category_name'],

    );
  }
}
