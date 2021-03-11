class Menu {
  final List primi, secondi, bar, bibite;

  Menu({this.primi, this.secondi, this.bar, this.bibite});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        primi: json['primi'],
        secondi: json['secondi'],
        bar: json['bar'],
        bibite: json['bibite']);
  }
}
