import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/demandeBD.dart';

class DemandeDetail extends StatelessWidget {
  final DemandeBD demande;

  DemandeDetail({required this.demande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la demande'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('chemin/vers/votre/image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    demande.titreDemande,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    demande.descriptionDemande,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Statut : ${demande.statutDemande}',
                    style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date de publication : ${DateFormat('dd/MM/yyyy').format(demande.datePublication)}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  Text(
                    'Date de début : ${DateFormat('dd/MM/yyyy').format(demande.dateDebutDemande)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Date de fin : ${DateFormat('dd/MM/yyyy').format(demande.dateFinDemande)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
