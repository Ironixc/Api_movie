import 'package:api_insert/services/user.dart';
import 'package:flutter/material.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  insertUser() async {
    var data = {
      "name": "Ironhead",
      "email": "Arya@gmail.com",
      "role": "admin",
      "password": "12345678",
    };
    var result = await UserService().registerUser(data);
    print(result.status);
    print(result.message);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    insertUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}