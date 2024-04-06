import 'package:supabase_flutter/supabase_flutter.dart';

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
}
