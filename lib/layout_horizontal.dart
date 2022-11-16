import 'dart:core';
import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:filter_list/filter_list.dart';
import 'package:gradient_floating_button/gradient_floating_button.dart';
import 'package:practica/app.dart';
import 'package:practica/providers.dart';
import 'package:provider/provider.dart';
import 'edamam.dart';

class LayoutHorizontal extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
      body: Row(   // Tomamos el diseño como horizontal
        children: [
          Expanded(
              flex: 50,   // 45%
              child: Botones("Horizontal")),
          const Expanded(
              flex: 50,    // 55%
              child: ModalBottomSheetDemo("Horizontal",))
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
      children: [
        Expanded(child: BotonDietaAlergiaHorizontal())
      ],
    );
  }
}

class BotonDietaAlergiaHorizontal extends StatelessWidget{

  BotonDietaAlergiaHorizontal();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () => Navigator.push(context,      // Navegamos á próxima pantalla
            MaterialPageRoute(
                builder: (context) => Selectores())),
        icon: const Icon(Icons.arrow_forward_ios),
        label: const Text("Dietas y Alergias",
          style: TextStyle(
              fontSize: 16
          ),));
  }
}


final ListaOpciones listaOpciones = ListaOpciones();


class Selectores extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    MultiSplitView multiSplitView = MultiSplitView(children: [
      SelectorPage("Dietas"), SelectorPage("Alergias")]);


    MultiSplitViewTheme theme = MultiSplitViewTheme(
        child: multiSplitView,
        data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.dashed(
                color: Colors.deepOrange, highlightedColor: Colors.black)));


    return Scaffold(
      appBar: AppBar(
        title: Text("Dietas y Alergias"),
      ),
      body: theme,
    );
  }

}

class SelectorPage extends StatefulWidget{
  final String dieta_o_alergia;

  SelectorPage(this.dieta_o_alergia);

  @override
  State<SelectorPage> createState() => _SelectorPageState();  // Esto non sei se poñer como cabrero ou como prueba
}

class _SelectorPageState extends State<SelectorPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FilterListWidget<Opcion>(
          themeData: FilterListThemeData(context),
          //allButtonText: "Todos",
          resetButtonText: "Borrar",
          applyButtonText: "Guardar",
          controlButtons: const [/*ControlButtonType.All,*/ ControlButtonType.Reset],  // Quitamos botón todos de opcions de lista
          hideSelectedTextCount: false,
          listData: widget.dieta_o_alergia == "Dietas" ? listaAux.dietas
              : listaAux.alergias,
          selectedListData: widget.dieta_o_alergia == "Dietas" ? context.read<OpcionesSeleccionadas>().opcionesDietas
              : context.read<OpcionesSeleccionadas>().opcionesAlergias,    // Modificamos en el provider la lista de opciones correspondiente
          onApplyButtonClick: (list) {
            setState(() {
              widget.dieta_o_alergia == "Dietas" ? context.read<OpcionesSeleccionadas>().set_opciones_dietas(List.from(list!))
                  : context.read<OpcionesSeleccionadas>().set_opciones_alergias(List.from(list!));  // Actualizamos la lista de opciones correspondiente
            });
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item!.opcion;
          },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (opt, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return opt.opcion!.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}