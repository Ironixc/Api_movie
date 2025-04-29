import 'package:api_insert/services/url.dart' as url;

class MovieModel {
  int? id;
  String? title;
  double? voteAverage;
  String? overview;
  String? posterPath; 

  MovieModel({
    required this.id,
    required this.title,
    this.voteAverage,
    this.overview,
    required this.posterPath,
  });

  MovieModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    title = parsedJson["title"];
    voteAverage = double.tryParse(parsedJson["voteaverage"].toString()) ?? 0.0;
    overview = parsedJson["overview"];
    posterPath = parsedJson.containsKey("posterpath")
        ? "${url.ImageUrl}/${parsedJson["posterpath"]}"
        : "${url.ImageUrl}/${parsedJson["poster_path"]}";
  }
}
