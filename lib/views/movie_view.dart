import 'package:flutter/material.dart';


class MovieView extends StatefulWidget {
  const MovieView({super.key});


  @override
  State<MovieView> createState() => _MovieViewState();
}


class _MovieViewState extends State<MovieView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Text("Movie"),
    );
  }
}
