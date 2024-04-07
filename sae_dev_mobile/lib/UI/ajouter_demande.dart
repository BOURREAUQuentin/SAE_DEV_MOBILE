import 'package:flutter/material.dart';
import '../database/databaseLocale.dart';
import '../classes/categorieBD.dart';

class AjouterDemande extends StatefulWidget {
  @override
  _AjouterDemandeState createState() => _AjouterDemandeState();
}

class _AjouterDemandeState extends State<AjouterDemande> {
  final TextEditingController _titreDemandeController = TextEditingController();
  final TextEditingController _descriptionDemandeController = TextEditingController();
  final TextEditingController _dateDebutDemandeController = TextEditingController();
  final TextEditingController _dateFinDemandeController = TextEditingController();
  int _selectedCategoryId = 1; // Catégorie par défaut
  List<Map<String, dynamic>> _categories = [];

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
        title: Text('Ajouter une demande'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titreDemandeController,
              decoration: InputDecoration(labelText: 'Titre de la demande'),
            ),
            TextField(
              controller: _descriptionDemandeController,
              decoration: InputDecoration(labelText: 'Description de la demande'),
            ),
            TextField(
              controller: _dateDebutDemandeController,
              decoration: InputDecoration(labelText: 'Date de début (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _dateFinDemandeController,
              decoration: InputDecoration(labelText: 'Date de fin (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
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
              decoration: InputDecoration(labelText: 'Catégorie de la demande'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _ajouterDemande();
              },
              child: Text('Ajouter la demande'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ajouterDemande() async {
    // Récupération des valeurs des champs
    final titreDemande = _titreDemandeController.text;
    final descriptionDemande = _descriptionDemandeController.text;
    final dateDebutDemande = _dateDebutDemandeController.text;
    final dateFinDemande = _dateFinDemandeController.text;

    // Vérification du format de date (YYYY-MM-DD)
    final dateFormat = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateFormat.hasMatch(dateDebutDemande) || !dateFormat.hasMatch(dateFinDemande)) {
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
    if (DateTime.parse(dateDebutDemande).isBefore(DateTime.now())) {
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
    if (DateTime.parse(dateFinDemande).isBefore(DateTime.parse(dateDebutDemande))) {
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

    // Vérification si tous les champs sont remplis
    if (titreDemande.isEmpty || descriptionDemande.isEmpty || dateDebutDemande.isEmpty || dateFinDemande.isEmpty) {
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text("Veuillez sélectionner une catégorie existante !"),
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

    // Insertion de la demande dans la base de données
    await DatabaseLocale.instance.insertDemande(
      titreDemande,
      descriptionDemande,
      DateTime.now().toString(),
      "En attente",
      dateDebutDemande,
      dateFinDemande,
      _selectedCategoryId,
    );

    // Affichage d'un message de succès
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Succès'),
        content: Text('La demande a été ajoutée avec succès.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Retour à la page précédente après l'ajout
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Libération des ressources
    _titreDemandeController.dispose();
    _descriptionDemandeController.dispose();
    _dateDebutDemandeController.dispose();
    _dateFinDemandeController.dispose();
    super.dispose();
  }
}
