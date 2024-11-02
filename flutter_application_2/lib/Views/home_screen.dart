import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Views/detail_screen.dart';
import 'package:flutter_application_2/Views/cart_screen.dart';
import 'package:flutter_application_2/header.dart';
import 'package:flutter_application_2/Views/profile_screen.dart';
import '../Models/clothing_item_model.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/user_profile_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeController _controller = HomeController();
  int _selectedIndex = 0;
  List<ClothingItem> _clothingItems = [];

  @override
  void initState() {
    super.initState();
    _loadClothingItems();
  }

  Future<void> _loadClothingItems() async {
    final items = await _controller.fetchClothingItems(context);
    setState(() {
      _clothingItems = items;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(controller: UserProfileController(context)),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Liste des Vêtements'),
      body: _buildClothingList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Acheter'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildClothingList() {
    if (_clothingItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _clothingItems.length,
      itemBuilder: (context, index) {
        final item = _clothingItems[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: _buildImage(item.imageUrl),
            title: Text(item.title),
            subtitle: Text('Taille: ${item.size}\nPrix: ${item.price.toStringAsFixed(2)} €'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClothingDetailPage(
                    clothingItem: item,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImage(String base64String) {
    try {
      Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes, width: 50, height: 50, fit: BoxFit.cover);
    } catch (e) {
      return const Icon(Icons.error, size: 50);
    }
  }
}