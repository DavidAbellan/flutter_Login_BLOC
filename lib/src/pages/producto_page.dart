import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    if (foto != null) {
      productoModel.photo = await productoProv.subirImagen(foto);
    }
    if (productoModel.id == null) {
      //productoModel.id = 'pm' + productoModel.titulo.trim() + 1980.toString();
      productoProv.crearProducto(productoModel);
    } else {
      productoProv.modificarProducto(productoModel);
    }

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
      if (foto != null) {
        return Image.file(
          foto,
          height: 300.0,
          fit: BoxFit.cover,
        );
      }
    }
    return Image.asset('assets/no-image.png');
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: origen, imageQuality: 80);

    /*usar flutter image compres
    https://pub.dev/packages/flutter_image_compress*/
    foto = File(pickedFile.path);

    if (foto != null) {
      productoModel.photo = null;
    }

    setState(() {});
  }
}
