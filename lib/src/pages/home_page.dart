import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('Email : ${bloc.email} ')],
        ),
      ),
      body: Container(),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }
}
