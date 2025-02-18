import 'package:api_insert/models/response_data_list.dart';
import 'package:api_insert/services/movie.dart';
import 'package:api_insert/widgets/alert.dart';
import 'package:api_insert/widgets/bottom_nav.dart';
import 'package:api_insert/views/tambah_movie_view.dart';
import 'package:flutter/material.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  MovieService movie = MovieService();
  List? film;
  List<String> action = ["Update", "Hapus"];

  @override
  void initState() {
    super.initState();
    getflm();
  }

  Future<void> getflm() async {
    ResponseDataList getMovie = await movie.getMovie();
    setState(() {
      film = getMovie.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TambahMovieView(title: "Tambah Movie", item: null),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: film == null
          ? const Center(child: CircularProgressIndicator())
          : film!.isEmpty
              ? const Center(child: Text("No movies available"))
              : ListView.builder(
                  itemCount: film!.length,
                  itemBuilder: (context, index) {
                    var item = film![index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: item.posterPath != null &&
                                item.posterPath!.isNotEmpty
                            ? Image.network(
                                item.posterPath!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.movie, size: 50),
                        title: Text(item.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rating: ${item.voteAverage}"),
                            Text(item.overview,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String r) async {
                            if (r == "Update") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TambahMovieView(
                                    title: "Update Movie",
                                    item: item,
                                  ),
                                ),
                              );
                            } else {
                              var results =
                                  await AlertMessage().showAlertDialog(context);
                              if (results != null &&
                                  results.containsKey('status')) {
                                if (results['status'] == true) {
                                  var res =
                                      await movie.hapusMovie(context, item.id);
                                  if (res.status == true) {
                                    AlertMessage()
                                        .showAlert(context, res.message, true);
                                    getflm();
                                  } else {
                                    AlertMessage()
                                        .showAlert(context, res.message, false);
                                  }
                                }
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return action.map((String r) {
                              return PopupMenuItem<String>(
                                value: r,
                                child: Text(r),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
