import 'package:flutter/material.dart';
import 'login.dart';
import 'package:sae_dev_mobile/classes/utilisateurBD.dart';

class Register extends StatelessWidget {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: mailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: prenomController,
              decoration: InputDecoration(
                labelText: 'Prénom',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: pseudoController,
              decoration: InputDecoration(
                labelText: 'Pseudo',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Vérifier si tous les champs sont remplis
                if (mailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    nomController.text.isEmpty ||
                    prenomController.text.isEmpty ||
                    pseudoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Veuillez remplir tous les champs."),
                    ),
                  );
                  return;
                }

                final String response = await UtilisateurBD.inscrireUtilisateur(
                  nomController.text,
                  prenomController.text,
                  pseudoController.text,
                  mailController.text,
                  passwordController.text,
                );

                if (response == "") {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response),
                    ),
                  );
                }
              },
              child: Text("S'inscrire"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Déjà un compte ? Connectez-vous !'),
            ),
          ],
        ),
      ),
    );
  }
}
