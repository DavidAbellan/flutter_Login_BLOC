import 'dart:async';

class LoginBLOC {
  //.broadcast para que se pueda escuchar en toda la aplicación
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  //GET y SET

  //insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //para poder estar escuchando el stream// recuperar datos--salida
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  //cerrarlos cuando no los necesito
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
