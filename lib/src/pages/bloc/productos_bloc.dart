import 'dart:io';

import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:formvalidation/src/providers/producto_provider.dart';
import 'package:rxdart/subjects.dart';

import 'package:rxdart/rxdart.dart';

class ProductosBLOC {
  //trabajamos con BehaviorSubject por usar la librería rxdart
  //se podría hacer con Stream
  final productosController = new BehaviorSubject<List<ProductoModel>>();
  final cargandoController = new BehaviorSubject<bool>();
  final productosProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productosStream => productosController.stream;
  Stream<bool> get cargando => cargandoController.stream;

  void cargarProductos() async {
    final productos = await productosProvider.cargarProductos();
    productosController.sink.add(productos);
  }

  void agregarProducto(ProductoModel producto) async {
    //Notificar que se está en la tarea de crear el producto
    cargandoController.sink.add(true);

    await productosProvider.crearProducto(producto);

    cargandoController.sink.add(false);
  }

  void editarProducto(ProductoModel producto) async {
    //Notificar que se está en la tarea de crear el producto
    cargandoController.sink.add(true);

    await productosProvider.modificarProducto(producto);

    cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await productosProvider.borrarProducto(id);
  }

  Future<String> subirFoto(File foto) async {
    cargandoController.sink.add(true);

    final fotoUrl = await productosProvider.subirImagen(foto);

    cargandoController.sink.add(false);
    return fotoUrl;
  }

  dispose() {
    productosController?.close();
    cargandoController?.close();
  }
}
