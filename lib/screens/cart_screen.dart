import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sepetteki toplam tutarı hesaplayan fonksiyon
  double get totalPrice {
    return widget.cartItems.fold(0, (sum, item) => sum + item.price);
  }

  // Aynı ürünleri tek kalemde göstermek için eşsiz ürünleri filtreleyen (GROUP BY mantığı) fonksiyon
  List<Product> get uniqueItems {
    final uniqueIds = <String>{};
    return widget.cartItems.where((item) => uniqueIds.add(item.id)).toList();
  }

  // Belirli bir ürünün sepette kaç tane olduğunu sayan fonksiyon
  int getItemCount(Product product) {
    return widget.cartItems.where((item) => item.id == product.id).length;
  }

  @override
  Widget build(BuildContext context) {
    final items = uniqueItems; // Ekrana sadece eşsiz olanları basacağız

    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Sepetiniz henüz boş."))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final count = getItemCount(item);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.contain),
                    title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Eksiltme Butonu
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              // Sadece 1 tanesini silmek için indexWhere ile yerini bulup siliyoruz
                              final removeIndex = widget.cartItems.indexWhere((p) => p.id == item.id);
                              if (removeIndex != -1) {
                                widget.cartItems.removeAt(removeIndex);
                              }
                            });
                          },
                        ),
                        // Aynı üründen sepetteki adedi
                        Text('$count', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        // Artırma Butonu
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              widget.cartItems.add(item);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      // Toplam Tutar ve Ödeme Alt Barı
      bottomNavigationBar: widget.cartItems.isEmpty
          ? null // Sepet boşsa alt barı gösterme
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Toplam:", style: TextStyle(fontSize: 16)),
                      Text("\$${totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text("Ödeme Yap"),
                  ),
                ],
              ),
            ),
    );
  }
}