import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/bloc/login_bloc.dart';
import 'package:formvalidation/src/pages/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        //cuando creas campos de texto en un widget
        //es importante que estén dentro de un elemento que haga scroll
        _loginForm(context)
      ],
    ));
  }
}

Widget _loginForm(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final bloc = Provider.of(context);

  return SingleChildScrollView(
    child: Column(
      children: [
        SafeArea(
            child: Container(
          height: 180.0,
        )),
        Container(
            child: Column(
              children: [
                Text(
                  'Log In',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
              ],
            ),
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0, 5.0),
                    spreadRadius: 3.0)
              ],
            )),
        Text('Olvidé la contraseña...'),
        SizedBox(
          height: 100.0,
        )
      ],
    ),
  );
}

Widget _crearEmail(LoginBLOC bloc) {
  return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.alternate_email,
                  color: Colors.deepPurple,
                ),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo Electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: (value) => bloc.changeEmail(value),
          ),
        );
      });
}

Widget _crearPassword(LoginBLOC bloc) {
  return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.deepPurple,
                ),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      });
}

Widget _crearBoton(LoginBLOC bloc) {
  return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            child: Container(
              child: Text('Ok'),
            ),
            onPressed: snapshot.hasData ? () {} : null);
      });
}

Widget _crearFondo(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final fondoMorado = Container(
    height: size.height * 0.4,
    width: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
      Color.fromRGBO(63, 63, 156, 1.0),
      Color.fromRGBO(90, 70, 178, 1.0)
    ])),
  );
  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)),
  );
  return Stack(
    children: [
      fondoMorado,
      //Positioned debe tener uno de los valores nulo o falla(left,right,top..)
      Positioned(
        child: circulo,
        top: 90.0,
        left: 30.0,
      ),
      Positioned(
        child: circulo,
        top: -40.0,
        left: -30.0,
      ),
      Positioned(
        child: circulo,
        top: 70.0,
        left: 10.0,
      ),
      Positioned(
        child: circulo,
        top: -120.0,
        left: 56.0,
      ),
      Positioned(
        child: circulo,
        bottom: -80.0,
        right: 20.0,
      ),
      Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            Text(
              'Chanelorium',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            )
          ],
        ),
      )
    ],
  );
}
