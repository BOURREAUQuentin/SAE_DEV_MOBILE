import 'package:supabase_flutter/supabase_flutter.dart';

class ProduitBD {
  final int idProduit;
  final String nomProduit;
  final String descriptionProduit;
  final String lienImageProduit;
  final int idCategorie;

  ProduitBD({
    required this.idProduit,
    required this.nomProduit,
    required this.idCategorie,
    required this.descriptionProduit,
    required this.lienImageProduit,
  });

  static Future<List<ProduitBD>> getProduit(String uuidUtilisateur, DateTime DateDebut, DateTime Datefin, idCategorie) async {
    try {
      final responseProduits = await Supabase.instance.client
          .from('PRODUIT')
          .select('*')
          .eq('uuidDeteneur', uuidUtilisateur)
          .eq("idCategorie", idCategorie);

      if (responseProduits == null) {
        print("Erreur lors de la récupération des produits");
        return [];
      }

      final produitsList = responseProduits.map((item) => ProduitBD.fromMap(item)).toList();

      final responseIndisponibilites = await Supabase.instance.client
          .from('INDISPONIBILITE')
          .select('idProduit')
          .or('dateDebut.lte.${Datefin.toIso8601String()},dateFin.gte.${DateDebut.toIso8601String()}');

      if (responseIndisponibilites == null) {
        print("Erreur lors de la récupération des indisponibilités");
        return [];
      }

      final idProduitsIndisponiblesList = responseIndisponibilites.map((item) => item['idProduit']).toList();

      final produitsDisponibles = produitsList.where((produit) => !idProduitsIndisponiblesList.contains(produit.idProduit)).toList();

      return produitsDisponibles;
    } catch (error) {
      print("Erreur lors de la récupération des produits: $error");
      return [];
    }
  }

  static Future<int> getidProduit(String uuidUtilisateur, String nomProduit) async {
    try {
      final response = Supabase.instance.client
          .from('PRODUIT')
          .select('idProduit')
          .eq('uuidDeteneur', uuidUtilisateur)
          .eq('nomProduit', nomProduit);

      if (response != null) {
        return response.then((res) {
          final List<Map<String, dynamic>> data = res as List<Map<String, dynamic>>;
          return data[0]['idProduit'];
        });
      } else {
        print("Erreur lors de la récupération des demandes");
        return Future.value(0);
      }
    } catch (error) {
      print("Erreur lors de la récupération des produits: $error");
      return Future.value(0);
    }
  }

  factory ProduitBD.fromMap(Map<String, dynamic> map) {
    return ProduitBD(
      idProduit: map['idProduit'],
      nomProduit: map['nomProduit'],
      descriptionProduit: map['descriptionProduit'],
      lienImageProduit: map['lienImageProduit'],
      idCategorie: map['idCategorie'],
    );
  }
}
