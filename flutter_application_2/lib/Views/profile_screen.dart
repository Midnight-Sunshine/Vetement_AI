import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_application_2/Controllers/user_profile_controller.dart';

class UserProfilePage extends StatefulWidget {
  final UserProfileController controller;

  const UserProfilePage({Key? key, required this.controller}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await widget.controller.saveProfile();
              await widget.controller.updatePassword();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Valider'),
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: widget.controller.isLoading,
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
                    readOnly: true,
                    controller: widget.controller.usernameController,
                    decoration: const InputDecoration(labelText: 'Login'),
                  ),
                  TextFormField(
                    controller: widget.controller.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await widget.controller.selectBirthday(context);
                      setState(() {}); 
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Anniversaire',
                          hintText: widget.controller.selectedBirthday?.toLocal().toString().split(' ')[0] ?? 'Sélectionnez une date',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: widget.controller.selectedBirthday != null
                              ? widget.controller.selectedBirthday!.toLocal().toString().split(' ')[0]
                              : '',
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: widget.controller.addressController,
                    decoration: const InputDecoration(labelText: 'Adresse'),
                  ),
                  TextFormField(
                    controller: widget.controller.postalCodeController,
                    decoration: const InputDecoration(labelText: 'Code Postal'),
                    keyboardType: TextInputType.number, 
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly 
                    ],
                  ),
                  TextFormField(
                    controller: widget.controller.cityController,
                    decoration: const InputDecoration(labelText: 'Ville'),
                  ),
                  ElevatedButton(
                    onPressed: widget.controller.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Se Déconnecter'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      widget.controller.addVet();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
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
