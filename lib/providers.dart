import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practica/app.dart';
import 'package:provider/provider.dart';


class Contador with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}


class NombreReceta with ChangeNotifier, DiagnosticableTreeMixin {
  String _nombre_receta = "adios";

  String get nombre_receta => _nombre_receta;

  void set_nombre_receta(String value) {
    _nombre_receta = value;
  }
}


class MinMaxCalorias with ChangeNotifier, DiagnosticableTreeMixin {
  int _min = 0;
  int _max = 50000;

  int get min => _min;

  int get max => _max;

  void set_max(String value){
    _max = int.parse(value);
  }

  void set_min(String value){
    _min = int.parse(value);
  }
}


class OpcionesSeleccionadas with ChangeNotifier, DiagnosticableTreeMixin {
  List<Opcion> _opcionesDietas = [];
  List<Opcion> _opcionesAlergias = [];

  List<Opcion> get opcionesDietas => _opcionesDietas;

  List<Opcion> get opcionesAlergias => _opcionesAlergias;

  void set_opciones_dietas(List<Opcion> opciones){
    _opcionesDietas.clear();
    _opcionesDietas = List.of(opciones);
  }

  void set_opciones_alergias(List<Opcion> opciones){
    _opcionesAlergias.clear();
    _opcionesAlergias = List.of(opciones);
  }
}