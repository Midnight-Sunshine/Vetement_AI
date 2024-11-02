import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/Views/add_screen.dart';
import 'package:flutter_application_2/models/user_model.dart';

class UserProfileController {
  final BuildContext context;
  UserProfile? _userProfile;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  DateTime? _selectedBirthday; 
  late Future<bool> isLoading;

  UserProfileController(this.context) {
    isLoading = fetchUserProfile();
  }

  DateTime? get selectedBirthday => _selectedBirthday;

  Future<String> _getLoggedInUserDocumentId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email!;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        throw Exception('Document utilisateur introuvable dans Firestore');
      }
    } else {
      throw Exception('Utilisateur non connecté');
    }
  }

  Future<bool> fetchUserProfile() async {
    try {
      String loggedInUserId = await _getLoggedInUserDocumentId();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .get();

      if (userDoc.exists) {
        _userProfile = UserProfile(
          password: userDoc['password'],
          birthday: (userDoc['birthday'] as Timestamp).toDate(),
          address: userDoc['address'],
          postalCode: userDoc['postalCode'],
          city: userDoc['city'],
          documentId: userDoc.id,
          username: userDoc['username'],
        );

        usernameController.text = _userProfile!.username;
        addressController.text = _userProfile!.address;
        postalCodeController.text = _userProfile!.postalCode;
        cityController.text = _userProfile!.city;
        _selectedBirthday = _userProfile!.birthday;
        return false;
      } else {
        throw Exception('Document utilisateur introuvable');
      }
    } catch (e) {
      print('Erreur lors de la récupération du profil utilisateur: $e');
      return true;
    }
  }

  Future<void> selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      _selectedBirthday = picked;
    }
  }

  Future<void> updatePassword() async {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword.isNotEmpty && newPassword == confirmPassword) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await user.updatePassword(newPassword);
          if (_userProfile != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_userProfile!.documentId)
                .update({'password': newPassword});
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mot de passe mis à jour avec succès')),
          );

          newPasswordController.clear();
          confirmPasswordController.clear();
        }
      } catch (e) {
        print('Erreur lors de la mise à jour du mot de passe: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      if (!(newPassword == confirmPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
        );
      }
    }
  }

  Future<void> saveProfile() async {
    if (_userProfile != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userProfile!.documentId)
          .update({
        'username': usernameController.text,
        'birthday': Timestamp.fromDate(_selectedBirthday!),
        'address': addressController.text,
        'postalCode': postalCodeController.text,
        'city': cityController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  void addVet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddClothingItemPage()),
    );
  }
}
