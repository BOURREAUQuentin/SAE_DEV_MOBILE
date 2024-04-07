import 'package:sae_dev_mobile/classes/utilisateurBD.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/databaseLocale.dart';

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

  factory PretBD.fromMap(Map<String, dynamic> map) {
    return PretBD(
      idPret: map['idPret'],
      titrePret: map['titrePret'],
      descriptionPret: map['descriptionPret'],
      datePublication: DateTime.tryParse(map['datePublication'] ?? '') ?? DateTime.now(),
      statutPret: map['statutPret'],
      dateDebutPret: DateTime.tryParse(map['dateDebutPret'] ?? '') ?? DateTime.now(),
      dateFinPret: DateTime.tryParse(map['dateFinPret'] ?? '') ?? DateTime.now(),
      idProduit: map['idProduit'],
    );
  }

  static Future<void> insertPret(PretBD pret) async {
    try {
      DateTime datePublication = DateTime.now();
      DateTime dateDebutPret = pret.dateDebutPret;
      DateTime dateFinPret = pret.dateFinPret;
      String formattedDatePublication = '${datePublication
          .year}-${datePublication.month.toString().padLeft(
          2, '0')}-${datePublication.day.toString().padLeft(2, '0')}';
      String formattedDateDebutPret = '${dateDebutPret.year}-${dateDebutPret
          .month.toString().padLeft(2, '0')}-${dateDebutPret.day.toString()
          .padLeft(2, '0')}';
      String formattedDateFinPret = '${dateFinPret.year}-${dateFinPret.month
          .toString().padLeft(2, '0')}-${dateFinPret.day.toString().padLeft(
          2, '0')}';
      final maxId = await getMaxIdPret();
      int newId = maxId + 1;
      final UtilisateurBD? utilisateurBD = await UtilisateurBD.getUtilisateurConnecte();
      final uuidPreteur = utilisateurBD?.uuidUtilisateur;
      await Supabase.instance.client.from('PRET').insert({
        'idPret': newId,
        'titrePret': pret.titrePret,
        'descriptionPret': pret.descriptionPret,
        'datePublication': formattedDatePublication,
        'statutPret': pret.statutPret,
        'dateDebutPret': formattedDateDebutPret,
        'dateFinPret': formattedDateFinPret,
        'idProduit': pret.idProduit,
        'uuidPreteur': uuidPreteur,
      });
    }
    catch (error) {
      print("Erreur lors de l'insertion d'un pret : $error");
    }
  }

  static Future<int> getMaxIdPret() async {
    try {
      final response = await Supabase.instance.client
          .from('PRET')
          .select('idPret')
          .order('idPret', ascending: false)
          .limit(1)
          .single();
      if (response == null) {
        print("Erreur lors de la récupération du maximum de l'ID de prêt: ${response}");
        return 0;
      }
      final idMap = response as Map<String, dynamic>;
      final idPret = idMap['idPret'] as int?;
      return idPret ?? 0;
    } catch (error) {
      print("Erreur lors de la récupération du maximum de l'ID de prêt: $error");
      return 0;
    }
  }

  static Future<void> updatePretPublication(int idPret) async {
    try {
      await DatabaseLocale.instance.publierPret(idPret);
    }
    catch (error) {
      print("Erreur lors de la publication du prêt : $error");
    }
  }
}
