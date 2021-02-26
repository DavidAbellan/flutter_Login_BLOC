import 'dart:convert';

import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:http/http.dart' as http;

class ProductosProvider {
  final String _url =
      "https://fluttervarios-94829-default-rtdb.europe-west1.firebasedatabase.app";

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';
    //FireBase acepta Strings así que hay que enviarle lo que hace
    //el model en la funcion productomodeltojson
    final res = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final String url =
        'https://fluttervarios-94829-default-rtdb.europe-west1.firebasedatabase.app/productos.json';

    final res = await http.get(url);
    final List<ProductoModel> productosFormatted = new List();
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
