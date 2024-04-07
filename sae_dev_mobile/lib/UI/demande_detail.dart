import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/demandeBD.dart';
import '../classes/produitBD.dart'; // Importez la classe ProduitBD
import 'home.dart'; // Importez la page home.dart ou remplacez-la par votre propre page
import '../classes/utilisateurBD.dart';
import '../classes/pretBD.dart';
import '../classes/reservationBD.dart';
import '../classes/indisponibiliteBD.dart';

class DemandeDetail extends StatelessWidget {
  final DemandeBD demande;

  DemandeDetail({required this.demande});

  @override
  Widget build(BuildContext context) {
    final produit="";
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la demande'),
      ),
      body: FutureBuilder<List<ProduitBD>>(
        future: () async {
        final utilisateur = await UtilisateurBD.getUtilisateurConnecte();
        return ProduitBD.getProduit(utilisateur?.uuidUtilisateur ?? '',demande.dateDebutDemande,demande.dateFinDemande, demande.idCategorie);
        }(),
        builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            } else {
            if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              List<ProduitBD>? produits = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('asset/image/images.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            demande.titreDemande,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            demande.descriptionDemande,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Statut : ${demande.statutDemande}',
                            style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date de publication : ${DateFormat('dd/MM/yyyy').format(demande.datePublication)}',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Date de début : ${DateFormat('dd/MM/yyyy').format(demande.dateDebutDemande)}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Date de fin : ${DateFormat('dd/MM/yyyy').format(demande.dateFinDemande)}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _showReserverDialog(context, produits); // Afficher la popup de réservation
                            },
                            child: Text('Réserver'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showReserverDialog(BuildContext context, List<ProduitBD>? produits) async {
    String? selectedObject;
    var uid = ''; // Initialisez uid avec une valeur par défaut
    final utilisateur = await UtilisateurBD.getUtilisateurConnecte();
    if (utilisateur != null) {
      uid = utilisateur.uuidUtilisateur;
    }
    if (produits == null || produits.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aucun produit disponible'),
            content: Text('Vous n\'avez aucun produit disponible pour la réservation.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fermer la popup
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélectionnez un objet'),
          content: DropdownButtonFormField<String>(
            value: selectedObject,
            items: produits
                .map<DropdownMenuItem<String>>(
                  (ProduitBD produit) => DropdownMenuItem<String>(
                value: produit.nomProduit,
                child: Text(produit.nomProduit),
              ),
            )
                .toList(),
            onChanged: (String? value) {
              selectedObject = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Sélectionnez un objet',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la popup sans rien faire
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                DateTime now = DateTime.now();
                // Réserver l'objet
                final utilisateur = await UtilisateurBD.getUtilisateurConnecte();
                var idproduit = await ProduitBD.getidProduit(uid, selectedObject ?? '');
                PretBD.ajouterPret(
                uid, // uuidDeteneur
                demande.titreDemande, // titrePret
                demande.descriptionDemande, // descriptionPret
                demande.dateDebutDemande, // dateDebutPret
                demande.dateFinDemande, // dateFinPret
                  idproduit as int,
                );
                var idPret = await PretBD.getidPret(
                    uid, // uuidDeteneur
                    demande.titreDemande, // titrePret
                    demande.descriptionDemande, // descriptionPret
                    demande.dateDebutDemande, // dateDebutPret
                    demande.dateFinDemande, // dateFinPret
                    idproduit as int, // idProduit (vous devez remplacer 0 par l'ID réel du produit)
                );
                ReservationBD.ajouterReservation(
                    uid,
                    now,
                    "en cours",
                    idPret, // Utilisez directement idPret, pas besoin de cast
                    demande.idDemande as int,
                );
                IndisponibiliteBD.ajouterIndisponibilite(
                  demande.dateDebutDemande,
                  demande.dateFinDemande,
                  idproduit as int,
                );
                DemandeBD.modifierStatutDemande(
                    demande.idDemande,
                    'Réservé'
                );
                Navigator.pop(context); // Fermer la popup
                Navigator.pop(context);
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()), // Aller à la page home.dart
                 );


              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }

}
