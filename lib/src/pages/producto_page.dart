import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/models/producto_model.dart';
import 'package:formvalidation/src/pages/utils/utils.dart' as utils;
import 'package:formvalidation/src/providers/producto_provider.dart';
import 'package:image_picker/image_picker.dart';

//Para trabajar con Forms es necesario un statefulwidget
class ProductoPage extends StatefulWidget {
  //crear una key para que Flutter sepa que es un formulario
  //y tenga las herramientas correspondientes
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  //referencia al Scaffold
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ProductosProvider productoProv = new ProductosProvider();
  ProductoModel productoModel = new ProductoModel();
  File foto;
  //para controlar que no se guarde el artículo dos veces
  bool _guardando = false;
  @override
  Widget build(BuildContext context) {
    //prodData para ver si venimos de clickar un producto o al
    //boton nuevo
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      productoModel = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
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
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
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
        (_guardando) ? null : _submit();
      },
      label: Text('Guardar'),
    );
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    if (productoModel.id == null) {
      //productoModel.id = 'pm' + productoModel.titulo.trim() + 1980.toString();
      productoProv.crearProducto(productoModel);
    } else {
      productoProv.modificarProducto(productoModel);
    }
    setState(() {
      _guardando = false;
    });
    mostrarSnackbar('Registro guardado');
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final SnackBar sanckbar = SnackBar(
        content: Text(mensaje), duration: Duration(milliseconds: 1500));

    //necesito la referencia al scaffold

    scaffoldKey.currentState.showSnackBar(sanckbar);
  }

  _mostrarFoto() {
    if (productoModel.photo != null) {
      return FadeInImage(
        image: NetworkImage(productoModel.photo),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery); //pickImage(source: ImageSource.gallery);
    if (foto != null) {}
    foto = File(pickedFile.path);
    setState(() {});
  }

  _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.camera); //pickImage(source: ImageSource.gallery);
    if (foto != null) {}
    foto = File(pickedFile.path);
    setState(() {});
  }
}
