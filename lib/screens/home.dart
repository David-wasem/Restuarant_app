import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/models/restuarant/restaurant_model.dart';
import 'package:api_app/screens/login.dart';
import 'package:api_app/screens/menu_screen.dart';
import 'package:api_app/services/api_keys.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:api_app/services/restuarant_api.dart';
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
  late RestuarantApi _api;
  TextEditingController searchController = TextEditingController();
  static const Color _accent = Color(0xFFB84725);
  static const Color _ink = Color(0xFF30231D);
  static const Color _muted = Color(0xFF78675C);
  static const Color _outline = Color(0xFFDCCFC3);
  static const Color _inputFill = Color(0xFFFFF8F0);
  final categries = {
    'Burger': 'assets/images/Burger.png',
    'Hotdog': 'assets/images/Hotdog.png',
    'Kimbab': 'assets/images/Kimbab.png',
    'Salmon Steak': 'assets/images/Salmon_Steak.png',
    'Steak': 'assets/images/Steak.png',
  };
  List<RestaurantModel> search_res = [];
  bool isSearching = false;
  bool hasSearched = false;
  bool isFound = false;

  void _clearSearch() {
    searchController.clear();
    setState(() {
      search_res.clear();
      hasSearched = false;
      isFound = false;
      isSearching = false;
    });
  }
  @override
  void initState() {
    super.initState();
    _api = RestuarantApi(
      api: ApiDio(
        baseURL: ApiKeys.restuarantBaseUrl + ApiKeys.restuarantENDPOINT,
        dio: Dio(),
      ),
    );
  }

  MaterialPageRoute<void> _loginRoute() =>
      MaterialPageRoute<void>(builder: (context) => const LoginPage());

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFCF8),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Color(0xFFFFE7CF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.logout_rounded, color: _accent, size: 28),
        ),
        title: const Text(
          'Leaving so soon?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _ink,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        actions: [
          SizedBox(
            width: 110,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: _ink,
                side: const BorderSide(color: _outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Stay'),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Log out'),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushAndRemoveUntil(context, _loginRoute(), (route) => false);
    }
  }

  Future<void> _searchCategory(String category) async {
    final query = category.trim();
    if (query.isEmpty) {
      _clearSearch();
      return;
    }

    setState(() {
      search_res.clear();
      hasSearched = true;
      isSearching = true;
      isFound = false;
    });

    try {
      final response = await _api.getCategory(query);
      final results = <RestaurantModel>[];

      for (final item in response) {
        results.add(RestaurantModel.fromJson(item));
      }

      setState(() {
        search_res.clear();
        search_res.addAll(results);
        isFound = search_res.isNotEmpty;
        isSearching = false;
      });
    } on DioException catch (e) {
      setState(() {
        isSearching = false;
        isFound = false;
      });
      print(ExceptionHandler.handle(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                colors: [_accent, const Color.fromARGB(255, 240, 141, 111)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome, ${widget.name}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _confirmLogout();
                        },
                        icon: Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    ' What are you craving today? 🍽',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(200, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 150),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                TextField(
                  controller: searchController,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: _outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: _accent),
                    ),
                    hintText:
                        'Search restaurants... Ex: "Rajasthani, Gujarati"',
                    hintStyle: TextStyle(color: _muted),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: (searchController.text.isEmpty)
                        ? null
                        : IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: _clearSearch,
                          ),
                    filled: true,
                    fillColor: _inputFill,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _searchCategory,
                ),
                if (isSearching)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                else if (hasSearched && !isFound)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No results found for "${searchController.text}"',
                      style: TextStyle(color: _muted),
                    ),
                  )
                else if (search_res.isNotEmpty)
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuScreen(rest: search_res[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _inputFill,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _outline),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                search_res[index].restaurantName,
                                style: TextStyle(
                                  color: _ink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                search_res[index].address,
                                style: TextStyle(
                                  color: _ink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: search_res.length,
                    shrinkWrap: true,
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _ink,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'See all',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: categries.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _inputFill,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _outline),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              categries.values.elementAt(index),
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 8),
                            Text(
                              categries.keys.elementAt(index),
                              style: TextStyle(
                                color: _ink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
