import 'package:api_insert/models/response_data_list.dart';
import 'package:api_insert/services/movie.dart';
import 'package:api_insert/widgets/alert.dart';
import 'package:api_insert/widgets/bottom_nav.dart';
import 'package:api_insert/views/tambah_movie_view.dart'; // Ensure this import exists
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
                  builder: (context) => TambahMovieView(title: "Tambah Movie", item: null),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: film == null
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : film!.isEmpty
              ? const Center(child: Text("No movies available"))
              : ListView.builder(
                  itemCount: film!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(film![index].title),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String r) async {
                          if (r == "Update") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TambahMovieView(
                                  title: "Update Movie",
                                  item: film![index],
                                ),
                              ),
                            );
                          } else {
                            var results = await AlertMessage().showAlertDialog(context);
                            if (results != null && results.containsKey('status')) {
                              if (results['status'] == true) {
                                var res = await movie.hapusMovie(context, film![index].id);
                                if (res.status == true) {
                                  AlertMessage().showAlert(context, res.message, true);
                                  getflm();
                                } else {
                                  AlertMessage().showAlert(context, res.message, false);
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
                    );
                  },
                ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
