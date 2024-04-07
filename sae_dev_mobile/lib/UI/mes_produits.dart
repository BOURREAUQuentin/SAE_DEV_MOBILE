import 'package:flutter/material.dart';
import 'package:sae_dev_mobile/UI/profil.dart';
import '../database/databaseLocale.dart';
import '../classes/produitBD.dart';
import 'ajouter_produit.dart';
import 'detail_produit.dart';
import 'home.dart';

class MesProduits extends StatefulWidget {
  @override
  _MesProduitsState createState() => _MesProduitsState();
}

class _MesProduitsState extends State<MesProduits> {
  List<ProduitBD> _produits = [];

  @override
  void initState() {
    super.initState();
    _chargerProduits();
  }

  Future<void> _chargerProduits() async {
    final produits = await DatabaseLocale.instance.getProduits().then((produits) {
      return produits.map((produit) => ProduitBD.fromMap(produit)).toList();
    });
    setState(() {
      _produits = produits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Produits'),
      ),
      body: ListView.builder(
        itemCount: _produits.length,
        itemBuilder: (context, index) {
          final produit = _produits[index];
          return ListTile(
            title: Text(produit.nomProduit),
            subtitle: Text(produit.descriptionProduit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailProduit(produit: produit),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterProduit()),
          ).then((_) {
            _chargerProduits();
          });
        },
        child: Icon(Icons.add),
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
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()));
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
                        MaterialPageRoute(builder: (context) => Profil()));
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
