import 'package:flutter/material.dart';
import 'package:sae_dev_mobile/UI/home.dart';
import 'package:sae_dev_mobile/UI/profil.dart';
import '../classes/demandeBD.dart'; // Assurez-vous d'importer correctement la classe de demande
import '../database/databaseLocale.dart';
import 'ajouter_demande.dart'; // Assurez-vous d'importer correctement la page d'ajout de demande

class MesDemandes extends StatefulWidget {
  @override
  _MesDemandesState createState() => _MesDemandesState();
}

class _MesDemandesState extends State<MesDemandes> {
  List<DemandeBD> _demandes = [];

  @override
  void initState() {
    super.initState();
    _chargerDemandes();
  }

  Future<void> _chargerDemandes() async {
    final demandes = await DatabaseLocale.instance.getDemandesNonPubliees().then((demandes) {
      return demandes.map((demande) => DemandeBD.fromMap(demande)).toList();
    });
    print(demandes);
    setState(() {
      _demandes = demandes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Demandes'),
      ),
      body: ListView.builder(
        itemCount: _demandes.length,
        itemBuilder: (context, index) {
          final demande = _demandes[index];
          return GestureDetector(
            onTap: () {
              _afficherDialogueConfirmation(demande);
            },
            child: ListTile(
              title: Text('Titre de la demande: ${demande.titreDemande}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${demande.descriptionDemande}'),
                  Text('Date de début: ${demande.dateDebutDemande}'),
                  Text('Date de fin: ${demande.dateFinDemande}'),
                  Text('Statut: ${demande.statutDemande}'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterDemande()),
          ).then((_) {
            _chargerDemandes();
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

  Future<void> _afficherDialogueConfirmation(DemandeBD demande) async {
    bool confirme = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Voulez-vous publier cette demande en ligne dès maintenant ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Oui'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Non'),
          ),
        ],
      ),
    );

    if (confirme) {
      // Insertion en ligne (distant) de la demande
      await DemandeBD.insertDemande(demande);

      // On marque la demande comme publiée en ligne
      await DemandeBD.updateDemandePublication(demande.idDemande);

      // Rafraîchir la liste des demandes après avoir publié une demande en ligne
      await _chargerDemandes();
    }
  }
}
