class ProduitBD {
  final int idProduit;
  final String nomProduit;
  final String descriptionProduit;
  final String lienImageProduit;
  final int idCategorie;

  ProduitBD({
    required this.idProduit,
    required this.nomProduit,
    required this.idCategorie,
    required this.descriptionProduit,
    required this.lienImageProduit,
  });

  factory ProduitBD.fromMap(Map<String, dynamic> map) {
    return ProduitBD(
      idProduit: map['idProduit'],
      nomProduit: map['nomProduit'],
      descriptionProduit: map['descriptionProduit'],
      lienImageProduit: map['lienImageProduit'],
      idCategorie: map['idCategorie'],
    );
  }
}
