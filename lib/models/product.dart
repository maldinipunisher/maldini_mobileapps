import 'dart:convert';

import 'package:maldini_mobileapps/configs/url_list.dart';
import 'package:maldini_mobileapps/http_parser/http_parser.dart';

// ignore_for_file: non_constant_identifier_names

class Product {
  String name;
  String picture;
  String picture_ori;
  DateTime? created_at;
  int id;
  String price;
  Product({
    required this.name,
    required this.picture,
    required this.picture_ori,
    required this.created_at,
    required this.id,
    required this.price,
  });

  static Future<List<Product?>> getAll() async {
    try {
      final parser = HttpParser();
      final response = await parser.httpGet(UrlList.getAllProducts);
      final result = <Product?>[];
      for (var product in jsonDecode(response!.body)) {
        result.add(Product.fromMap(product));
      }
      return result;
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'picture': picture,
      'picture_ori': picture_ori,
      'id': id,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      picture: map['picture'] ?? '',
      picture_ori: map['picture_ori'] ?? '',
      created_at: DateTime.tryParse(map['created_at'] ?? ""),
      id: map['id']?.toInt() ?? 0,
      price: map['price'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
