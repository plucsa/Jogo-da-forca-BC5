import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(JogoForca());
}

class JogoForca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Forca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaForca(),
    );
  }
}

class TelaForca extends StatefulWidget {
  @override
  _TelaForcaState createState() => _TelaForcaState();
}

class _TelaForcaState extends State<TelaForca> {
  final Map<String, String> _palavrasComDicas = {
    'FLUTTER': 'Um framework popular para construir aplicativos móveis.',
    'DART': 'Uma linguagem de programação otimizada para construir UI.',
    'DESENVOLVEDOR':
        'Alguém que escreve código para criar aplicativos de software.',
    'FORCA': 'O nome deste jogo!',
    'ABACAXI': 'Uma fruta tropical com espinhos.',
    'ELEFANTE': 'Um mamífero terrestre de grande porte com tromba.',
    'PRAIA': 'Um local à beira-mar para relaxar e se divertir.',
    'PIZZA':
        'Um prato italiano redondo, coberto com queijo e outros ingredientes.',
    'CARRO':
        'Um veículo motorizado com quatro rodas para transporte de pessoas.',
    'GALINHA': 'Um animal de fazenda que bota ovos.',
    'CACHORRO': 'O melhor amigo do homem.',
    'FLORESTA': 'Uma grande área de terra coberta por árvores.',
    'OCEANO': 'Um vasto mar aberto.',
    'CELULAR': 'Um dispositivo eletrônico usado para comunicação.',
    'CINEMA': 'Um local onde as pessoas assistem a filmes.',
    'BANANA': 'Uma fruta amarela alongada e saborosa.',
    'MÚSICA': 'Sons organizados de forma agradável aos ouvidos.',
    'COMPUTADOR': 'Uma máquina que processa dados e realiza tarefas.',
    'SISTEMA OPERACIONAL': 'Um software que controla hardware e software.',
    'MICROONDAS': 'Um aparelho usado para cozinhar e aquecer alimentos.',
    'TÊNIS': 'Um calçado esportivo para correr ou praticar esportes.',
    'SÃO PAULO':
        'Uma cidade brasileira conhecida como a maior metrópole do país.',
    // Adicione mais palavras e dicas conforme necessário
  };

  late String _palavraSelecionada;
  late String _palavraExibida;
  int _tentativasRestantes = 6;
  List<String> _letrasChutadas = [];
  bool _jogoEncerrado = false;
  int _partesDoCorpo = 0;
  String _nomeAutor1 = '';
  String _nomeAutor2 = '';
  bool _exibirDica = false;
  bool _palavraEspacada = false;

  @override
  void initState() {
    super.initState();
    _inicializarJogo();
  }

  void _inicializarJogo() {
    final random = Random();
    _palavraSelecionada = _palavrasComDicas.keys
        .elementAt(random.nextInt(_palavrasComDicas.length));
    _palavraExibida = _palavraSelecionada.replaceAll(RegExp(r'\S'), '*');
    _tentativasRestantes = 6;
    _letrasChutadas.clear();
    _jogoEncerrado = false;
    _partesDoCorpo = 0;
    _exibirDica = false;
    _palavraEspacada = _palavraSelecionada.contains(' ');
  }

  void _chutarLetra(String letra) {
    setState(() {
      if (!_letrasChutadas.contains(letra) && !_jogoEncerrado) {
        _letrasChutadas.add(letra);
        if (!_palavraSelecionada.contains(letra)) {
          _tentativasRestantes--;
          _partesDoCorpo++;
        } else {
          for (int i = 0; i < _palavraSelecionada.length; i++) {
            if (_palavraSelecionada[i] == letra) {
              _palavraExibida = _palavraExibida.replaceRange(i, i + 1, letra);
            }
          }
        }
      }
      if (_palavraExibida == _palavraSelecionada) {
        _mostrarDialogo(
            'Você Venceu!', 'Você adivinhou a palavra corretamente!');
      } else if (_tentativasRestantes == 0) {
        _mostrarDialogo('Fim de Jogo', 'Você esgotou todas as tentativas.');
      } else if (_tentativasRestantes == 2) {
        _exibirDica = true;
      }
    });
  }

  void _mostrarDialogo(String titulo, String conteudo) {
    setState(() {
      _jogoEncerrado = true;
      _palavrasComDicas.remove(_palavraSelecionada);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(conteudo),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartApp();
              },
              child: Text('Tentar Novamente'),
            ),
          ],
        );
      },
    );
  }

  void _restartApp() {
    setState(() {
      _inicializarJogo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'assets/logo.png',
                height: 40,
              ),
            ),
            Text('Jogo da Forca'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Adicionando o boneco da forca com partes do corpo
            Image.asset(
              'assets/forca$_partesDoCorpo.png',
              height: 200,
            ),
            SizedBox(height: 20.0),
            Text(
              '$_palavraExibida',
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'Tentativas restantes: $_tentativasRestantes',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            _exibirDica
                ? Text(
                    'Dica: ${_palavrasComDicas[_palavraSelecionada]}',
                    style:
                        TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                  )
                : SizedBox(),
            SizedBox(height: 20.0),
            _palavraEspacada
                ? Text(
                    'Palavra Espaçada',
                    style: TextStyle(fontSize: 16.0, color: Colors.green),
                  )
                : SizedBox(),
            SizedBox(height: 20.0),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              runSpacing: 10.0,
              children: List.generate(26, (index) {
                final letra = String.fromCharCode('A'.codeUnitAt(0) + index);
                return ElevatedButton(
                  onPressed: _tentativasRestantes > 0 &&
                          !_letrasChutadas.contains(letra) &&
                          !_jogoEncerrado
                      ? () => _chutarLetra(letra)
                      : null,
                  child: Text(letra),
                );
              }),
            ),
            SizedBox(height: 20.0),
            Visibility(
              visible: _jogoEncerrado,
              child: ElevatedButton(
                onPressed: () {
                  _restartApp();
                },
                child: Text('Tentar Novamente'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _nomeAutor1 = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Pedro Lucas Rodrigues',
                  ),
                ),
              ),
              SizedBox(width: 25.0),
              Flexible(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _nomeAutor2 = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Iago de Souza Nogueira',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
