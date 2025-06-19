import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedProducts = await ApiService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const LoadingDisplay();
    }

    if (errorMessage != null) {
      return ErrorDisplay(message: errorMessage!, onRetry: _loadProducts);
    }

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}
