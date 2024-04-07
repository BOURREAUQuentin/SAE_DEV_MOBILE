import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/pretBD.dart';
import '../classes/utilisateurBD.dart';
import 'pret_detail.dart';

class PretPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PretBD>>(
      future: () async {
        final utilisateur = await UtilisateurBD.getUtilisateurConnecte();
        return PretBD.getMesPretsPublies(utilisateur?.uuidUtilisateur ?? '');
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            final prets = snapshot.data ?? [];
            return ListView.builder(
              itemCount: prets.length,
              itemBuilder: (context, index) {
                final pret = prets[index];
                return Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PretDetail(pret: pret),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(),
                      title: Text(
                        pret.titrePret,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            pret.descriptionPret,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Statut : ${pret.statutPret}',
                            style: TextStyle(fontSize: 14, color: Colors.deepOrange),
                          ),
                          Text(
                            'Date de début : ${DateFormat('dd/MM/yyyy').format(pret.dateDebutPret)}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Date de fin : ${DateFormat('dd/MM/yyyy').format(pret.dateFinPret)}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
