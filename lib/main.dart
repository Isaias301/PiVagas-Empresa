import 'package:flutter/material.dart';
import 'package:pivagas_empresa/view/login.dart';
import 'package:pivagas_empresa/view/listar_vaga.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'PiVagas Empresa',
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
      fontFamily: 'Nunito',
    ),
    home: ListViewVaga(),
    // home: LoginPage(),
  ),
);