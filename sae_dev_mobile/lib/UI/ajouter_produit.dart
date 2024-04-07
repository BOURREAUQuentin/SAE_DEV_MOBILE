import 'package:flutter/material.dart';
import 'package:sae_dev_mobile/classes/categorieBD.dart';
import '../database/databaseLocale.dart';

class AjouterProduit extends StatefulWidget {
  @override
  _AjouterProduitState createState() => _AjouterProduitState();
}

class _AjouterProduitState extends State<AjouterProduit> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lienImageController = TextEditingController();
  int _selectedCategoryId = 1;

  List<Map<String, dynamic>> _categories = [];
  bool _creerCategorie = false;
  final TextEditingController _nouvelleCategorieController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerCategories();
  }

  Future<void> _chargerCategories() async {
    final categories = await CategorieBD.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom du produit'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _lienImageController,
                decoration: InputDecoration(labelText: "Lien de l'image"),
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value!;
                  });
                },
                items: _categories.map<DropdownMenuItem<int>>((category) {
                  return DropdownMenuItem<int>(
                    value: category['idCategorie'],
                    child: Text(category['nomCategorie']),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Catégorie'),
              ),
              SizedBox(height: 20),
              _creerCategorie
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nouvelleCategorieController,
                    decoration: InputDecoration(labelText: 'Nom de la nouvelle catégorie'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final nomCategorie = _nouvelleCategorieController.text;
                      if (nomCategorie.isNotEmpty) {
                        // Ajouter la nouvelle catégorie dans la base de données
                        final newCategoryId = await DatabaseLocale.instance.insertCategorie(nomCategorie);
                        // Mettre à jour la liste des catégories
                        await _chargerCategories();
                        // Sélectionner la nouvelle catégorie
                        setState(() {
                          _selectedCategoryId = newCategoryId;
                        });
                      }
                    },
                    child: Text('Valider'),
                  ),
                ],
              )
                  : ElevatedButton(
                onPressed: () {
                  // Action lorsque le bouton "Créer une catégorie" est appuyé
                  setState(() {
                    _creerCategorie = true;
                  });
                },
                child: Text('Créer une catégorie'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Action lorsque le bouton d'ajout est appuyé
                  await _ajouterProduit();
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _ajouterProduit() async {
    final nomProduit = _nomController.text;
    final descriptionProduit = _descriptionController.text;
    final lienImageProduit = _lienImageController.text;

    // Vérifiez si tous les champs sont remplis
    if (nomProduit.isEmpty || descriptionProduit.isEmpty || lienImageProduit.isEmpty) {
      // Affichez un message d'erreur si un champ est vide
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez remplir tous les champs.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Vérifiez si une catégorie est sélectionnée
    if (_selectedCategoryId == 1 && _categories.isEmpty) {
      // Affichez un message d'erreur si aucune catégorie n'est sélectionnée et qu'aucune catégorie n'existe pas encore
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez sélectionner une catégorie existante ou créer une nouvelle catégorie.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // insertion en locale du produit
    await DatabaseLocale.instance.insertProduit(nomProduit, descriptionProduit, lienImageProduit, _selectedCategoryId);

    // insertion en distant uniquement de la categorie
    await CategorieBD.insertCategorie(_selectedCategoryId, _nouvelleCategorieController.text);

    // Affichez un message de succès
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Succès'),
        content: Text('Le produit a été ajouté avec succès.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Disposez des contrôleurs de texte pour éviter les fuites de mémoire
    _nomController.dispose();
    _descriptionController.dispose();
    _lienImageController.dispose();
    _nouvelleCategorieController.dispose();
    super.dispose();
  }
}
