import 'package:supabase_flutter/supabase_flutter.dart';

class CategorieBD {
  final int idCategorie;
  final String nomCategorie;

  CategorieBD({
    required this.idCategorie,
    required this.nomCategorie,
  });

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
