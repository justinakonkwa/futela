import 'package:flutter/material.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/modeles/user_provider.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/lign.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? editingField;
  final Map<String, String> _updatedUserInfo = {};

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userInfo = userProvider.currentUserData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: userInfo == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 50,
                  ),
                  AppText(
                    text: 'Aucune information utilisateur disponible.',
                    color: Colors.grey,
                  ),
                  sizedbox,
                  sizedbox,
                  NextButton(
                    height: 40,
                    color: Theme.of(context).colorScheme.primary,
                    width: 200,
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Theme.of(context).colorScheme.background,
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => LoginPage(
                          onLoginSuccess: (userData) {
                            userProvider.login(
                              userData['username'],
                              userData['password'],
                            );
                          },
                        ),
                      );
                    },
                    child: AppText(
                      text: "Connexion",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  AppTextLarge(text: 'Informations personnelles'),
                  const SizedBox(height: 20),
                  _buildInfoSection('Nom officiel',
                      userInfo['name'] ?? 'Non spécifié', userInfo),
                  _buildInfoSection('Prénom d\'usage',
                      userInfo['firstname'] ?? 'Non spécifié', userInfo),
                  _buildInfoSection('Post nom',
                      userInfo['lastname'] ?? 'Non spécifié', userInfo),
                  _buildInfoSection('Numéro de téléphone',
                      userInfo['phoneNumber'] ?? 'Non spécifié', userInfo),
                  _buildInfoSection(
                      'Genre', userInfo['gender'] ?? 'Non spécifié', userInfo),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Enregistrer les modifications'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoSection(
      String title, String value, Map<String, dynamic> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppTextLarge(text: title, size: 16),
            const Spacer(),
            if (editingField != title)
              GestureDetector(
                onTap: () {
                  setState(() {
                    editingField = title;
                  });
                },
                child: AppText(
                  text: 'Modifier',
                  color: Colors.blue,
                ),
              ),
          ],
        ),
        if (editingField == title)
          TextFormField(
            initialValue: value,
            autofocus: true,
            onChanged: (newValue) {
              _updatedUserInfo[title] = newValue;
            },
            onFieldSubmitted: (newValue) {
              setState(() {
                // Update the user info map with the new value
                userInfo[title] = newValue;
                editingField = null;
              });
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Entrez $title',
            ),
          )
        else
          AppText(
            text: value.isNotEmpty ? value : 'Non spécifié',
            color: Colors.grey,
          ),
        const SizedBox(height: 8),
        const Lign(indent: 10, endIndent: 20),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userInfo = userProvider.currentUserData;

    if (_updatedUserInfo.isNotEmpty) {
      // Assurez-vous de vérifier que les informations ont bien changé avant d'envoyer la requête.
      await UserProvider().updateUserProfile(
        context: context,
        name: _updatedUserInfo['Nom officiel'] ?? userInfo?['name'] ?? '',
        lastname: _updatedUserInfo['Post nom'] ?? userInfo?['lastname'] ?? '',
        firstName:
            _updatedUserInfo['Prénom d\'usage'] ?? userInfo?['firstname'] ?? '',
        phoneNumber: _updatedUserInfo['Numéro de téléphone'] ??
            userInfo?['phoneNumber'] ??
            '',
        gender: _updatedUserInfo['Genre'] ?? userInfo?['gender'] ?? '',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune modification apportée')),
      );
    }
  }
}
