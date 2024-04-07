import 'package:supabase_flutter/supabase_flutter.dart';

class PretBD {
  final int idPret;
  final String titrePret;
  final String descriptionPret;
  final DateTime datePublication;
  final String statutPret;
  final DateTime dateDebutPret;
  final DateTime dateFinPret;
  final int idProduit;

  PretBD({
    required this.idPret,
    required this.titrePret,
    required this.descriptionPret,
    required this.datePublication,
    required this.statutPret,
    required this.dateDebutPret,
    required this.dateFinPret,
    required this.idProduit,
  });

  static Future<void> ajouterPret(String uuidPreteur, String titrePret, String descriptionPret, DateTime dateDebutPret, DateTime dateFinPret, int idProduit) async {
    try {
      await Supabase.instance.client.from('PRET').insert({

        'titrePret': titrePret,
        'descriptionPret': descriptionPret,
        'datePublication': DateTime.now().toIso8601String(),
        'statutPret': 'Disponible',
        'dateDebutPret': dateDebutPret.toIso8601String(),
        'dateFinPret': dateFinPret.toIso8601String(),
        'idProduit': idProduit,
        'uuidPreteur': uuidPreteur,
      });
      print("ajouterPret\n");
    }
    catch (error) {
      print("Erreur lors de l'ajout du prêt: $error");
    }
  }

  static Future<int> getidPret(String uuidDeteneur, String titrePret, String descriptionPret, DateTime dateDebutPret, DateTime dateFinPret, int idProduit) async {
    try {
      final response = Supabase.instance.client.from('PRET')
          .select('idPret')
          .eq('uuidPreteur', uuidDeteneur)
          .eq('titrePret', titrePret)
          .eq('descriptionPret', descriptionPret)
          .eq('dateDebutPret', dateDebutPret.toIso8601String())
          .eq('dateFinPret', dateFinPret.toIso8601String())
          .eq('idProduit', idProduit)
          .then((res) {
        if (res != null) {
          final List<Map<String, dynamic>> data = res as List<Map<String, dynamic>>;
          return data[0]['idPret'] as int; // Cast to int
        } else {
          print("Erreur lors de la récupération des prêts");
          return 0;
        }
      });

      return response;
    }
    catch (error) {
      print("Erreur lors de la récupération des prêts: $error");
      return Future.value(0);
    }
  }
}
