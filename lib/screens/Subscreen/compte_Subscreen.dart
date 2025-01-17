import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/lign.dart';
import 'package:futela/widgets/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompteSubscreen extends StatefulWidget {
  const CompteSubscreen({super.key});

  @override
  _CompteSubscreenState createState() => _CompteSubscreenState();
}

class _CompteSubscreenState extends State<CompteSubscreen> {
  bool isUpdatingPassword = false; // État pour afficher ou masquer les champs
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _updatePassword(String oldPassword, String newPassword) async {
    const String apiUrl =
        "http://cpanel.futela.com/api/app/auth/security/password";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print(token);
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Aucun jeton trouvé. Veuillez vous reconnecter.")),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Réinitialiser les champs si la mise à jour réussie
        oldPasswordController.clear();
        newPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mot de passe mis à jour avec succès.")),
        );
      } else {
        final errorMessage =
            json.decode(response.body)['error'] ?? "Erreur inconnue";

        // Gestion des erreurs spécifiques
        if (errorMessage.contains("Mot de passe incorrect")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("L'ancien mot de passe est incorrect."),
            ),
          );
        } else if (errorMessage.contains("Nouveau mot de passe trop faible")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Le nouveau mot de passe est trop faible."),
            ),
          );
        } else if (errorMessage.contains("Mot de passe similaire à l'ancien")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Le nouveau mot de passe ne peut pas être similaire à l'ancien.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur : $errorMessage")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Une erreur s'est produite : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextLarge(text: 'Sécurité'),
            const SizedBox(height: 50),
            _buildOption(
              title: 'Mot de passe',
              subtitle: isUpdatingPassword ? 'Annuler' : 'Mettre à jour',
              onTap: () {
                setState(() {
                  isUpdatingPassword = !isUpdatingPassword;
                });
              },
            ),
            if (isUpdatingPassword) ...[
              const SizedBox(height: 20),
              buildTextField(
                context,
                controller: oldPasswordController,
                placeholder: 'Ancien mot de passe',
                isNumber: false,
              ),
              const SizedBox(height: 20),
              buildTextField(
                context,
                controller: newPasswordController,
                placeholder: 'Nouveau mot de passe',
                isNumber: false,
              ),
              const SizedBox(height: 20),
              NextButton(
                color: Theme.of(context).primaryColor,
                onTap: isLoading
                    ? null
                    : () {
                        final oldPassword = oldPasswordController.text;
                        final newPassword = newPasswordController.text;

                        if (oldPassword.isEmpty || newPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Veuillez remplir tous les champs.'),
                            ),
                          );
                          return;
                        }

                        _updatePassword(oldPassword, newPassword);
                      },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : AppText(
                        text: 'Confirmer',
                      ),
              ),
            ],
            const SizedBox(height: 30),
            _buildOption(
              title: 'Désactiver son compte',
              subtitle: 'Désactivé',
              onTap: () {
                // Action pour "Désactiver son compte"
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextLarge(text: title, size: 16),
              AppText(text: subtitle),
            ],
          ),
          sizedbox,
          Lign(indent: 20, endIndent: 0),
        ],
      ),
    );
  }
}
