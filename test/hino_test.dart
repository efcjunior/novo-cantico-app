import 'dart:convert';

import 'package:novo_cantico_app/model/Hino.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {

 /* test('Create Hino From JSON', () async {
    final response =
        await http.get('https://hinario.herokuapp.com/hinos/21');
    Hino hino = Hino.fromJson(jsonDecode(response.body)[0]);
    expect(1, 1);
  });

  test('Check Tipo Conteudo', () async {
    final response =
    await http.get('https://hinario.herokuapp.com/hinos/21');
    Hino hino = Hino.fromJson(jsonDecode(response.body)[0]);
    expect(TipoConteudo.isHinosTitulo(hino.paragrafos[0].tipo), true);
  });*/

  test('List Indice', () async {
    final response =
    await http.get('https://hinario.herokuapp.com/hinos');
    List hinos = jsonDecode(response.body);

    Map<String,Hino> map = Map();
    hinos.forEach((element) {
      Hino hino = Hino.fromJson(element);
      map.putIfAbsent(hino.titulo, () => hino);
    });

    Hino getHino = map["1 Doxologia"];



    expect(getHino.titulo, "1 Doxologia");

  });
}