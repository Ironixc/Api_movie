import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:api_insert/models/movie_model.dart';
import 'package:api_insert/services/movie.dart';
import 'package:api_insert/widgets/alert.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TambahMovieView extends StatefulWidget {
  final String title;
  final MovieModel? item;

  const TambahMovieView({required this.title, required this.item, Key? key}) : super(key: key);

  @override
  State<TambahMovieView> createState() => _TambahMovieViewState();
}

class _TambahMovieViewState extends State<TambahMovieView> {
  final MovieService movie = MovieService();
  final formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController voteAverage = TextEditingController();
  TextEditingController overView = TextEditingController();

  File? selectedImage;
  Uint8List? selectedImageBytes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      title.text = widget.item!.title!;
      voteAverage.text = widget.item!.voteAverage!.toString();
      overView.text = widget.item!.overview!;
    }
  }

  Future getImage() async {
    setState(() => isLoading = true);

    if (kIsWeb) {
      // Untuk Web
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          selectedImage = File(result.files.first.name); // Hanya untuk nama file
          selectedImageBytes = result.files.first.bytes;
          isLoading = false;
        });
      }
    } else {
      // Untuk Mobile & Desktop
      var img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          selectedImage = File(img.path);
          selectedImageBytes = null; // Reset agar tidak mengacaukan upload web
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveMovie() async {
    if (formKey.currentState!.validate()) {
      var data = {
        "title": title.text,
        "voteaverage": voteAverage.text,
        "overview": overView.text,
      };

      var result;
      if (widget.item != null) {
        result = await movie.insertMovie(data, selectedImage, selectedImageBytes, widget.item!.id);
      } else {
        result = await movie.insertMovie(data, selectedImage, selectedImageBytes, null);
      }

      if (result.status == true) {
        AlertMessage().showAlert(context, result.message, true);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/movie');
      } else {
        AlertMessage().showAlert(context, result.message, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: title,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                ),
                TextFormField(
                  controller: voteAverage,
                  decoration: const InputDecoration(labelText: "Vote Average"),
                  validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                ),
                TextFormField(
                  controller: overView,
                  decoration: const InputDecoration(labelText: "Overview"),
                  validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                ),
                TextButton(
                  onPressed: getImage,
                  child: const Text("Select Picture"),
                ),
                selectedImage != null
                    ? kIsWeb
                        ? Image.memory(selectedImageBytes!, height: 200)
                        : Image.file(selectedImage!, height: 200)
                    : isLoading
                        ? const CircularProgressIndicator()
                        : const Center(child: Text("No Image Selected")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: saveMovie,
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
