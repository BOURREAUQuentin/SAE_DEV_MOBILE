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

  static Future<List<PretBD>> getPrets(String uuidPreteur) async {
    try {
      final response = await Supabase.instance.client.from('PRET')
          .select()
          .eq('uuidPreteur', uuidPreteur)
          .eq("statutPret", "Disponible")
          .order('datePublication', ascending: false);
      if (response != null) {
        return Future.value(
            response.map((item) => PretBD.fromMap(item)).toList() as List<
                PretBD>);
      }
      else {
        print("Erreur lors de la récupération des prêts");
        return Future.value([]);
      }
    } catch (error) {
      print("Erreur lors de la récupération des prêts: $error");
      return Future.value([]);
    }
  }

  static Future<void> ajouterPret(String uuidPreteur, String titrePret,
      String descriptionPret, DateTime dateDebutPret, DateTime dateFinPret,
      int idProduit) async {
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

  static Future<int> getidPret(String uuidDeteneur, String titrePret,
      String descriptionPret, DateTime dateDebutPret, DateTime dateFinPret,
      int idProduit) async {
    try {
      final response = Supabase.instance.client.from('PRET')
          .select('idPret')
          .eq('uuidPreteur', uuidDeteneur)
          .eq('titrePret', titrePret)
          .eq('descriptionPret', descriptionPret)
          .eq("statutPret", "indisponible")
          .eq('dateDebutPret', dateDebutPret.toIso8601String())
          .eq('dateFinPret', dateFinPret.toIso8601String())
          .eq('idProduit', idProduit)
          .then((res) {
        if (res != null) {
          final List<Map<String, dynamic>> data = res as List<
              Map<String, dynamic>>;
          if (data.isNotEmpty) {
            return data[0]['idPret'] as int; // Cast to int
          } else {
            print("No data found for the given parameters");
            return 0;
          }
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

  static Future<int> getIdCategorie(int idPret) async {
    //je veut recuperer l'id du categorie qui corespond au produit de la table produit
    try {
      final response = Supabase.instance.client
          .from('PRODUIT')
          .select('idCategorie')
          .eq('idProduit', idPret)
          .then((res) {
        if (res != null) {
          final List<Map<String, dynamic>> data = res as List<
              Map<String, dynamic>>;
          return data[0]['idCategorie'] as int; // Cast to int
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

  static Future<List<Map<String, DateTime>>> getIndisponibilite(int idProduit ) async {
    try {
      final response = await Supabase.instance.client
          .from('INDISPONIBILITE')
          .select('dateDebut, dateFin')
          .eq('idProduit', idProduit);
      if (response != null && response.isNotEmpty) {
        final List<Map<String, dynamic>> data = response as List<Map<String, dynamic>>;
        return data.map((item) => {
          'dateDebut': DateTime.parse(item['dateDebut']),
          'dateFin': DateTime.parse(item['dateFin'])
        }).toList();
      } else {
        print("Erreur lors de la récupération des dates d'indisponibilité");
        return [];
      }
    }
    catch (error) {
      print("Erreur lors de la récupération des dates d'indisponibilité: $error");
      return [];
    }
  }

  static void modifierStatutPret(int idPret) async {
    try {
      await Supabase.instance.client.from('PRET').update
        ({
        'statutPret': "Indisponible",
      }).eq('idPret', idPret);
    }
    catch (error) {
      print("Erreur lors de la modification du statut du prêt: $error");
    }
  }


  static Future<List<PretBD>> getMesPretsPublies(String uuidUtilisateur) async {
    try {
      final response = await Supabase.instance.client.from('PRET')
          .select()
          .eq('uuidPreteur', uuidUtilisateur)
          .order('datePublication', ascending: false);
      print(response);
      if (response != null) {
        return response.map((item) => PretBD.fromMap(item)).toList();
      }
      else {
        print("Erreur lors de la récupération des prets");
        return [];
      }
    } catch (error) {
      print("Erreur lors de la récupération des prets: $error");
      return [];
    }
  }

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
