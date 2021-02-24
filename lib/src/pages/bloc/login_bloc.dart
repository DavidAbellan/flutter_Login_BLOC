import 'dart:async';

import 'package:formvalidation/src/pages/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

//with --- mixin
class LoginBLOC with Validators {
  //.broadcast para que se pueda escuchar en toda la aplicación
  /*final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();*/
  //usamos la librería rxdart que no reconoce los streamcontroller
  //así que lo cambiamos por BehaviorSubject

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //GET y SET

  //insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //para poder estar escuchando el stream// recuperar datos--salida
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  //Stream para ver cuando ambos tienen data
  Stream<bool> get formValidStream =>
      CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);
  //Obtener el último valor ingresado streams con el behaviorsubject
  String get email => _emailController.value;
  String get password => _passwordController.value;

  //cerrarlos cuando no los necesito
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
