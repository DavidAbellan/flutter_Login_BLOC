import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/bloc/provider.dart';
import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:formvalidation/src/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  final ProductosProvider productosProvider = new ProductosProvider();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('Email : ${bloc.email} ')],
        ),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  _crearItem(snapshot.data[index], context),
              itemCount: snapshot.data.length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: productosProvider.cargarProductos());
  }

  Widget _crearItem(ProductoModel item, BuildContext context) {
    return Dismissible(
      onDismissed: (direccion) {
        productosProvider.borrarProducto(item.id);
      },
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        title: Text('${item.titulo} --- ${item.valor}'),
        subtitle: Text(item.id),
        onTap: () => Navigator.pushNamed(context, 'producto', arguments: item),
      ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }
}
