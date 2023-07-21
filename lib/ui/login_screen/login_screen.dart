import 'package:exam_api/ui/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final String apiUrl = 'https://reqres.in/api/login';

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password. Please try again';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: loginHeader(),
    ));
  }

  Widget loginHeader() {
    return Column(
      children: [
        FormBuilder(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'email address',
                decoration: InputDecoration(hintText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              FormBuilderTextField(
                name: 'Password',
                decoration: InputDecoration(hintText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              ElevatedButton(onPressed: _login, child: Text('Login')),
              Text(_errorMessage)
            ],
          ),
        ))
      ],
    );
  }
}
