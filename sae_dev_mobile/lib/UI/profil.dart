import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nom',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Prénom',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
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
          ),
          Divider(), // Séparateur entre la liste et le menu
          Padding(
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
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.grey), // Bordure
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      // Retour à la page précédente
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Retour'),
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.grey), // Bordure
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      // Navigation vers la page de profil
                    },
                    icon: Icon(Icons.person),
                    label: Text('Profil'),
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.grey), // Bordure
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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