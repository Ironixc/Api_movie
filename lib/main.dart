import 'dart:io';
import 'package:api_insert/views/CartScreen.dart';
import 'package:api_insert/views/HistoryView.dart';
import 'package:api_insert/views/dashboard.dart';
import 'package:api_insert/views/login_view.dart';
import 'package:api_insert/views/movie_view.dart';
import 'package:api_insert/views/pesan_view.dart';
import 'package:api_insert/views/register_user_view.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Apply SSL bypass globally
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => RegisterUserView(),
      '/login': (context) => LoginView(),
      '/dashboard': (context) => DashboardView(),
      '/movie': (context) => MovieView(),
      '/pesan': (context) => PesanView(),
      '/cartScreen': (context) => Cartscreen(),
      '/history': (context) => Historyview(),
    },
  ));
}
