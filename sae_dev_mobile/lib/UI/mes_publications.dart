import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pret_onglet.dart';
import '../classes/demandeBD.dart';
import '../classes/utilisateurBD.dart';
import 'profil.dart';
import 'demande_detail.dart';
import 'home.dart';

class MesPublications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mes Publications'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Demandes'),
              Tab(text: 'Prêts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenu de l'onglet Demandes
            FutureBuilder<List<DemandeBD>>(
              future: () async {
                final utilisateur = await UtilisateurBD.getUtilisateurConnecte();
                return DemandeBD.getMesDemandesPubliees(utilisateur?.uuidUtilisateur ?? '');
              }(),
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DemandeDetail(demande: demande),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(),
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
                                    'Statut : ${demande.statutDemande}',
                                    style: TextStyle(fontSize: 14, color: Colors.deepOrange),
                                  ),
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
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
            // Contenu de l'onglet Prêts
            PretPage(),
          ],
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
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    icon: Icon(Icons.home),
                    label: Text('Accueil'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
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
      ),
    );
  }
}
