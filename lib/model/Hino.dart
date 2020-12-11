class Hino {
  final String compositor;
  final String numero;
  final List<Paragrafo> paragrafos;
  final String titulo;

  Hino({this.compositor, this.numero, this.paragrafos, this.titulo});

  factory Hino.fromJson(Map<String, dynamic> json) {
    return Hino(
      compositor: json['compositor'],
      numero: json['numero'],
      paragrafos: MapToParagrafos.fromMap(json['paragrafos']),
      titulo: json['titulo']
    );
  }

}

class Paragrafo {
  final String tipo;
  final String conteudo;

  Paragrafo({this.tipo, this.conteudo});

  factory Paragrafo.fromJson(Map<String, dynamic> json) {
    return Paragrafo(
        tipo: json['tipo'],
        conteudo: json['conteudo']
    );
  }
}

class MapToParagrafos {
  static List<Paragrafo> fromMap (List<dynamic> values){
    List<Paragrafo> paragrafos = List();
    values.forEach((element) => paragrafos.add(Paragrafo.fromJson(element)));
    return paragrafos;
  }
}

class TipoConteudo {
  
  static final String _hinosTitulos = "Hinos-Titulos";
  static final String _estrofes = "Estrofes";
  static final String _estrofesUltimaLinha = "Estrofes-Ultima-Linha";
  static final String _subTitulo = "Subtitulo";
  static final String _coro = "Coro";
  static final String _coroUltimaLinha = "Coro-Ultima-Linha";
  static final String _compositor = "Compositor";
  static final String _notaDeRodape = "Nota-de-rodap-";

  static bool isHinosTitulo(String tipo) {
    return _comparaTipos(_hinosTitulos, tipo);
  }

  bool isEstrofes(String tipo) {
    return _comparaTipos(_estrofes, tipo);
  }

  bool isEstrofesUltimaLinha(String tipo) {
    return _comparaTipos(_estrofesUltimaLinha, tipo);
  }

  bool isCoro(String tipo) {
    return _comparaTipos(_coro, tipo);
  }

  bool isSubTitulo(String tipo) {
    return _comparaTipos(_subTitulo, tipo);
  }

  bool isCoroUltimaLinha(String tipo) {
    return _comparaTipos(_coroUltimaLinha, tipo);
  }

  bool isCompositor(String tipo) {
    return _comparaTipos(_compositor, tipo);
  }

  bool isNotaRodape(String tipo) {
    return _comparaTipos(_notaDeRodape, tipo);
  }

  static String _getTipo(String tipo) {
    return tipo.trim().toUpperCase();
  }

  static bool _comparaTipos(String tipo1, String tipo2) {
    return _getTipo(tipo1).compareTo(_getTipo(tipo2)) == 0;
  }
  
}