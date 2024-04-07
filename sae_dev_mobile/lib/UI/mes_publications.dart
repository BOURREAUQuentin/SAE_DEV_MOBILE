import 'package:flutter/material.dart';
import 'package:sae_dev_mobile/UI/mes_prets.dart';
import 'package:sae_dev_mobile/database/databaseLocale.dart';
import 'home.dart';
import 'profil.dart';
import '../classes/pretBD.dart';

class MesPublications extends StatefulWidget {
  @override
  _MesPublicationsState createState() => _MesPublicationsState();
}

class _MesPublicationsState extends State<MesPublications> {
  List<PretBD> _publications = [];

  @override
  void initState() {
    super.initState();
    _chargerPublications();
  }

  Future<void> _chargerPublications() async {
    final publications = await DatabaseLocale.instance.getPublications().then((publications) {
      return publications.map((publication) => PretBD.fromMap(publication)).toList();
    });
    setState(() {
      _publications = publications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Publications'),
      ),
      body: ListView.builder(
        itemCount: _publications.length,
        itemBuilder: (context, index) {
          final publication = _publications[index];
          return ListTile(
            title: Text('Titre: ${publication.titrePret}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${publication.descriptionPret}'),
                Text('Date de début: ${publication.dateDebutPret}'),
                Text('Date de fin: ${publication.dateFinPret}'),
                Text('Statut: ${publication.statutPret}'),
              ],
            ),
          );
        },
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Profil()),
                    );
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
