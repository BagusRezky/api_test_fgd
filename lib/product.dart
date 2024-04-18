import 'dart:convert';

import 'package:api_test_fgd/models/model.dart';
import 'package:api_test_fgd/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));
    if (response.statusCode == 200) {
      print(response.statusCode); // Perubahan kunci di sini
      print(response.body); // Perubahan kunci di sini
      final List<dynamic> jsonData =
          jsonDecode(response.body) as List<dynamic>; // Perubahan kunci di sini
      setState(() {
        products = jsonData
            .map((productJson) => ProductModel.fromJson(productJson))
            .toList();
        // Mengambil 5 data pertama
        products = products.take(5).toList();
      });
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  void navigateToProductDetail(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Produk'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.title ?? ''),
            // subtitle: Text(product.description ?? ''),
            trailing: Text('\$${product.price ?? 0}'),
            onTap: () => navigateToProductDetail(product),
          );
        },
      ),
    );
  }
}
