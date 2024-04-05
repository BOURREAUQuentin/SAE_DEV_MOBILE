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

  static Future<bool> inscrireUtilisateur(String mailUtilisateur, String motDePasse) async {
    try {
      // Vérifie si le mail existe déjà
      if (await existeUtilisateur(mailUtilisateur)) {
        print('Cet e-mail est déjà utilisé.');
        return false;
      }

      // Mail n'existe pas, inscrire l'utilisateur
      await Supabase.instance.client.auth.signUp(email: mailUtilisateur, password: motDePasse);
      return true;
    } catch (error) {
      print("Erreur lors de l'inscription: $error");
      return false;
    }
  }

  static Future<bool> existeUtilisateur(String mailUtilisateur) async {
    try {
      final response = await Supabase.instance.client.auth.getUserIdentities();
      for (var identity in response) {
        Map<String, dynamic>? identityData = identity.identityData;
        if (identityData != null) {
          String? email = identityData['email'];
          if (email != null && email == mailUtilisateur) {
            return true;
          }
        }
      }
      return false;
    }
    catch (error) {
      print("Erreur lors de la vérification de l'existence de l'utilisateur: $error");
      return true;
    }
  }
}
