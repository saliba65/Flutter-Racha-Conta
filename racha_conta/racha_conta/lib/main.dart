import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Racha Conta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // VARIAVEIS
  var _infoText = "";
  var isCalculate = false;
  var valorAlcoolatras = '';
  var valorNaoAlcoolatras = '';
  var valorGorjeta = '';
  var contaTotal = '';
  final valorAlcool = TextEditingController();
  final valorTotal = TextEditingController();
  final gorjeta = TextEditingController();
  final alcoolPessoas = TextEditingController();
  final totalPessoas = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racha Conta"),
        centerTitle: false,
        actions: <Widget>[
          Image(
            image: AssetImage('assets/icon.png'),
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields() {
    valorAlcool.text = "";
    valorTotal.text = '';
    alcoolPessoas.text = '';
    totalPessoas.text = '';
    gorjeta.text = '';
    valorAlcoolatras = '';
    valorNaoAlcoolatras = '';
    valorGorjeta = '';
    contaTotal = '';

    isCalculate = false;

    setState(() {
      _infoText = "Preencha todos os campos !";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    if (isCalculate == false) {
      return SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _editText("Valor total da conta: ", valorTotal),
                _editText("Valor da cervejinha: ", valorAlcool),
                _editText("Número total de pessoas: ", totalPessoas),
                _editText("Pessoas que tomaram uma: ", alcoolPessoas),
                _editText("Gorjeta para o cowboy (%):", gorjeta),
                _buttonCalcular(),
              ],
            ),
          ));
    } else {
      return SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _textInfo(),
                Image(
                  image: AssetImage('assets/cerveja.png'),
                )
              ],
            ),
          ));
    }
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: Colors.indigo[800],
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.indigo[200],
        ),
      ),
    );
  }

  // PROCEDIMENTO PARA VALIDAR OS CAMPOS
  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Preencha todos os campos !";
    }
    return null;
  }

  // Widget button
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 40.0, bottom: 20),
      height: 50,
      child: RaisedButton(
        color: Colors.indigo[700],
        child: Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            isCalculate = true;
            _calcular();
          }
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR A TEMPERATURA EM FAHRENHEIT
  void _calcular() {
    setState(() {
      double _valorTotal = double.parse(valorTotal.text);
      double _valorAlcool = double.parse(valorAlcool.text);
      double _totalPessoas = double.parse(totalPessoas.text);
      double _alcoolPessoas = double.parse(alcoolPessoas.text);
      double _gorjeta = double.parse(gorjeta.text);

      _gorjeta = _gorjeta/100;

      double individualSemAlcool = (((_valorTotal - _valorAlcool) + ((_valorTotal - _valorAlcool) * _gorjeta)) / _totalPessoas);

      double individualComAlcool = (individualSemAlcool +
          ((_valorAlcool + (_valorAlcool * _gorjeta)) /
              _alcoolPessoas));

      String _contaTotal = ((_valorTotal) + (_valorTotal * _gorjeta)).toStringAsPrecision(5);
      String _individualSemAlcool = individualSemAlcool.toStringAsPrecision(4);
      String _individualComAlcool = individualComAlcool.toStringAsPrecision(4);
      String _gorjeta_ = (_valorTotal * _gorjeta).toStringAsPrecision(4);

      valorAlcoolatras = 'R\$' + _individualComAlcool;
      valorNaoAlcoolatras = 'R\$' + _individualSemAlcool;
      valorGorjeta = 'R\$' + _gorjeta_;
      contaTotal = 'R\$' + _contaTotal;
    });
  }

  // // Widget text
  _textInfo() {
    return Text(
      '\n\n' +
          "Valor para as pessoas que beberam uma cervejinha: \n\n" +
          valorAlcoolatras +
          '\n\nValor para as pessoas que não beberam uma cervejinha: \n\n' +
          valorNaoAlcoolatras +
          '\n\nValor da gorjeta total: \n\n' +
          valorGorjeta +
          '\n\nValor total da conta: \n\n' +
          contaTotal,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.indigo[700], fontSize: 20.0),
    );
  }
}
