import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../classes/utilisateurBD.dart';
import 'home.dart';
import 'login.dart';

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: FutureBuilder<UtilisateurBD?>(
        future: UtilisateurBD.getUtilisateurConnecte(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text("Une erreur s'est produite"));
            } else {
              final utilisateur = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mail: ${utilisateur.mailUtilisateur}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Prénom: ${utilisateur.prenomUtilisateur}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Nom: ${utilisateur.nomUtilisateur}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Se déconnecter de Supabase
                              await Supabase.instance.client.auth.signOut();
                              // Rediriger vers la page Login
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Login()),
                              );
                            },
                            child: Text(
                              'Se déconnecter',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        // Boutons pour les différentes actions
                        ProfilButton(
                          text: 'Mes objets',
                          icon: Icons.inventory,
                          onPressed: () {
                            // Action lorsque le bouton "Mes objets" est appuyé
                          },
                        ),
                        ProfilButton(
                          text: 'Mes prêts',
                          icon: Icons.assignment_turned_in,
                          onPressed: () {
                            // Action lorsque le bouton "Mes prêts" est appuyé
                          },
                        ),
                        ProfilButton(
                          text: 'Mes réservations',
                          icon: Icons.bookmark,
                          onPressed: () {
                            // Action lorsque le bouton "Mes réservations" est appuyé
                          },
                        ),
                        ProfilButton(
                          text: 'Mes annonces',
                          icon: Icons.note,
                          onPressed: () {
                            // Action lorsque le bouton "Mes annonces" est appuyé
                          },
                        ),
                      ],
                    ),
                    Divider(), // Séparateur entre la liste et le menu
                  ],
                ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.only(top: 3.0, bottom: 9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    // Navigation vers la page de création d'annonce
                  },
                  icon: Icon(Icons.add),
                  label: Text('Ajouter'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.home),
                  label: Text('Accueil'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person),
                  label: Text('Profil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const ProfilButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft, // Alignement à gauche
          side: BorderSide(color: Colors.grey), // Bordure
        ),
      ),
    );
  }
}
