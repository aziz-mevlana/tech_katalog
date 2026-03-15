import 'package:flutter/material.dart';
import '../models/product.dart';

class DetailScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onProductAdded;

  const DetailScreen({
    super.key,
    required this.product,
    required this.onProductAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView( // İçerik uzun olursa taşmasın diye kaydırılabilir yaptık
        child: Column(
          children: [
            Image.network(
              product.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.contain, // Ürün resimleri tam sığsın
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}", // Fiyatı formatlı yazdırıyoruz
                    style: const TextStyle(fontSize: 22, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onProductAdded(); // Ana sayfadaki sayacı artırır
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Sepete eklendi!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Sepete Ekle", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}