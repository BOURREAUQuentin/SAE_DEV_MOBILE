import 'package:supabase_flutter/supabase_flutter.dart';

class ReservationBD {
  final int idReservation;
  final DateTime dateReservation;
  final String statutReservation;
  final int idPret;
  final int idDemande;

  ReservationBD({
    required this.idReservation,
    required this.dateReservation,
    required this.statutReservation,
    required this.idPret,
    required this.idDemande,
  });
  static Future<void> ajouterReservation(String uuidReserveur, DateTime dateReservation, String statutReservation, int idPret, int idDemande) async {
    try {
      await Supabase.instance.client.from('RESERVATION').insert({

        'dateReservation': dateReservation.toIso8601String(),
        'statutReservation': statutReservation,
        'idPret': idPret,
        'idDemande': idDemande,
        'uuidReserveur': uuidReserveur,
      });
    }
    catch (error) {
      print("Erreur lors de l'ajout de la réservation: $error");
    }
  }

}
