// Views/clothing_detail_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/header.dart';
import '../Models/clothing_item_model.dart';
import '../Controllers/cart_controller.dart';

class ClothingDetailPage extends StatefulWidget {
  final ClothingItem clothingItem;

  const ClothingDetailPage({
    Key? key,
    required this.clothingItem,
  }) : super(key: key);

  @override
  _ClothingDetailPageState createState() => _ClothingDetailPageState();
}

class _ClothingDetailPageState extends State<ClothingDetailPage> {
  final CartController _cartController = CartController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Détails'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.memory(
              base64Decode(widget.clothingItem.imageUrl),
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(widget.clothingItem.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Catégorie : ${widget.clothingItem.category}', style: const TextStyle(fontSize: 18)),
            Text('Taille : ${widget.clothingItem.size}', style: const TextStyle(fontSize: 18)),
            Text('Marque : ${widget.clothingItem.brand}', style: const TextStyle(fontSize: 18)),
            Text('Prix : ${widget.clothingItem.price.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _cartController.addToCart(widget.clothingItem.documentId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produit ajouté au panier !')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Échec de l\'ajout au panier : $e')),
                  );
                }
              },
              child: const Text('Ajouter au panier'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
