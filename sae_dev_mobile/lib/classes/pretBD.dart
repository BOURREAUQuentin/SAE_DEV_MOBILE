class PretBD {
  final int idPret;
  final String titrePret;
  final String descriptionPret;
  final DateTime datePublication;
  final String statutPret;
  final DateTime dateDebutPret;
  final DateTime dateFinPret;
  final int idProduit;

  PretBD({
    required this.idPret,
    required this.titrePret,
    required this.descriptionPret,
    required this.datePublication,
    required this.statutPret,
    required this.dateDebutPret,
    required this.dateFinPret,
    required this.idProduit,
  });

  factory PretBD.fromMap(Map<String, dynamic> map) {
    return PretBD(
      idPret: map['idPret'],
      titrePret: map['titrePret'],
      descriptionPret: map['descriptionPret'],
      datePublication: DateTime.tryParse(map['datePublication'] ?? '') ?? DateTime.now(),
      statutPret: map['statutPret'],
      dateDebutPret: DateTime.tryParse(map['dateDebutPret'] ?? '') ?? DateTime.now(),
      dateFinPret: DateTime.tryParse(map['dateFinPret'] ?? '') ?? DateTime.now(),
      idProduit: map['idProduit'],
    );
  }
}
