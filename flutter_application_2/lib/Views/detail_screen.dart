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
      body: SingleChildScrollView( // Enable scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.memory(
                  base64Decode(widget.clothingItem.imageUrl),
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.clothingItem.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Catégorie: ${widget.clothingItem.category}',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Text(
              'Taille: ${widget.clothingItem.size}',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Text(
              'Marque: ${widget.clothingItem.brand}',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Text(
              'Prix: ${widget.clothingItem.price.toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Ajouter au panier',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Retour',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
