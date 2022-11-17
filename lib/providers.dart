import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practica/app.dart';



class Ingredientes with ChangeNotifier, DiagnosticableTreeMixin {
  int _ingredientes = 2;  // Inicialmente a 2 porque no puede ser menos

  int get ingredientes => _ingredientes;

  void increment() {
    _ingredientes++;
    notifyListeners();
  }

  void decrement() {
    _ingredientes--;
    notifyListeners();
  }
}


class NombreReceta with ChangeNotifier, DiagnosticableTreeMixin {
  String _nombre_receta = "salad";

  String get nombre_receta => _nombre_receta;

  void set_nombre_receta(String value) {
    _nombre_receta = value;
  }
}


class MinMaxCalorias with ChangeNotifier, DiagnosticableTreeMixin {
  String _min = "";
  String _max = "";

  String get min => _min;

  String get max => _max;

  void set_max(String value){
    _max = value;
  }

  void set_min(String value){
    _min = value;
  }
}


class OpcionesSeleccionadas with ChangeNotifier, DiagnosticableTreeMixin {
  List<Opcion> _opcionesDietas = [];
  List<Opcion> _opcionesAlergias = [];

  List<Opcion> get opcionesDietas => _opcionesDietas;

  List<Opcion> get opcionesAlergias => _opcionesAlergias;

  void set_opciones_dietas(List<Opcion> opciones){
    _opcionesDietas.clear();
    _opcionesDietas = opciones;
  }

  void set_opciones_alergias(List<Opcion> opciones){
    _opcionesAlergias.clear();
    _opcionesAlergias = opciones;
  }
}

class InfoEdamamRecetas with ChangeNotifier, DiagnosticableTreeMixin {
  late Widget info;
  String _busqueda = "";

  void set_info(Widget widget){
    info = widget;
  }

  String get busqueda => _busqueda;

  void set_busqueda(String new_search){
    _busqueda = new_search;
  }
}