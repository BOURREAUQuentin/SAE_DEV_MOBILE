import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../UI/home.dart';

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

  static Future<String> inscrireUtilisateur(BuildContext context, String nomUtilisateur, String prenomUtilisateur, String pseudoUtilisateur, String mailUtilisateur, String motDePasse) async {
    try {
      // inscription dans l'Authentificator
      final nouvelUtilisateur = await Supabase.instance.client.auth.signUp(email: mailUtilisateur, password: motDePasse);
      print(nouvelUtilisateur);
      print("utilisateur");
      // récupère l'uuid du nouvel utilisateur
      final String uuidUtilisateur = nouvelUtilisateur.user!.id!;

      // inscription dans la table UTILISATEUR
      await ajouterUtilisateur(uuidUtilisateur, nomUtilisateur, prenomUtilisateur, pseudoUtilisateur, mailUtilisateur, motDePasse);

      // Navigation vers la page Home et connexion de l'utilisateur
      final session = await Supabase.instance.client.auth.signInWithPassword(email: mailUtilisateur, password: motDePasse);
      if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
      else {
        print("Erreur lors de la connexion de l'utilisateur");
        return "Erreur lors de la connexion de l'utilisateur";
      }

      return "";
    }
    catch (error) {
      print("Erreur lors de l'inscription: $error");
      return error.toString();
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
