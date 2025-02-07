import 'package:api_insert/views/dashboard.dart';
import 'package:api_insert/views/login_view.dart';
import 'package:api_insert/views/register_user_view.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => RegisterUserView(),
      '/login':(context) => LoginView(),
      '/dashboard':(context) =>DashboardView(),
      '/movie':(context) =>DashboardView(),
      '/pesan':(context) =>DashboardView(),
    },
  ));
}
