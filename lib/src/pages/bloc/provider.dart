import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBLOC();
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  Provider({Key key, Widget child}) : super(key: key, child: child);

  //devolver el estado del LoginBloc
  static LoginBLOC of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
