import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http_parser/http_parser.dart';
import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

class ProductosProvider {
  final List<ProductoModel> productosFormatted = new List();
  //para validar el token con firebase
  final _prefs = new PreferenciasUsuario();
  final String _url =
      "https://fluttervarios-94829-default-rtdb.europe-west1.firebasedatabase.app";

  Future<bool> modificarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    //FireBase acepta Strings así que hay que enviarle lo que hace
    //el model en la funcion productomodeltojson
    final res = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    //FireBase acepta Strings así que hay que enviarle lo que hace
    //el model en la funcion productomodeltojson
    final res = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final res = await http.delete(url);
    print(res);
    return 1;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final String url =
        'https://fluttervarios-94829-default-rtdb.europe-west1.firebasedatabase.app/productos.json?auth=${_prefs.token}';

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

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dsvuhzcsh/image/upload?upload_preset=dkgxklls');
    final mimeType = mime(imagen.path).split('/');
    final uploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );
    uploadRequest.files.add(file);

    final http.StreamedResponse streamResponse = await uploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    /* if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Error en la petición request');
      print(resp.body);
      return null;
    }*/

    final responseData = json.decode(resp.body);
    print(responseData);

    ///particularidades de cloudDinary
    return responseData['secure_url'];
  }
}
