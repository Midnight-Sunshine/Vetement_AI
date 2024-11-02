// home_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/clothing_item_model.dart';

class HomeController {
  Future<List<ClothingItem>> fetchClothingItems(BuildContext context) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('clothes').get();
      final List<QueryDocumentSnapshot> documents = result.docs;

      return documents.map((doc) => ClothingItem.fromDocument(doc)).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de récupération des vêtements: $e')),
      );
      return [];
    }
  }
}
