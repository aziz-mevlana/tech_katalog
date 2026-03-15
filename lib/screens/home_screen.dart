import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<Product> sepetListesi = [];
  
  List<String> categories = ['Tümü'];
  String selectedCategory = 'Tümü';
  String searchQuery = '';
  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    const url = 'https://fakestoreapi.com/products';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          allProducts = data.map((json) => Product.fromJson(json)).toList();
          filteredProducts = List.from(allProducts);
          

          final uniqueCategories = allProducts.map((p) => p.category).toSet().toList();
          categories.addAll(uniqueCategories);
          
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Veri çekilirken hata oluştu: $e");
    }
  }


  void filterProducts() {
    setState(() {
      filteredProducts = allProducts.where((product) {

        final matchesCategory = selectedCategory == 'Tümü' || product.category == selectedCategory;

        final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
        
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tech & Gadget Hub"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cartItems: sepetListesi),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              child: Center(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.shopping_cart, size: 28),
                    ),
                    if (sepetListesi.isNotEmpty)
                      CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${sepetListesi.length}',
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Ürün ara...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                      filterProducts(); 
                    },
                  ),
                ),

                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'banner.png',
                      width: double.infinity,
                      // height: 140, -> BU SATIRI TAMAMEN SİLİYORUZ
                      fit: BoxFit.fitWidth, // Resmi kırpmadan genişliğe tam oturtur
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          color: Colors.grey[300],
                          child: const Center(child: Text('Banner Yüklenemedi (pubspec.yaml kontrol et)')),
                        );
                      },
                    ),
                  ),
                ),
                

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(category.toUpperCase(), style: const TextStyle(fontSize: 12)),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            if (selected) {
                              selectedCategory = category;
                              filterProducts();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                Expanded(
                  child: filteredProducts.isEmpty
                    ? const Center(child: Text("Aradığınız kriterlere uygun ürün bulunamadı."))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          product: product,
                                          onProductAdded: () {
                                            setState(() {
                                              sepetListesi.add(product);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              sepetListesi.add(product);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          child: const Text("Ekle"),
                                        ),
                                      ),
                                    ],
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
    );
  }
}