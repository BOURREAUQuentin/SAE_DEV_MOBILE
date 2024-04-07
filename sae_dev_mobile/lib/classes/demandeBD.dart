import 'package:sae_dev_mobile/classes/utilisateurBD.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/databaseLocale.dart';

class DemandeBD {
  final int idDemande;
  final String titreDemande;
  final String descriptionDemande;
  final DateTime datePublication;
  final String statutDemande;
  final DateTime dateDebutDemande;
  final DateTime dateFinDemande;
  final int idCategorie;

  DemandeBD({
    required this.idDemande,
    required this.titreDemande,
    required this.descriptionDemande,
    required this.datePublication,
    required this.statutDemande,
    required this.dateDebutDemande,
    required this.dateFinDemande,
    required this.idCategorie,
  });

  static Future<List<DemandeBD>> getDemandes(String uuidUtilisateur) async {
    try {
      final response = await Supabase.instance.client.from('DEMANDE')
          .select()
          .neq('uuidDemandeur', uuidUtilisateur)
          .eq('statutDemande', 'En attente')
          .order('datePublication', ascending: false);
      if (response != null) {
        return response.map((item) => DemandeBD.fromMap(item)).toList();
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

  static Future<List<DemandeBD>> getMesDemandesPubliees(String uuidUtilisateur) async {
    try {
      final response = await Supabase.instance.client.from('DEMANDE')
          .select()
          .eq('uuidDemandeur', uuidUtilisateur)
          .order('datePublication', ascending: false);
      print(response);
      if (response != null) {
        return response.map((item) => DemandeBD.fromMap(item)).toList();
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

  static DemandeBD fromMap(Map<String, dynamic> map) {
    return DemandeBD(
      idDemande: map['idDemande'] ?? 0,
      titreDemande: map['titreDemande'] ?? '',
      descriptionDemande: map['descriptionDemande'] ?? '',
      datePublication: DateTime.tryParse(map['datePublication'] ?? '') ?? DateTime.now(),
      statutDemande: map['statutDemande'] ?? '',
      dateDebutDemande: DateTime.tryParse(map['dateDebutDemande'] ?? '') ?? DateTime.now(),
      dateFinDemande: DateTime.tryParse(map['dateFinDemande'] ?? '') ?? DateTime.now(),
      idCategorie: map['idCategorie'] ?? 0,
    );
  }


  static void modifierStatutDemande(int idDemande, String statutDemande) async {
    try {
      await Supabase.instance.client.from('DEMANDE').update({
        'statutDemande': statutDemande,
      }).eq('idDemande', idDemande);
    }
    catch (error) {
      print("Erreur lors de la modification du statut de la demande: $error");
    }
  }


  static Future<List<DemandeBD>> getDemandeCat(int idCategorie,List<Map<String, dynamic>>  indiponibilite) async {
    try {
      final response = Supabase.instance.client.from('DEMANDE')
          .select()
          .eq('idCategorie', idCategorie)
          .eq("statutDemande", "En attente")
          .not('dateDebutDemande', 'in', indiponibilite.map((e) => e['dateDebut']))
          .not('dateFinDemande', 'in', indiponibilite.map((e) => e['dateFin']))
          .order('datePublication', ascending: false);
      return response.then((res) {
        if (res != null && res is List) {
          return (res as List).map((item) => DemandeBD.fromMap(item)).toList();
        } else {
          return [];
        }
      });
    } catch (error) {
      print("Erreur lors de la récupération des demandes: $error");
      return Future.value([]);
    }
  }

  static Future<void> insertDemande(DemandeBD demande) async {
    try {
      DateTime datePublication = DateTime.now();
      DateTime dateDebutDemande = demande.dateDebutDemande;
      DateTime dateFinDemande = demande.dateFinDemande;
      String formattedDatePublication =
          '${datePublication.year}-${datePublication.month.toString().padLeft(2, '0')}-${datePublication.day.toString().padLeft(2, '0')}';
      String formattedDateDebutDemande =
          '${dateDebutDemande.year}-${dateDebutDemande.month.toString().padLeft(2, '0')}-${dateDebutDemande.day.toString().padLeft(2, '0')}';
      String formattedDateFinDemande =
          '${dateFinDemande.year}-${dateFinDemande.month.toString().padLeft(2, '0')}-${dateFinDemande.day.toString().padLeft(2, '0')}';
      final maxId = await getMaxIdDemande();
      int newId = maxId + 1;
      final UtilisateurBD? utilisateurBD = await UtilisateurBD.getUtilisateurConnecte();
      final uuidDemandeur = utilisateurBD?.uuidUtilisateur;
      await Supabase.instance.client.from('DEMANDE').insert({
        'idDemande': newId,
        'titreDemande': demande.titreDemande,
        'descriptionDemande': demande.descriptionDemande,
        'datePublication': formattedDatePublication,
        'statutDemande': demande.statutDemande,
        'dateDebutDemande': formattedDateDebutDemande,
        'dateFinDemande': formattedDateFinDemande,
        'idCategorie': demande.idCategorie,
        'uuidDemandeur': uuidDemandeur,
      });
    } catch (error) {
      print("Erreur lors de l'insertion d'une demande : $error");
    }
  }

  static Future<int> getMaxIdDemande() async {
    try {
      final response = await Supabase.instance.client
          .from('DEMANDE')
          .select('idDemande')
          .order('idDemande', ascending: false)
          .limit(1)
          .single();
      if (response == null) {
        print("Erreur lors de la récupération du maximum de l'ID de demande: ${response}");
        return 0;
      }
      final idMap = response as Map<String, dynamic>;
      final idDemande = idMap['idDemande'] as int?;
      return idDemande ?? 0;
    } catch (error) {
      print("Erreur lors de la récupération du maximum de l'ID de demande: $error");
      return 0;
    }
  }

  static Future<void> updateDemandePublication(int idDemande) async {
    try {
      await DatabaseLocale.instance.publierDemande(idDemande);
    } catch (error) {
      print("Erreur lors de la publication de la demande : $error");

    }
  }
}
