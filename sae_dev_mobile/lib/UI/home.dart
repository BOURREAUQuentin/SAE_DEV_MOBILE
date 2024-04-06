import 'package:flutter/material.dart';
import '../classes/demandeBD.dart';
import 'package:intl/intl.dart'; // bibliothèque intl pour formatter les dates
import 'profil.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder<List<DemandeBD>>(
        future: DemandeBD.getDemandes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              final demandes = snapshot.data ?? [];
              return ListView.builder(
                itemCount: demandes.length,
                itemBuilder: (context, index) {
                  final demande = demandes[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                      ),
                      title: Text(
                        demande.titreDemande,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            demande.descriptionDemande,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date de publication : ${DateFormat('dd/MM/yyyy').format(demande.datePublication)}',
                            style: TextStyle(fontSize: 14, color: Colors.green),
                          ),
                          Text(
                            'Date de début : ${DateFormat('dd/MM/yyyy').format(demande.dateDebutDemande)}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Date de fin : ${DateFormat('dd/MM/yyyy').format(demande.dateFinDemande)}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                    // Retour à la page d'accueil
                  },
                  icon: Icon(Icons.home),
                  label: Text('Accueil'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    // Navigation vers la page de profil
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profil()),
                    );
                  },
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
