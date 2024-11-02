import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/cart_controller.dart';
import 'package:flutter_application_2/header.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController _cartController = CartController();

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() async {
    await _cartController.fetchCartItems();
    setState(() {});
  }

  void _removeItem(String productId) async {
    await _cartController.removeFromCart(productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Liste des Vêtements'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _cartController.cartProducts.isEmpty
            ? const Center(child: Text('Votre panier est vide.'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartController.cartProducts.length,
                      itemBuilder: (context, index) {
                        final productId = _cartController.cartProducts[index];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('clothes').doc(productId).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return const SizedBox();
                            }

                            final productData = snapshot.data!;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.memory(
                                  base64Decode(productData['image']),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(productData['title']),
                                subtitle: Text(
                                  'Taille: ${productData['size']}\nPrix: ${productData['price'].toStringAsFixed(2)} €',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeItem(productId),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    'Total: ${_cartController.totalPrice.toStringAsFixed(2)} €',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
