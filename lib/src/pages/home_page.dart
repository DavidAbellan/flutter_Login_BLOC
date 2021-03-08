import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/bloc/provider.dart';
import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:formvalidation/src/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  //sustituimos el productosProvider para implementar el patrón BLOC

  //final ProductosProvider productosProvider = new ProductosProvider();
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('Email : ${bloc.email} ')],
        ),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBLOC productos) {
    return StreamBuilder(
      stream: productos.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                _crearItem(snapshot.data[index], context, productos),
            itemCount: snapshot.data.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    /* return FutureBuilder(
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
        future: productosProvider.cargarProductos());*/
  }

  Widget _crearItem(
      ProductoModel item, BuildContext context, ProductosBLOC productosBloc) {
    return Dismissible(
        onDismissed: (direccion) {
          productosBloc.borrarProducto(item.id);
        },
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        child: Card(
          child: Column(
            children: <Widget>[
              (item.photo == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(item.photo),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${item.titulo} --- ${item.valor}'),
                subtitle: Text(item.id),
                onTap: () =>
                    Navigator.pushNamed(context, 'producto', arguments: item),
              ),
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }
}
