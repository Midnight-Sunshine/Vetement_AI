import 'package:flutter/material.dart';
import 'package:flutter_application_2/Controllers/user_profile_controller.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfileController controller;

  const UserProfilePage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await controller.saveProfile(); // Enregistrer les modifications du profil
              await controller.updatePassword(); // Mettre à jour le mot de passe si applicable
            },
            child: const Text('Valider'),
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: controller.isLoading,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.usernameController,
                    decoration: const InputDecoration(labelText: 'Nom d’utilisateur'),
                  ),
                  TextFormField(
                    controller: controller.newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Nouveau Mot de Passe'),
                  ),
                  TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirmer le Mot de Passe'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await controller.selectBirthday(context); // Ouvrir le sélecteur de date
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date de Naissance',
                          hintText: controller.selectedBirthday?.toLocal().toString().split(' ')[0] ?? 'Sélectionnez une date',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: controller.selectedBirthday?.toLocal().toString().split(' ')[0] ?? '',
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: controller.addressController,
                    decoration: const InputDecoration(labelText: 'Adresse'),
                  ),
                  TextFormField(
                    controller: controller.postalCodeController,
                    decoration: const InputDecoration(labelText: 'Code Postal'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: controller.cityController,
                    decoration: const InputDecoration(labelText: 'Ville'),
                  ),
                  ElevatedButton(
                    onPressed: controller.logout,
                    child: const Text('Se Déconnecter'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      controller.addVet(); // Enregistrer les modifications du profil
                    },
                    child: const Text('Ajouter Vêtement'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
