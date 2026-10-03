import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/screens/home.dart';
import 'package:api_app/screens/register.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:api_app/services/api_keys.dart';
// import 'package:api_app/services/login_api.dart';
import 'package:api_app/services/restuarant_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color _accent = Color(0xFFB84725);
  static const Color _ink = Color(0xFF30231D);
  static const Color _muted = Color(0xFF78675C);
  static const Color _outline = Color(0xFFDCCFC3);
  static const Color _inputFill = Color(0xFFFFF8F0);

  bool isLoading = false;
  bool isSecure = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  late final RestuarantApi api;
  late String _accessToken;

  @override
  void initState() {
    super.initState();

    api = RestuarantApi(
      api: ApiDio(
        baseURL: ApiKeys.restuarantBaseUrl + ApiKeys.userENDPOINT,
        dio: Dio(),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await api.login(username.text, password.text);
      _accessToken = response['usercode'];
      print(response);
      print(_accessToken);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            var name = username.text.split('@');
            return Home(name: name[0], accessToken: _accessToken);
          },
        ),
      );
    } on DioException catch (e) {
      final message = ExceptionHandler.handle(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message =====  ${e.response?.statusCode}")),
      );
      print(message);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(31, 26, 24, 22),
                  blurRadius: 8,
                  spreadRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
              color: Color(0xFFFFFCF8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 32,
                      color: _ink,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                              hintText: "username",
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
                                Icons.person_outline_rounded,
                                color: _muted,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            obscureText: isSecure,
                            controller: password,
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
                                  isSecure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _muted,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isSecure = !isSecure;
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
                            onPressed: login,
                            color: _accent,
                            height: 55,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: (isLoading == true)
                                ? CircularProgressIndicator(color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Login",
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
                  ),
                  // Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have An Account?",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Cairo',
                          color: _ink,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
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
