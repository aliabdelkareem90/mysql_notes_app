import 'package:flutter/material.dart';
import 'package:mysql_notes_app/components/custom_textfield.dart';
import 'package:mysql_notes_app/constants/api_links.dart';
import 'package:mysql_notes_app/main.dart';
import 'package:mysql_notes_app/services/crud.dart';
import 'package:mysql_notes_app/services/validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final Crud _crud = Crud();

  login(context) async {
    // setState(() {
    //   isLoading = true;
    // });
    var response = await _crud.postRequest(
      loginLink,
      {
        "email": _emailController.text.toString(),
        "password": _passwordController.text.toString(),
      },
    );
    // setState(() {
    //   isLoading = false;
    // });

    if (response['status'] == "success") {
      sharedPreferences.setString("id", response["data"]["id"].toString());
      sharedPreferences.setString("username", response["data"]["username"]);
      sharedPreferences.setString("email", response["data"]["email"]);

      Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid Email or password",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'images/note_cards.png',
                height: 200,
              ),
              const SizedBox(height: 50),
              CustomTextField(
                textInputAction: TextInputAction.next,
                controller: _emailController,
                validator: (val) => Validator.validateEmail(val),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Password',
                isObscure: true,
                textInputAction: TextInputAction.done,
                controller: _passwordController,
                validator: (val) => Validator.validateInput(val, 8, 4),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await login(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      55,
                    ), // put the width and height you want
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/signUp");
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 19),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
