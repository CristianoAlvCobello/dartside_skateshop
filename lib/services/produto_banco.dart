import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProdutoBanco {

  Future<Database> iniciarBanco() async {
    return await openDatabase(
      // /data/data/<package_name>/databases/"produtos.db"
      join(await getDatabasesPath(), 'produtos.db'),
      onCreate: (db, version) {
        return db.execute("""CREATE TABLE produtos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          descricao TEXT,
          categoria TEXT,
          valor REAL NOT NULL
        )""");
      },
      version: 1
    );
  }

}
