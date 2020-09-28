import 'package:fisi_army/models/alumnoprograma.dart';
import 'package:fisi_army/models/beneficio.dart';
import 'package:fisi_army/models/usuarioLogin.dart';
import 'package:fisi_army/models/recaudacionesAlumno.dart';
import 'package:http/http.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class URLS {
  static const String BASE_URL =
      'https://vidco-consultarecibos-back.herokuapp.com';
  static const String BASE_URL2 =
      'https://sigapdev2-consultarecibos-back.herokuapp.com';
}

class ApiService {
  static Future<List<AlumnoPrograma>> fetchProgamas(String dniM) async {
    Response response =
        await http.get('${URLS.BASE_URL}/alumnoprograma/buscard/$dniM');

    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = json.decode(response.body);

      print(jsonResponse);
      return jsonResponse
          .map((programa) => new AlumnoPrograma.fromJson(programa))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<UsuarioLogin> fetchLogin(
      String usuario, String password) async {
    Response response = await http.get(
        '${URLS.BASE_URL}/usuario/alumnoprograma/buscar/$usuario/$password');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UsuarioLogin.fromJson(json.decode(response.body));
    } else if (response.statusCode == 500) {
      throw Exception("Incorrect Email/Password");
    } else
      throw Exception('Error de Autenticacion');
  }

  static Future<List<RecaudacionesAlumno>> fetchRecaudaciones(
      String codAlumno) async {
    Response response = await http.get(
        '${URLS.BASE_URL}/recaudaciones/alumno/concepto/listar_cod/$codAlumno');

    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = json.decode(response.body);

      print(jsonResponse);
      return jsonResponse
          .map((json) => new RecaudacionesAlumno.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<List<Beneficio>> fetchBeneficio(String codAlumno) async {
    Response response =
        await http.get('${URLS.BASE_URL}/beneficio/listar/$codAlumno');

    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = json.decode(response.body);

      print(jsonResponse);
      return jsonResponse.map((json) => new Beneficio.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<List<dynamic>> getFiles(String tipoGrado, String anioIngreso,
      String codigoNombre, String idRecaudacion) async {
    Response response = await http.get(
        '${URLS.BASE_URL}/v1/storage/getFileFromFolder/$tipoGrado/$anioIngreso/$codigoNombre/$idRecaudacion');

    List decodedData = json.decode(response.body);
    List filesRec = List();

    if (decodedData.isNotEmpty) {
      decodedData.forEach((element) {
        filesRec.add(element['url']);
      });
      print(filesRec);
    } else {
      print('[]');
      return [];
    }

    return filesRec;
  }
}
