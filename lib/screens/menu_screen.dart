import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/models/restuarant/item_model.dart';
import 'package:api_app/models/restuarant/restaurant_model.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:api_app/services/api_keys.dart';
import 'package:api_app/services/restuarant_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MenuScreen extends StatefulWidget {
  final RestaurantModel rest;
  const MenuScreen({super.key, required this.rest});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late RestuarantApi api;
  List<ItemModel> menu = [];
  static const Color _accent = Color(0xFFB84725);
  static const Color _ink = Color(0xFF30231D);
  static const Color _muted = Color(0xFF78675C);
  static const Color _outline = Color(0xFFDCCFC3);
  static const Color _inputFill = Color(0xFFFFF8F0);
  static const Color _error = Color(0xFF963B2B);

  @override
  void initState() {
    super.initState();
    api = RestuarantApi(
      api: ApiDio(
        baseURL: ApiKeys.restuarantBaseUrl + ApiKeys.restuarantENDPOINT,
        dio: Dio(),
      ),
    );
    getMenu();
  }

  Future<dynamic> getMenu() async {
    try {
      final response = await api.getMenu(widget.rest.restaurantID);

      response.forEach((item) {
        setState(() {
          menu.add(ItemModel.fromJson(item));
        });
      });
      for (var element in menu) {
        print(element.itemName);
        print(element.itemPrice);
      }
    } on DioException catch (e) {
      ExceptionHandler.handle(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: _accent,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/shramp.png",
                fit: BoxFit.cover,
              ),
            ),
            title: Text(widget.rest.restaurantName),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.rest.restaurantName,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.rest.address,
                    style: const TextStyle(color: _muted, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = menu[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _outline),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.itemDescription,
                            style: const TextStyle(color: _muted, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${item.itemPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: _accent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              );
            }, childCount: menu.length),
          ),
        ],
      ),
    );
  }
}
