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
}
