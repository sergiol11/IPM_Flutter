import 'dart:core';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:practica/app.dart';
import 'package:practica/providers.dart';
import 'package:provider/provider.dart';

class LayoutHorizontal extends StatelessWidget{

  const LayoutHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
      body: Row(   // Tomamos el diseño como horizontal
        children: const [
          Expanded(  // En la mitad izquierda de la pantalla ponemos los botones y widgets para personalizar la búsqueda
              flex: 50,
              child: Botones("Horizontal")
          ),
          Expanded(  // En la mitad derecha de la pantalla ponemos la lista de recetas
              flex: 50,
              child: LayoutRecetas("Horizontal")
          )
        ],
      ),
    );
  }
}


class SelectorHorizontal extends StatelessWidget{
  const SelectorHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: BotonDietaAlergiaHorizontal())  // Creamos el botón que nos lleva a la pantalla para seleccionar las opciones de dietas y alergias
      ],
    );
  }
}

class BotonDietaAlergiaHorizontal extends StatelessWidget{

  const BotonDietaAlergiaHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () => Navigator.push(  // Cuando pulsemos el botón navegamos a la pantalla que nos permite escoger las opciones de dietas y alergias
            context,
            MaterialPageRoute(
                builder: (context) => const Selectores()
            )
        ),
        icon: const Icon(Icons.arrow_forward_ios),
        label: const Text("Dietas y Alergias",
          style: TextStyle(
              fontSize: 16
          ),
        )
    );
  }
}


final ListaOpciones listaOpciones = ListaOpciones();  // Variable con las opciones de dietas y alergias disponibles


class Selectores extends StatelessWidget{
  const Selectores({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
      appBar: AppBar(   // Barra inicial con título que nos permite volver a la pantalla anterior
        title: const Text("Dietas y Alergias"),
      ),
      body: Row(
        children: const [
          Expanded(  // Mitad izquierda de pantalla para seleccionar opciones de las dietas
              flex: 50,
              child: SelectorPage("Dietas")),
          VerticalDivider(  // Divisor entre opciones
            width: 10,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: Colors.green,
          ),
          Expanded(  // Mitad derecha de la pantalla para seleccionar opciones de alergias
              flex: 50,
              child: SelectorPage("Alergias")),
        ],
      ),
    );
  }
}


class SelectorPage extends StatelessWidget{
  final String dietaOalergia;  // Variable donde guardamos si vamos a trabajar con dietas o alergias

  const SelectorPage(this.dietaOalergia, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
      body: SafeArea(
        child: FilterListWidget<Opcion>(
          themeData: FilterListThemeData(context),
          hideSearchField: true,  // Ocultamos el buscador de opciones.
          resetButtonText: "Borrar",
          applyButtonText: "Guardar",
          controlButtons: const [ControlButtonType.Reset],  // Añadimos un botón de borrar todas las opciones seleccionadas
          selectedItemsText: "Seleccionados",  // Texto que se muestra al lado del número de opciones seleccionadas

          // Lista de opciones disponibles (de dietas o alergias dependiendo del caso)
          listData: dietaOalergia == "Dietas" ? listaAux.dietas
              : listaAux.alergias,

          // Lista donde se leen las opciones seleccionadas (leemos la lista del provider)
          selectedListData: dietaOalergia == "Dietas" ? context.read<OpcionesSeleccionadas>().opcionesDietas
              : context.read<OpcionesSeleccionadas>().opcionesAlergias,

          onApplyButtonClick: (list) {  // Cuando clickamos en el botón guardar
            // Guardamos en la lista correspondiente del provider (Dietas o Alergias) las opciones seleccionadas
            dietaOalergia == "Dietas" ? context.read<OpcionesSeleccionadas>().set_opciones_dietas(List.from(list!))
                : context.read<OpcionesSeleccionadas>().set_opciones_alergias(List.from(list!));
          },

          choiceChipLabel: (item) {  // Texto de la opción
            return item!.opcion;
          },

          validateSelectedItem: (list, val) {  // Identifica si una opción está seleccionada o no
            return list!.contains(val);
          },

          onItemSearch: (opt, query) {  // Acción a realizar en la búsqueda (obligatorio pese a tenerla deshabilitada)
            return opt.opcion.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}