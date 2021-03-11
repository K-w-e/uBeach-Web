class Chalet {
  final String name, description, location, image;

  Chalet({this.name, this.description, this.location, this.image});

  factory Chalet.fromJson(Map<String, dynamic> json) {
    return Chalet(
      name: json['name'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
    );
  }
}
