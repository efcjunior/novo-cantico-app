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

class IndiceWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Índice"),),
      body: _getIndices(),
    );
  }

  Widget _getIndices() {
    return ListView.builder(
      itemCount: 400,
      itemBuilder: (context, index) {
        int numero = index + 1;
        return Card(
          child: ListTile(
            title: Text('$numero'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){
              _navegaParaHinoTela(context, numero);
            },
          ),
        );
      },
    );
  }

  void _navegaParaHinoTela(BuildContext context, numeroSelecao) {
    Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => HinoWidget(numero: numeroSelecao)
        ));
  }
}

class HinoWidget extends StatefulWidget {
  final int numero;

  HinoWidget({Key key, @required this.numero}) : super(key:key);

  @override
  _HinoState createState() => _HinoState();
}

class _HinoState extends State<HinoWidget> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Hino ${widget.numero}")),
      body: _getBodyListView(context),
    );
  }

  Widget _getBodyListView(BuildContext context) {
    return FutureBuilder(
      future: _getHino(widget.numero),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.paragrafos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data.paragrafos[index].conteudo),
              );
            },
          );
        }else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<Hino> _getHino(int numero) async {
    final response =
    await http.get("https://hinario.herokuapp.com/hinos/${numero}");

    if (response.statusCode == 200) {
      return Hino.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Erro ao carregar hino');
    }
  }
}