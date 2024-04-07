import 'package:flutter/material.dart';
import '../classes/produitBD.dart';

class DetailProduit extends StatelessWidget {
  final ProduitBD produit;

  DetailProduit({required this.produit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail du Produit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom du produit: ${produit.nomProduit}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${produit.descriptionProduit}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Ajoutez ici d'autres informations sur le produit si nécessaire
          ],
        ),
      ),
    );
  }
}
