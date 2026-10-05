import 'package:api_app/custom/custom_snackBar.dart';
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
  static const Color _error = Color(0xFF963B2B);
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isSecure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password = TextEditingController();
  late final RestuarantApi api;
  late String _accessToken;
  final FocusNode passwordFocusNode = FocusNode();

  OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

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

  @override
  void dispose() {
    emailController.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      final email = emailController.text.trim();
      final response = await api.login(email, password.text);
      _accessToken = response['usercode'];
      print(response);
      print(_accessToken);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            var name = email.split('@');
            return Home(name: name[0], accessToken: _accessToken);
          },
        ),
      );
    } on DioException catch (e) {
      final message = ExceptionHandler.handle(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: message,
          backgroundColor: _error,
        ),
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
                colors: [Color(0xFFFFE7CF), Color(0xFFFFFAF5)],
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
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your email'
                                : null,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            autofillHints: const [AutofillHints.email],
                            cursorColor: _accent,
                            style: const TextStyle(
                              color: _ink,
                              fontFamily: 'Cairo',
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email address',
                              hintText: 'you@example.com',
                              filled: true,
                              fillColor: _inputFill,
                              labelStyle: const TextStyle(
                                color: _muted,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              hintStyle: const TextStyle(
                                color: _muted,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                              errorStyle: const TextStyle(
                                color: _error,
                                fontFamily: 'Cairo',
                                fontSize: 13,
                              ),
                              enabledBorder: _fieldBorder(_outline),
                              focusedBorder: _fieldBorder(_accent, width: 1.8),
                              errorBorder: _fieldBorder(_error, width: 1.5),
                              focusedErrorBorder: _fieldBorder(
                                _error,
                                width: 1.8,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: _muted,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            onFieldSubmitted: (_) {
                              passwordFocusNode.requestFocus();
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            focusNode: passwordFocusNode,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            obscureText: isSecure,
                            controller: password,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your password'
                                : null,
                            cursorColor: _accent,
                            style: const TextStyle(
                              color: _ink,
                              fontFamily: 'Cairo',
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              filled: true,
                              fillColor: _inputFill,
                              labelStyle: const TextStyle(
                                color: _muted,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              hintStyle: const TextStyle(
                                color: _muted,
                                fontFamily: 'Cairo',
                                fontSize: 15,
                              ),
                              errorStyle: const TextStyle(
                                color: _error,
                                fontFamily: 'Cairo',
                                fontSize: 13,
                              ),
                              enabledBorder: _fieldBorder(_outline),
                              focusedBorder: _fieldBorder(_accent, width: 1.8),
                              errorBorder: _fieldBorder(_error, width: 1.5),
                              focusedErrorBorder: _fieldBorder(
                                _error,
                                width: 1.8,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: _muted,
                              ),
                              suffixIcon: ExcludeFocus(
                                child: IconButton(
                                  icon: Icon(
                                    isSecure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: _muted,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isSecure = !isSecure;
                                    });
                                  },
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              login();
                            },
                          ),
                          const SizedBox(height: 25),
                          MaterialButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      login();
                                    }
                                  },
                            color: _accent,
                            disabledColor: _accent.withAlpha(150),
                            height: 55,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const Icon(
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
