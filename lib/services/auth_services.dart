import 'package:flutter/material.dart';
import 'dart:html';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'rmend.somee.com/'; //aqui va la url de nuestro login. no lleva http ni www.
  final storage = new FlutterSecureStorage();

  //este metodo puede regresar string vacio. asincrono pq iremos a la bd a leer info. pa crear usuario
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email' : email,
      'password' : password
    };

    //creamos la url
    final url = Uri.http(_baseUrl, 'api/Cuentas/Registrar');

    //conectamos, lo que regrese el back lo almacena esta variable. consume el servicio. codifica a json.
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    //decodificamos la respuesta
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    //si en decoderesp tengo token, se que regresa el token. y lo escribimos en el disp movil.
    if(decodeResp.containsKey('token')){
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    }
    else{
      //TODO: checar el msj de error que manda el back.
      decodeResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email' : email,
      'password' : password
    };

    final url = Uri.http(_baseUrl, 'api/Cuentas/Login');

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('token')){
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    }
    else{
      return decodeResp['error']['message'];
    }
  }
  //PA SABER SI todavia tiene la cuenta activa. si no existe nada regresa vacio, q significa que no esta autenticado
  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  //esto es el logout
  Future logout() async {
    await storage.delete(key: 'token');
  }


}