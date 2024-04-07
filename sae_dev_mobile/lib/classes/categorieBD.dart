import 'package:supabase_flutter/supabase_flutter.dart';

class CategorieBD {
  final int idCategorie;
  final String nomCategorie;

  CategorieBD({
    required this.idCategorie,
    required this.nomCategorie,
  });

  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await Supabase.instance.client.from('CATEGORIE').select();
      print(response);
      if (response != null) {
        return response;
      }
      else {
        print("Erreur lors de la récupération des demandes");
        return [];
      }
    } catch (error) {
      print("Erreur lors de la récupération des demandes: $error");
      return [];
    }
  }

  static Future<void> insertCategorie(int idCategorie, String nomCategorie) async {
    try {
      await Supabase.instance.client.from('CATEGORIE').insert({
        'idCategorie': idCategorie,
        'nomCategorie': nomCategorie,
      });
    }
    catch (error) {
      print("Erreur lors de l'insertion d'une catégorie : $error");
    }
  }
}
