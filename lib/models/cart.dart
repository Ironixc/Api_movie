class Cart {
  late final int? id;
  final String? id_movie;
  final String? title;
  final double? voteaverage;
  final String? overview;
  int? quantity = 0;
  final String? posterpath;

  Cart({
    required this.id,
    required this.id_movie,
    required this.title,
    required this.voteaverage,
    required this.overview,
    required this.quantity,
    required this.posterpath,
  });
  factory Cart.fromMap(Map<dynamic, dynamic> data) {
    return Cart(
      id: data['id'],
      id_movie: data['id'].toString(),
      title: data['title'],
      voteaverage: double.parse(data['voteaverage'].toString()),
      overview: data['overview'],
      quantity: data['quantity'],
      posterpath: data['posterpath'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_movie': id_movie,
      'title': title,
      'voteaverage': voteaverage,
      'overview': overview,
      'quantity': quantity,
      'posterpath': posterpath,
    };
  }
}
