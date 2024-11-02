import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  List<String> cartProducts = [];
  double totalPrice = 0.0;

  Future<void> calculateTotalPrice() async {
    double total = 0.0;

    for (String productId in cartProducts) {
      final productDoc = await FirebaseFirestore.instance.collection('clothes').doc(productId).get();

      if (productDoc.exists) {
        total += (productDoc['price'] as num).toDouble();
      }
    }
    totalPrice = total;
  }
}
