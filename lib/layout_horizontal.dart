import 'dart:core';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
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
          Expanded(
              flex: 50,   // 45%
              child: Botones("Horizontal")
          ),
          Expanded(
              flex: 50,    // 55%
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
        Expanded(child: BotonDietaAlergiaHorizontal())
      ],
    );
  }
}

class BotonDietaAlergiaHorizontal extends StatelessWidget{

  const BotonDietaAlergiaHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () => Navigator.push(
            context,      // Navegamos á próxima pantalla
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


final ListaOpciones listaOpciones = ListaOpciones();


class Selectores extends StatelessWidget{
  const Selectores({super.key});


  @override
  Widget build(BuildContext context) {
    MultiSplitView multiSplitView = MultiSplitView(
        children: const [
          SelectorPage("Dietas"),
          SelectorPage("Alergias")
        ]
    );


    MultiSplitViewTheme theme = MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.dashed(
                color: Colors.deepOrange,
                highlightedColor: Colors.black
            )
        ),
        child: multiSplitView
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text("Dietas y Alergias"),
      ),
      body: theme,
    );
  }

}

class SelectorPage extends StatefulWidget{
  final String dietaOalergia;

  const SelectorPage(this.dietaOalergia, {super.key});

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
          listData: widget.dietaOalergia == "Dietas" ? listaAux.dietas
              : listaAux.alergias,
          selectedListData: widget.dietaOalergia == "Dietas" ? context.read<OpcionesSeleccionadas>().opcionesDietas
              : context.read<OpcionesSeleccionadas>().opcionesAlergias,    // Modificamos en el provider la lista de opciones correspondiente
          onApplyButtonClick: (list) {
            setState(() {
              widget.dietaOalergia == "Dietas" ? context.read<OpcionesSeleccionadas>().set_opciones_dietas(List.from(list!))
                  : context.read<OpcionesSeleccionadas>().set_opciones_alergias(List.from(list!));  // Actualizamos la lista de opciones correspondiente
            }
            );
          },
          choiceChipLabel: (item) {
            return item!.opcion;
          },
          validateSelectedItem: (list, val) {
            return list!.contains(val);
          },
          onItemSearch: (opt, query) {
            return opt.opcion.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}