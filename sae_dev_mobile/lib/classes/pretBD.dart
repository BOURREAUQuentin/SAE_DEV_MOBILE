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

  static PretBD fromMap(Map<String, dynamic> map) {
    return PretBD(
      idPret: map['idPret'] as int,
      titrePret: map['titrePret'] as String,
      descriptionPret: map['descriptionPret'] as String,
      datePublication: DateTime.parse(map['datePublication'] as String),
      statutPret: map['statutPret'] as String,
      dateDebutPret: DateTime.parse(map['dateDebutPret'] as String),
      dateFinPret: DateTime.parse(map['dateFinPret'] as String),
      idProduit: map['idProduit'] as int,
    );
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
}