import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/clothing_item_model.dart';

class AddClothingController {
  final BuildContext context;

  AddClothingController(this.context);

  Future<void> addClothingItem(ClothingItem clothingItem) async {
    if (clothingItem.title.isEmpty ||
        clothingItem.size.isEmpty ||
        clothingItem.category.isEmpty ||
        clothingItem.brand.isEmpty ||
        clothingItem.price <= 0 ||
        clothingItem.imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs correctement.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('clothes').add({
        'title': clothingItem.title,
        'size': clothingItem.size,
        'category': clothingItem.category,
        'brand': clothingItem.brand,
        'price': clothingItem.price,
        'image': clothingItem.imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vêtement ajouté avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l’ajout du vêtement: $e')),
      );
    }
  }
}
