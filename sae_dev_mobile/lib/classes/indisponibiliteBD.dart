import 'package:supabase_flutter/supabase_flutter.dart';

class IndisponibiliteBD {
  final int idIndisponibilite;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int idProduit;

  IndisponibiliteBD({
    required this.idIndisponibilite,
    required this.dateDebut,
    required this.dateFin,
    required this.idProduit,
  });
  static void ajouterIndisponibilite(DateTime dateDebut, DateTime dateFin, int idProduit) async {
    try {
      await Supabase.instance.client.from('INDISPONIBILITE').insert({
        'dateDebut': dateDebut.toIso8601String(),
        'dateFin': dateFin.toIso8601String(),
        'idProduit': idProduit,
      });
    }
    catch (error) {
      print("Erreur lors de l'ajout de l'indisponibilité: $error");
    }
  }
}
