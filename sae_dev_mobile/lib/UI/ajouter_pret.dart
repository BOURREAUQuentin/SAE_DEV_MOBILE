import 'package:flutter/material.dart';
import '../database/databaseLocale.dart';

class AjouterPret extends StatefulWidget {
  @override
  _AjouterPretState createState() => _AjouterPretState();
}

class _AjouterPretState extends State<AjouterPret> {
  final TextEditingController _titrePretController = TextEditingController();
  final TextEditingController _descriptionPretController = TextEditingController();
  final TextEditingController _dateDebutPretController = TextEditingController();
  final TextEditingController _dateFinPretController = TextEditingController();
  int _selectedProduitId = 1;

  List<Map<String, dynamic>> _produits = []; // Liste des produits récupérés de la base de données locale

  @override
  void initState() {
    super.initState();
    _chargerProduits();
  }

  Future<void> _chargerProduits() async {
    final produits = await DatabaseLocale.instance.getProduits();
    setState(() {
      _produits = produits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un prêt'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titrePretController,
              decoration: InputDecoration(labelText: 'Titre du prêt'),
            ),
            TextField(
              controller: _descriptionPretController,
              decoration: InputDecoration(labelText: 'Description du prêt'),
            ),
            TextField(
              controller: _dateDebutPretController,
              decoration: InputDecoration(labelText: 'Date de début (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _dateFinPretController,
              decoration: InputDecoration(labelText: 'Date de fin (YYYY-MM-DD)'),
            ),
            DropdownButtonFormField<int>(
              value: _selectedProduitId,
              onChanged: (value) {
                setState(() {
                  _selectedProduitId = value!;
                });
              },
              items: _produits.map<DropdownMenuItem<int>>((produit) {
                return DropdownMenuItem<int>(
                  value: produit['idProduit'],
                  child: Text(produit['nomProduit']),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Sélectionnez un produit'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _ajouterPret();
              },
              child: Text('Ajouter le prêt'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ajouterPret() async {
    final titrePret = _titrePretController.text;
    final descriptionPret = _descriptionPretController.text;
    final dateDebutPret = _dateDebutPretController.text;
    final dateFinPret = _dateFinPretController.text;

    // Vérification du format de date (YYYY-MM-DD)
    final dateFormat = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateFormat.hasMatch(dateDebutPret) || !dateFormat.hasMatch(dateFinPret)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Le format de la date doit être YYYY-MM-DD.'),
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

    // Vérification si la date de début est supérieure ou égale à la date actuelle
    if (DateTime.parse(dateDebutPret).isBefore(DateTime.now())) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('La date de début doit être supérieure ou égale à la date actuelle.'),
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

    // Vérification si la date de fin est supérieure à la date de début
    if (DateTime.parse(dateFinPret).isBefore(DateTime.parse(dateDebutPret))) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('La date de fin doit être postérieure à la date de début.'),
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

    // Vérifiez si tous les champs sont remplis
    if (titrePret.isEmpty || descriptionPret.isEmpty || dateDebutPret.isEmpty || dateFinPret.isEmpty) {
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

    // Vérifiez si un objet est sélectionné
    if (_selectedProduitId == 1 && _produits.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text("Veuillez sélectionner un objet existant ou créer un nouvel objet dans la page 'Mes objets'."),
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

    // insertion en locale du pret
    await DatabaseLocale.instance.insertPret(titrePret, descriptionPret, DateTime.now().toString(), "Disponible", dateDebutPret, dateFinPret, _selectedProduitId);

    // Affichez un message de succès
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Succès'),
        content: Text('Le prêt a été ajouté avec succès.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Revenir à la page précédente après l'ajout
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
    _titrePretController.dispose();
    _descriptionPretController.dispose();
    _dateDebutPretController.dispose();
    _dateFinPretController.dispose();
    super.dispose();
  }
}
