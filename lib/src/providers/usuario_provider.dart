import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyDX0fUMLpewleys1Z2iHbWcBSyxuVAdTac';
  final _prefs = new PreferenciasUsuario();

  Future login(String email, String pass) async {
    final authData = {
      'email': email,
      'password': pass,
      'returnSecureToken': true
    };
    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));
    //

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    //print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future nuevoUsuario(String email, String pass) async {
    final authData = {
      'email': email,
      'password': pass,
      'returnSecureToken': true
    };
    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));
    //signInWithPassword

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    //print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      //_guardar token en storage
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}
