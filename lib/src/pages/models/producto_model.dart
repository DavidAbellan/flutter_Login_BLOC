// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  ProductoModel({
    this.id,
    this.titulo = '',
    this.valor = 0.0,
    this.disponible = false,
    this.photo,
  });

  String id;
  String titulo;
  double valor;
  bool disponible;
  String photo;
  //factory porque devuleve un ProductoModel
  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        disponible: json["disponible"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "photo": photo,
      };
}
