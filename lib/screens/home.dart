import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/models/product_model.dart';
import 'package:api_app/models/user_model.dart';
import 'package:api_app/screens/weather.dart';
import 'package:api_app/services/api_keys.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:api_app/services/login_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String name;
  final String accessToken;
  const Home({super.key, required this.name, required this.accessToken});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  List<Product> productList = [];
  TextEditingController idControl = TextEditingController();
  late final LoginApi
  api; // remove LoginApi Here -- send user's data in Constructor
  String? firstName;
  String? lastName;
  String? image;
  int? age;

  @override
  void initState() {
    super.initState();
    api = LoginApi(
      api: ApiDio(
        baseURL: ApiKeys.baseUrl + ApiKeys.profileENDPOINT,
        dio: Dio(),
      ),
    );
  }

  Future<dynamic> getProfile(String token) async {
    try {
      final response = await api.getProfile(token);
      print(response);
      return response;
    } on DioException catch (e) {
      final message = ExceptionHandler.handle(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message =====  ${e.response?.statusCode}")),
      );
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Hello, ${widget.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  fontSize: 32,
                  color: const Color(0xDD313030),
                ),
              ),
              Row(
                children: [
                  const Text("Enter id : ", style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      controller: idControl,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical:0 ),
                        suffix: idControl.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  idControl.clear();
                                },
                                icon: const Icon(Icons.cancel),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                    productList = [];
                  });
                  final ApiDio api = ApiDio(
                    baseURL: "${ApiKeys.baseUrl}${ApiKeys.productENDPOINT}",
                    dio: Dio(),
                  );
                  var temp = await api.get(
                    id: int.tryParse(idControl.text),
                    queryParameters: idControl.text.isEmpty
                        ? {'skip': 10, 'limit': 5}
                        : {},
                  );
                  if (idControl.text.isEmpty) {
                    final products = (temp['products'] as List<dynamic>)
                        .map(
                          (json) =>
                              Product.formJson(json as Map<String, dynamic>),
                        )
                        .toList();

                    setState(() {
                      productList.addAll(products);
                    });
                    print(temp);
                  } else {
                    Product pro = Product.formJson(temp);
                    setState(() {
                      productList.add(pro);
                    });
                    print(temp);
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: Text(
                  "Press to Get Dio Response",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherPage(city: 'Aswan'),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: Text(
                  "Weather page",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    productList = [];
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
                ),
                child: Text("Delete", style: TextStyle(color: Colors.white)),
              ),
              // SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  final jsonData = await getProfile(widget.accessToken);
                  if (!mounted || jsonData is! Map<String, dynamic>) return;
                  final user = User.fromJson(jsonData);
                  setState(() {
                    firstName = user.firstName;
                    age = user.age;
                    lastName = user.lastName;
                    image = user.image;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
                ),
                child: Text(
                  "Get Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 15),
              (isLoading)
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(productList[index].title),
                              subtitle: Text(
                                productList[index].price.toString(),
                              ),
                              leading:
                                  productList[index].images?.isNotEmpty == true
                                  ? Image.network(
                                      productList[index].images!.first,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                              ),
                                    )
                                  : const Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
                    ),
              Text("Fisrt name : $firstName"),
              Text("last name : $lastName"),
              Text("age : $age"),
              image == null
                  ? const Icon(Icons.account_circle, size: 80)
                  : Image.network(
                      image!,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 80),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
