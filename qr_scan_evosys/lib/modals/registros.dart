// To parse this JSON data, do
//
//     final registros = registrosFromJson(jsonString);

import 'dart:convert';

Registros registrosFromJson(String str) => Registros.fromJson(json.decode(str));

String registrosToJson(Registros data) => json.encode(data.toJson());

class Registros {
  String? nombre;
  String? telefono;
  String? email;
  String? org;

  Registros({
    this.nombre,
    this.telefono,
    this.email,
    this.org,
  });

  factory Registros.fromJson(Map<String, dynamic> json) => Registros(
        nombre: json["nombre"],
        telefono: json["telefono"],
        email: json["email"],
        org: json["organizacion"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "telefono": telefono,
        "email": email,
        "organizacion": org,
      };
}
