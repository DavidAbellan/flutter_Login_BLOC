import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/bloc/login_bloc.dart';
import 'package:formvalidation/src/pages/bloc/productos_bloc.dart';
//para obtener la referencia
export 'package:formvalidation/src/pages/bloc/productos_bloc.dart';

//PROVIDER ES LA CLASE DEL INHERIT WIDGET(un widget que almacena información)
//padre de todos
class Provider extends InheritedWidget {
//vamos a implementar el patrón SingleTon para mantener la
//información después del hot reload
  final loginBloc = LoginBLOC();
  final _productBloc = ProductosBLOC();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  ////
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //Provider({Key key, Widget child}) : super(key: key, child: child);

  //devolver el estado del LoginBloc
  static LoginBLOC of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductosBLOC productosBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productBloc;
  }
}
