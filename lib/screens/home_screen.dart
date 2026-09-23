import 'package:flutter/material.dart';
import 'package:dartside_skateshop/services/produto_banco.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _status = "Iniciando banco";

  @override
  void initState() {
    super.initState();
    _testarBanco();
  }

  // Vendo se funciona o banco
  void _testarBanco() async {
    await ProdutoBanco().iniciarBanco();
    if (!mounted) return;
    setState(() {
      _status = "Banco de dados ok";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dartside Skateshop"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(_status),
      ),
    );
  }
}
