import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:formvalidation/src/pages/utils/utils.dart' as utils;
import 'package:formvalidation/src/providers/producto_provider.dart';

//Para trabajar con Forms es necesario un statefulwidget
class ProductoPage extends StatefulWidget {
  //crear una key para que Flutter sepa que es un formulario
  //y tenga las herramientas correspondientes
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final ProductosProvider productoProv = new ProductosProvider();
  ProductoModel productoModel = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual), onPressed: () {}),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: () {})
        ],
      ),
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: productoModel.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) {
        setState(() {
          productoModel.disponible = value;
        });
      },
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: productoModel.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => productoModel.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto(Mínimo 3 carácteres)';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: productoModel.valor.toString(),
      onSaved: (value) => productoModel.valor = double.parse(value),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      onPressed: () {
        _submit();
      },
      label: Text('Guardar'),
    );
  }

  void _submit() {
    print(productoModel.titulo);
    print(productoModel.valor);
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    productoProv.crearProducto(productoModel);
  }
}
