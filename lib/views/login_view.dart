import 'package:api_insert/services/user.dart';
import 'package:api_insert/widgets/alert.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  UserService user = UserService();
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        decoration: InputDecoration(label: Text("Email")),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email harus diisi';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: password,
                        obscureText: showPass,
                        decoration: InputDecoration(
                          label: Text("Password"),
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            icon: showPass
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password harus diisi';
                          } else {
                            return null;
                          }
                        },
                      ),
                      MaterialButton(
                        onPressed: () async {
                           if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            var data = {
                              "email": email.text,
                              "password": password.text,
                            };
                            var result = await user.loginUser(data);
                            setState(() {
                              isLoading = false;
                            });
                            print(result.message);
                            if (result.status == true) {
                              AlertMessage()
                                  .showAlert(context, result.message, true);
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.pushReplacementNamed(
                                    context, '/dashboard');
                              });
                            } else {
                              AlertMessage()
                                  .showAlert(context, result.message, false);
                            }
                          }

                        },
                        child: isLoading == false
                            ? Text("LOGIN")
                            : CircularProgressIndicator(),
                        color: Colors.lightGreen,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}