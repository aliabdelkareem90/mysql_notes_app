import 'package:flutter/material.dart';
import 'package:mysql_notes_app/components/custom_textfield.dart';
import 'package:mysql_notes_app/services/crud.dart';

import '../../constants/api_links.dart';
import '../../services/validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final Crud _crud = Crud();

  bool isLoading = false;

  signUp() async {
    setState(() {
      isLoading = true;
    });
    var response = await _crud.postRequest(
      signupLink,
      {
        "username": _userNameController.text.toString(),
        "email": _emailController.text.toString(),
        "password": _passwordController.text.toString(),
      },
    );
    setState(() {
      isLoading = false;
    });

    if (response['status'] == "success") {
      Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    } else {
      debugPrint('Signup failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
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
                      label: "Username",
                      textInputAction: TextInputAction.next,
                      controller: _userNameController,
                      validator: (val) => Validator.validateInput(val, 8, 4),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
                      validator: (val) => Validator.validateEmail(val),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Password',
                      isObscure: true,
                      textInputAction: TextInputAction.done,
                      controller: _passwordController,
                      validator: (val) {
                        return Validator.validateInput(val, 8, 5);
                      },
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await signUp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            55,
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 19),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/login");
                      },
                      child: const Text(
                        'Login',
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
