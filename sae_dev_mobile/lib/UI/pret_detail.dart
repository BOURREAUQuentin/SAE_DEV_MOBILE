import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/pretBD.dart';

class PretDetail extends StatelessWidget {
  final PretBD pret;

  PretDetail({required this.pret});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail du Prêt'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre du prêt: ${pret.titrePret}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${pret.descriptionPret}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Statut: ${pret.statutPret}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Date de début: ${DateFormat('dd/MM/yyyy').format(pret.dateDebutPret)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Date de fin: ${DateFormat('dd/MM/yyyy').format(pret.dateDebutPret)}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
