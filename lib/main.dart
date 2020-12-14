import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/Hino.dart';

void main() {
  runApp(HinarioApp());
}

class HinarioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hinário Novo Cântico",
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      home: IndiceWidget()
    );
  }
}

class IndiceWidget extends StatefulWidget {

  @override
  _IndiceState createState() => _IndiceState();

  void _navegaParaHinoTela(BuildContext context, hinoEscolhido) {
    Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => HinoWidget(hino: hinoEscolhido)
        ));
  }
}

class _IndiceState extends State<IndiceWidget> {

  Future<Map<String,Hino>> _indiceHinos;

  @override
  void initState() {
    super.initState();
    _indiceHinos = _carregaIndiceHinos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Índice"),),
      body: _getIndices(),
    );
  }

  Widget _getIndices() {
    return FutureBuilder(
      future: _indiceHinos,
      builder: (context, AsyncSnapshot<Map<String,Hino>> snapshot) {
        if (snapshot.hasData) {
          Map<String,Hino> map = Map.from(snapshot.data);
          List<String> indices = map.keys.toList();

          return ListView.builder(
            itemCount: map.length,
            itemBuilder: (context, index) {
              String indice = map[indices[index]].titulo;
              return Card(
                child: ListTile(
                  title: Text('$indice'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    widget._navegaParaHinoTela(context, map[indices[index]]);
                  },
                ),
              );
              }
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      }
    );
  }

  Future<Map<String,Hino>> _carregaIndiceHinos() async {
    final resposta =
    await http.get("https://hinario.herokuapp.com/hinos");

    Map<String,Hino> map = Map();
    if (resposta.statusCode == 200) {
      (jsonDecode(resposta.body) as List).forEach((element) {
        Hino hino = Hino.fromJson(element);
        map.putIfAbsent(hino.titulo, () => hino);
      });
    } else {
      throw Exception('Erro ao carregar Mapa Índice Hinos');
    }
    return map;
  }

}

class HinoWidget extends StatefulWidget {
  final Hino hino;

  HinoWidget({Key key, @required this.hino}) : super(key:key);

  @override
  _HinoState createState() => _HinoState();
}

class _HinoState extends State<HinoWidget> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("${widget.hino.titulo}")),
      body: _getBodyListView(context),
    );
  }

  Widget _getBodyListView(BuildContext context) {
    return ListView.builder(
      itemCount: widget.hino.paragrafos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(widget.hino.paragrafos[index].conteudo),
        );
      },
    );
  }
}