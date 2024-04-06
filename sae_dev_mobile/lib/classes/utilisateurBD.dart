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

  static Future<String> inscrireUtilisateur(String nomUtilisateur, String prenomUtilisateur, String pseudoUtilisateur, String mailUtilisateur, String motDePasse) async {
    try {
      // vérifie si mail existe déjà
      if (await existeUtilisateur(mailUtilisateur)) {
        print('Cet e-mail est déjà utilisé.');
        return 'Cet e-mail est déjà utilisé.';
      }
      // inscription dans l'Authentificator
      final nouvelUtilisateur = await Supabase.instance.client.auth.signUp(email: mailUtilisateur, password: motDePasse);

      // récupère l'uuid du nouvel utilisateur
      final String uuidUtilisateur = nouvelUtilisateur.user!.id!;

      // inscription dans la table UTILISATEUR
      await ajouterUtilisateur(uuidUtilisateur, nomUtilisateur, prenomUtilisateur, pseudoUtilisateur, mailUtilisateur, motDePasse);

      return "";
    } catch (error) {
      print("Erreur lors de l'inscription: $error");
      return "Mot de passe d'au moins 6 caractères";
    }
  }

  static Future<bool> existeUtilisateur(String mailUtilisateur) async {
    try {
      final response = await Supabase.instance.client.auth.getUserIdentities();
      print(response);
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

  static Future<void> ajouterUtilisateur(String uuidUtilisateur, String nomUtilisateur, String prenomUtilisateur, String pseudoUtilisateur, String mailUtilisateur, String motDePasse) async {
    try {
      await Supabase.instance.client.from('UTILISATEUR').insert({
        'uuidUtilisateur': uuidUtilisateur,
        'nomUtilisateur': nomUtilisateur,
        'prenomUtilisateur': prenomUtilisateur,
        'pseudoUtilisateur': pseudoUtilisateur,
        'mailUtilisateur': mailUtilisateur,
        'mdpUtilisateur': motDePasse
      });
    }
    catch (error) {
      print("Erreur lors de l'ajout d'un nouvel utilisateur: $error");
    }
  }

  static Future<User?> getUtilisateurConnecte() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      return user;
    }
    catch (error) {
      print("Erreur lors de la récupération de l'utilisateur connecté: $error");
      return null;
    }
  }
}
