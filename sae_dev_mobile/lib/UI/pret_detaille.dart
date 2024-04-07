import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sae_dev_mobile/classes/demandeBD.dart';
import '../classes/pretBD.dart';
import '../classes/reservationBD.dart';
import '../classes/utilisateurBD.dart';
import 'home.dart';

class PretDetaille extends StatelessWidget {
  final PretBD pret;

  PretDetaille({required this.pret});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Prêt'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/image/images.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              pret.titrePret,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              pret.descriptionPret,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Statut : ${pret.statutPret}',
              style: TextStyle(fontSize: 16, color: Colors.deepOrange),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Date de début : ${DateFormat('dd/MM/yyyy').format(pret.dateDebutPret)}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              'Date de fin : ${DateFormat('dd/MM/yyyy').format(pret.dateFinPret)}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: Text('Confirmer le prêt'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) async {
    final utilisateur = await UtilisateurBD.getUtilisateurConnecte();
    if (utilisateur == null) {
      return; // Gérer le cas où l'utilisateur n'est pas connecté
    }

    var idCategori = await PretBD.getIdCategorie(pret.idProduit);
    var indisponibilite = await PretBD.getIndisponibilite(pret.idProduit);
    print(indisponibilite);
    var demandes = await DemandeBD.getDemandeCat(idCategori, indisponibilite);

    if (demandes.isEmpty) {
      // Si la liste de demandes est vide, affichez un message et retournez
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aucune demande disponible'),
            content: Text('Il n\'y a pas de demande disponible pour ce produit.'),
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

    var idDemande = 0;
    DateTime now = DateTime.now();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer le prêt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Voulez-vous confirmer le prêt de "${pret.titrePret}" pour la demande ?'),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                items: demandes
                    .map((demande) => DropdownMenuItem<String>(
                  value: demande.idDemande.toString(),
                  child: Text(demande.titreDemande),
                ))
                    .toList(),
                onChanged: (String? value) {
                  // Mettez ici la logique pour gérer la sélection de la demande
                  print('Demande sélectionnée : $value');
                  idDemande = int.parse(value!);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Sélectionnez une demande',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la popup
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                var idPret = pret.idPret;
                print(idDemande);
                DemandeBD.modifierStatutDemande(
                  idDemande,
                  'Réservé',
                );
                ReservationBD.ajouterReservation(
                  utilisateur.uuidUtilisateur,
                  now,
                  "en cours",
                  idPret, // Utilisez directement idPret, pas besoin de cast
                  idDemande,
                );
                PretBD.modifierStatutPret(
                  idPret,
                );
                Navigator.pop(context); // Fermer la popup
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), // Aller à la page home.dart
                );
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }



}
