import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practica/app.dart';
import 'package:practica/edamam.dart';


class Recetas with ChangeNotifier, DiagnosticableTreeMixin {
  // A lista de recetas da app estará continuamente escoitando esta variable
  // para mostrar en todo momento as recetas correctas.
  // Inicialmente al recetas corresponden coa búsqueda que conteña a palabra "salad".
  late Future<RecipeBlock?> recetas = search_recipes("&q=salad");

  // Variable donde guardamos la query usada en la anterior búsqueda.
  late String queryAnterior;

  void buscarRecetas(String query) {
    /* Cada vez que se realice unha búsqueda chamarase a este método para
       actualizar as recetas cargadas.*/
    recetas = search_recipes(query);
    queryAnterior = query;
    // Avisase a quen esté escoitando de que as recetas cambiaron.
    notifyListeners();
  }

  void realizarBusquedaAnterior(){
    // Se llamará a este método para volver a realizar la búsqueda anterior.
    recetas = search_recipes(queryAnterior);
    notifyListeners();
  }
}


class Ingredientes with ChangeNotifier, DiagnosticableTreeMixin {
  // O texto que mostra o límite de ingredientes estará continuamente escoitando
  // esta variable para mostrar en todo momento as número correcto.
  int _ingredientes = 2;  // Inicialmente a 2 xa que non hai recetas con menos ingredientes.

  // Esta variable indica se hai que aplicar o filtro de ingredientes cando se
  // realiza unha búsqueda.
  bool _aplicar = true;

  int get ingredientes => _ingredientes; // Getter da variable.
  bool get aplicar => _aplicar; // Getter da variable.

  void increment() {
    // Chamada por un botón para aumentar o límite de ingredientes.
    _ingredientes++;
    notifyListeners(); // Avisase a quen esté escoitando de que o límite cambiou.
  }

  void decrement() {
    // Chamada por un botón para disminuir o límite de ingredientes.
    _ingredientes--;
    notifyListeners(); // Avisase a quen esté escoitando de que o límite cambiou.
  }

  void cambiarValor(bool valor){
    // Este método será chamado polo SwitchListTile para decidir se aplicar o
    // límite de ingredientes na búsqueda ou non.
    _aplicar = valor;
  }
}


class NombreReceta with ChangeNotifier, DiagnosticableTreeMixin {
  // Nesta variable gárdase en todo momento o texto que hai escrito no
  // TextFormField do nome da receta.
  String _nombre_receta = "salad"; // Inicialmente aparece escrito "salad".

  String get nombre_receta => _nombre_receta; // Getter da variable.

  void set_nombre_receta(String value) {
    // Cada vez que se escribe ou se borra un caracter no TextFormField do nome da receta
    // actualízase a variable.
    _nombre_receta = value;
  }
}


class MinMaxCalorias with ChangeNotifier, DiagnosticableTreeMixin {
  // Nestas variables gárdase en todo momento o texto que hai escrito nos
  // TextFormFields das kcal.
  String _min = "";
  String _max = "";

  String get min => _min; // Getter da variable.

  String get max => _max; // Getter da variable.

  // Cada vez que se escribe ou se borra un caracter nos TextFormFields das kcal
  // actualízanse as variables.
  void set_max(String value){
    _max = value;
  }

  void set_min(String value){
    _min = value;
  }
}


class OpcionesSeleccionadas with ChangeNotifier, DiagnosticableTreeMixin {
  // Nestas variables gárdase en todo momento as opcións que hai seleccionadas
  // nos FilterListDialog das dietas e das alerxias.
  List<Opcion> _opcionesDietas = [];
  List<Opcion> _opcionesAlergias = [];

  List<Opcion> get opcionesDietas => _opcionesDietas; // Getter da variable.

  List<Opcion> get opcionesAlergias => _opcionesAlergias; // Getter da variable.

  // Cada vez que engadimos ou quitamos opcións dos FilterListDialog das dietas e
  // das alerxias actualizamos o valor das variables chamando a estos métodos.
  void set_opciones_dietas(List<Opcion> opciones){
    _opcionesDietas.clear();
    _opcionesDietas = opciones;
  }

  void set_opciones_alergias(List<Opcion> opciones){
    _opcionesAlergias.clear();
    _opcionesAlergias = opciones;
  }
}