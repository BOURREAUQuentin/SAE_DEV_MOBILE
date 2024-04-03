import 'package:sae_dev_mobile/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UtilisateurBD {
  final String idUtilisateur;
  final String prenomUtilisateur;
  final String nomUtilisateur;
  final String pseudoUtilisateur;
  final String mailUtilisateur;
  final String mdpUtilisateur;

  UtilisateurBD({
    required this.idUtilisateur,
    required this.prenomUtilisateur,
    required this.nomUtilisateur,
    required this.pseudoUtilisateur,
    required this.mailUtilisateur,
    required this.mdpUtilisateur,
  });

  static Future<bool> utilisateurExiste(String nomUtilisateur, String motDePasse) async {
    final response = await MyApp.client
        .from("UTILISATEUR")
        .select();

    return false;
  }
}
