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
          children: [Text('Contraseña : ${bloc.password} ')],
        ),
      ),
      body: Text('Email : ${bloc.email}'),
    );
  }
}
