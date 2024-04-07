import 'package:flutter/material.dart';
import '../classes/pretBD.dart';
import '../database/databaseLocale.dart';
import 'ajouter_pret.dart';

class MesPrets extends StatefulWidget {
  @override
  _MesPretsState createState() => _MesPretsState();
}

class _MesPretsState extends State<MesPrets> {
  List<PretBD> _prets = [];

  @override
  void initState() {
    super.initState();
    _chargerPrets();
  }

  Future<void> _chargerPrets() async {
    final prets = await DatabaseLocale.instance.getPrets().then((prets) {
      return prets.map((pret) => PretBD.fromMap(pret)).toList();
    });
    print(prets);
    setState(() {
      _prets = prets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Prêts'),
      ),
      body: ListView.builder(
        itemCount: _prets.length,
        itemBuilder: (context, index) {
          final pret = _prets[index];
          return ListTile(
            title: Text('Nom du prêt: ${pret.titrePret}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${pret.descriptionPret}'),
                Text('Date de début: ${pret.dateDebutPret}'),
                Text('Date de fin: ${pret.dateFinPret}'),
                Text('Statut: ${pret.statutPret}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => AjouterPret()),
          ).then((_) {
             _chargerPrets();
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
                  },
                  icon: Icon(Icons.home),
                  label: Text('Accueil'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
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
