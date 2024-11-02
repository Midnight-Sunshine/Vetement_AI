import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../Models/clothing_item_model.dart';
import '../Controllers/add_clothing_controller.dart';

class AddClothingItemPage extends StatefulWidget {
  const AddClothingItemPage({super.key});

  @override
  State<AddClothingItemPage> createState() => _AddClothingItemPageState();
}

class _AddClothingItemPageState extends State<AddClothingItemPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _base64Image = '';
  Uint8List? _imageBytes;
  late AddClothingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddClothingController(context);
  }

  Future<void> _classifyImage(Uint8List imageBytes) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/classify'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'clothing.jpg',
        ),
      );

      print('Requesting URL: ${request.url}');

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final classificationResult = json.decode(responseData.body);
        setState(() {
          _categoryController.text = classificationResult['category'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la classification de l\'image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        if (result.files.single.bytes != null) {
          Uint8List imageBytes = result.files.single.bytes!;
          setState(() {
            _imageBytes = imageBytes;
            _base64Image = base64Encode(imageBytes);
          });

          await _classifyImage(imageBytes);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun fichier sélectionné.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouvel article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextFormField(
              controller: _sizeController,
              decoration: const InputDecoration(labelText: 'Taille'),
            ),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Catégorie'),
            ),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Marque'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Télécharger l\'image'),
            ),
            const SizedBox(height: 20),
            if (_imageBytes != null)
              Image.memory(
                _imageBytes!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final clothingItem = ClothingItem(
                  title: _titleController.text,
                  size: _sizeController.text,
                  category: _categoryController.text,
                  brand: _brandController.text,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                  imageUrl: _base64Image,
                  documentId: '',
                );

                _controller.addClothingItem(clothingItem);
              },
              child: const Text('Ajouter l\'article'),
            ),
          ],
        ),
      ),
    );
  }
}
