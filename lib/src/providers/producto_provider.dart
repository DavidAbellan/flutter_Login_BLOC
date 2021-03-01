import 'dart:convert';

import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:http/http.dart' as http;

class ProductosProvider {
  final List<ProductoModel> productosFormatted = new List();

  final String _url =
      "https://fluttervarios-94829-default-rtdb.europe-west1.firebasedatabase.app";

  Future<bool> modificarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json';
    //FireBase acepta Strings así que hay que enviarle lo que hace
    //el model en la funcion productomodeltojson
    final res = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';
    //FireBase acepta Strings así que hay que enviarle lo que hace
    //el model en la funcion productomodeltojson
    final res = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json';
    final res = await http.delete(url);
    print(res);
    return 1;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final String url =
        'https://fluttervarios-94829-default-rtdb.europe-west1.firebasedatabase.app/productos.json';

    final res = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(res.body);
    if (decodedData == null) return [];
    decodedData.forEach((id, producto) {
      final temp = ProductoModel.fromJson(producto);
      temp.id = id;
      productosFormatted.add(temp);
    });
    return productosFormatted;
  }
}
