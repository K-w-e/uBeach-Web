class Order {
  final List cart;
  final String id, title, username, tot, userId;
  final DateTime date;
  Order(
      {this.tot,
      this.cart,
      this.id,
      this.title,
      this.username,
      this.date,
      this.userId});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['item'],
        cart: json['cart'],
        tot: json['tot'],
        title: json['title'],
        date: DateTime.parse(json['title'].substring(1)),
        username: json['username'],
        userId: json['user']);
  }
}
