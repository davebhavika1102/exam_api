import 'package:exam_api/ui/home_screen/home_screen.dart';
import 'package:exam_api/ui/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isRegistering = false;

  String _responseMessage = '';
  bool _isPasswodStrong(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'));
  }

  bool _isEmail(String email) {
    return email.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
  }

  void _registerUser() async {
    setState(() {
      _isRegistering = true;
    });

    bool isEmailValid = _isEmail(emailController.text);
    bool isPassword = _isPasswodStrong(passwordController.text);

    if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("enter valid email"),
      ));
      setState(() {
        _isRegistering = false;
      });
      return;
    }
    if (!isPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("enter valid password"),
      ));
      setState(() {
        _isRegistering = false;
      });
      return;
    }
    final apiUrl = 'https://reqres.in/api/register';

    try {
      final responce = await http.post(
        Uri.parse(apiUrl),
        body: {'name': fullNameController.text, 'email': emailController.text, "password": passwordController.text},
      );
      if (responce.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Register successful"),
          ));
          _responseMessage = 'Register successfull';
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("register failed"),
          ));
          _responseMessage = 'Register failed. Please try again';
        });
      }
      setState(() {
        _isRegistering = false;
      });
    } catch (error) {
      setState(() {
        _isRegistering = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("an error occurred"),
        ));
        _responseMessage = 'an error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Register App'),
      ),
      body: _isRegistering ? _buildProgressIndicator() : registerHeader(),
    ));
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget registerHeader() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'full name',
                      decoration: InputDecoration(hintText: 'Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
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
                    ElevatedButton(onPressed: _registerUser, child: Text('Register')),
                    Text(_responseMessage),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text('Login'))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
