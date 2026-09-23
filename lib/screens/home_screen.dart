import 'package:flutter/material.dart';
import 'package:dartside_skateshop/models/produto_model.dart';
import 'package:dartside_skateshop/services/produto_banco.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //============================================
  int _totalProdutos = 0;

  @override
  void initState() {
    super.initState();
    _carregarTotal();
  }

  // carrega apenas o total de produtos (a listagem completa vem na próxima etapa)
  void _carregarTotal() async {
    final produtos = await ProdutoBanco().listarProdutos();
    if (!mounted) return;
    setState(() {
      _totalProdutos = produtos.length;
    });
  }

  void abrirFormulario() {
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    final categoriaController = TextEditingController();
    final valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cadastro de produto"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(label: Text("Nome")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o nome do produto";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descricaoController,
                  decoration: InputDecoration(label: Text("Descrição")),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: categoriaController,
                  decoration: InputDecoration(label: Text("Categoria")),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: valorController,
                  decoration: InputDecoration(label: Text("Valor")),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o valor do produto";
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return "Digite um valor numérico válido";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // só salva se o formulário passar na validação
                if (formKey.currentState!.validate()) {
                  final dadosProduto = ProdutoModel(
                    nome: nomeController.text,
                    descricao: descricaoController.text,
                    categoria: categoriaController.text,
                    valor: double.parse(valorController.text.replaceAll(',', '.')),
                  );
                  _salvarDados(dadosProduto);
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  } //fim da função abrir formulario

  void _salvarDados(ProdutoModel produto) async {
    bool salvou = await ProdutoBanco().inserirProduto(produto);
    if (salvou) {
      if (!mounted) return;
      Navigator.of(context).pop();
      _carregarTotal();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Produto salvo!")),
      );
    }
  } //fim da função salvar dados

  //============================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dartside Skateshop"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text("Total de produtos cadastrados: $_totalProdutos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirFormulario,
        child: Icon(Icons.add),
      ),
    );
  }
}
