import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/screens/login.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:api_app/services/api_keys.dart';
// import 'package:api_app/services/login_api.dart';
import 'package:api_app/services/restuarant_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const Color _accent = Color(0xFFB84725);
  static const Color _ink = Color(0xFF30231D);
  static const Color _muted = Color(0xFF78675C);
  static const Color _outline = Color(0xFFDCCFC3);
  static const Color _inputFill = Color(0xFFFFF8F0);

  late final TextEditingController username;
  late final TextEditingController password;
  late final TextEditingController confirmPassword;
  final formKey = GlobalKey<FormState>();
  late final RestuarantApi api;
  bool isLoading = false;
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    api = RestuarantApi(
      api: ApiDio(
        baseURL: "${ApiKeys.restuarantBaseUrl}${ApiKeys.userENDPOINT}/register",
        dio: Dio(),
      ),
    );
  }

  String? validEmail(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter an email';
    }
    if (!val.contains('@') || !val.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validPass(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? confirm(String? pass, String? con) {
    if (con == null || con.isEmpty) {
      return 'Please confirm your password';
    }

    if (con != pass) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await api.register(username.text, password.text);
      print(response);
      if (!mounted) return;
      _goToLogin();
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ExceptionHandler.handle(e))));
      print(ExceptionHandler.handle(e));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  MaterialPageRoute<void> _loginRoute() => MaterialPageRoute<void>(
    builder: (context) => const LoginPage(),
  );

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(context, _loginRoute(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                colors: [
                  Color(0xFFFFE7CF),
                  Color(0xFFFFFAF5),
                ],
              ),
            ),
            child: Image.asset(
              "assets/images/pizza.png",
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 280),
            padding: EdgeInsets.all(40),
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFCF8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1F38251B),
                  blurRadius: 8,
                  spreadRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 32,
                        color: _ink,
                      ),
                    ),
                    SizedBox(height: 25),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: username,
                            validator: (value) => validEmail(value),
                            decoration: InputDecoration(
                              hintText: "Email",
                              filled: true,
                              fillColor: _inputFill,
                              hintStyle: TextStyle(
                                color: _muted,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _outline,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _accent,
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: _muted,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: (value) => validPass(value),
                            controller: password,
                            obscureText: isPasswordObscured,
                            decoration: InputDecoration(
                              hintText: "Password",
                              filled: true,
                              fillColor: _inputFill,
                              hintStyle: TextStyle(
                                color: _muted,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: _muted,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _muted,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordObscured = !isPasswordObscured;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _outline,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _accent,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: confirmPassword,
                            // validator: (value) => confirm(password.text, value),
                            obscureText: isConfirmPasswordObscured,
                            decoration: InputDecoration(
                              hintText: "Confirm Your Password",
                              filled: true,
                              fillColor: _inputFill,
                              hintStyle: TextStyle(
                                color: _muted,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: _muted,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _muted,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordObscured =
                                        !isConfirmPasswordObscured;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _outline,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _accent,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          MaterialButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                register();
                              }
                            },
                            color: _accent,
                            height: 55,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Register",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_sharp,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            color: _ink,
                          ),
                        ),
                        TextButton(
                          onPressed: _goToLogin,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Cairo',
                              color: _accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
