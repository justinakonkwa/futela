import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/lign.dart';
import 'package:futela/widgets/textfield.dart';

class CompteSubscreen extends StatefulWidget {
  const CompteSubscreen({super.key});

  @override
  _CompteSubscreenState createState() => _CompteSubscreenState();
}

class _CompteSubscreenState extends State<CompteSubscreen> {
  bool isUpdatingPassword = false; // État pour afficher ou masquer les champs
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

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
              Container(
                width: 250,
                child: buildTextField(
                  context,
                  controller: oldPasswordController,
                  placeholder: 'Ancien mot de passe',
                  isNumber: false,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                child: buildTextField(
                  context,
                  controller: newPasswordController,
                  placeholder: 'Nouveau mot de passe',
                  isNumber: false,
                ),
              ),

              const SizedBox(height: 20),
              NextButton(
                width: 250,
                color: Theme.of(context).primaryColor,
                onTap: () {
                  // Ajouter la logique de mise à jour du mot de passe ici
                  final oldPassword = oldPasswordController.text;
                  final newPassword = newPasswordController.text;

                  if (oldPassword.isEmpty || newPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez remplir tous les champs.'),
                      ),
                    );
                    return;
                  }

                  // Exemple : soumettre les données
                  print('Ancien : $oldPassword, Nouveau : $newPassword');
                  // Réinitialiser l'état après soumission
                  setState(() {
                    isUpdatingPassword = false;
                    oldPasswordController.clear();
                    newPasswordController.clear();
                  });
                },
                child: AppText(text: 'Confirmer'),
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
