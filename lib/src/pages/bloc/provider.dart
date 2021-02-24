import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
//vamos a implementar el patrón SingleTon para mantener la
//información después del hot reload

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  ////
  final loginBloc = LoginBLOC();
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //Provider({Key key, Widget child}) : super(key: key, child: child);

  //devolver el estado del LoginBloc
  static LoginBLOC of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
