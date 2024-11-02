import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/models/cart_model.dart';

class CartController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CartModel _cartModel = CartModel();

  // Récupérer les produits du panier et le prix total du modèle
  List<String> get cartProducts => _cartModel.cartProducts;
  double get totalPrice => _cartModel.totalPrice;

  // Obtenir l'ID du document de l'utilisateur connecté
  Future<String> getLoggedInUserDocumentId() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    final userEmail = user.email!;
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      throw Exception('Document utilisateur non trouvé dans Firestore');
    }
  }

  // Ajouter un produit au panier de l'utilisateur
  Future<void> addToCart(String productId) async {
    try {
      final userId = await getLoggedInUserDocumentId();
      final userDoc = await _firestore.collection('users').doc(userId).get();

      // Vérifier le champ 'cart' et récupérer sa référence
      if (!userDoc.exists || userDoc['cart'] == null) {
        throw Exception("Référence du panier non trouvée dans le document de l'utilisateur");
      }

      final DocumentReference cartRef = userDoc['cart'];
      await cartRef.update({
        'products': FieldValue.arrayUnion([productId]),
      });

      // Mettre à jour le modèle local
      _cartModel.cartProducts.add(productId);
      await _cartModel.calculateTotalPrice(); // Recalculer le prix total
      print('Produit ajouté au panier !');
    } catch (error) {
      print('Échec de l\'ajout du produit au panier : $error');
    }
  }

  // Récupérer les articles du panier depuis Firestore
  Future<void> fetchCartItems() async {
    try {
      final userId = await getLoggedInUserDocumentId();
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists || userDoc['cart'] == null) {
        throw Exception("Référence du panier non trouvée dans le document de l'utilisateur");
      }

      final DocumentReference cartRef = userDoc['cart'];
      final cartDoc = await cartRef.get();

      if (cartDoc.exists) {
        _cartModel.cartProducts = List<String>.from(cartDoc['products'] ?? []);
        await _cartModel.calculateTotalPrice();
      } else {
        throw Exception('Document du panier n\'existe pas');
      }
    } catch (error) {
      print('Échec de la récupération des articles du panier : $error');
    }
  }

  // Retirer un article du panier de l'utilisateur
  Future<void> removeFromCart(String productId) async {
    try {
      final userId = await getLoggedInUserDocumentId();
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists || userDoc['cart'] == null) {
        throw Exception("Référence du panier non trouvée dans le document de l'utilisateur");
      }

      final DocumentReference cartRef = userDoc['cart'];
      await cartRef.update({
        'products': FieldValue.arrayRemove([productId]),
      });

      // Mettre à jour le modèle local
      _cartModel.cartProducts.remove(productId);
      await _cartModel.calculateTotalPrice();
      print('Produit retiré du panier !');
    } catch (error) {
      print('Échec du retrait du produit du panier : $error');
    }
  }

  // Récupérer les détails du produit
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final productDoc = await _firestore.collection('clothes').doc(productId).get();

      if (productDoc.exists) {
        return productDoc.data() as Map<String, dynamic>;
      } else {
        throw Exception('Produit non trouvé');
      }
    } catch (error) {
      print('Échec de la récupération des détails du produit : $error');
      rethrow;
    }
  }
}
