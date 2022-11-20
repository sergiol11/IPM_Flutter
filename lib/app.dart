import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:octo_image/octo_image.dart';
import 'package:practica/detalle_receta.dart';
import 'package:practica/providers.dart';
import 'edamam.dart';
import 'layout_horizontal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

const int breakPoint = 600;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(   // Provider
        providers: [
          ChangeNotifierProvider(create: (_) => Ingredientes()),
          ChangeNotifierProvider(create: (_) => NombreReceta()),
          ChangeNotifierProvider(create: (_) => MinMaxCalorias()),
          ChangeNotifierProvider(create: (_) => OpcionesSeleccionadas()),
          ChangeNotifierProvider(create: (_) => Recetas()),
        ],
        child: GestureDetector(   // Detector para tocar pantalla y quitarle el foco al widget que lo tenga en ese momento
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: MaterialApp(  // Aplicación
                theme: ThemeData(
                  primarySwatch: Colors.green,
                ),
                home: const MasterDetail(title: 'Edamam',)
            )
        )
    );
  }
}


class MasterDetail extends StatelessWidget {
  final String title;  //??????????????????????????????????????????????

  const MasterDetail({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool chooseMasterAndDetail = (   // Comprobamos si el dispositivo está en vertical o horizontal
              constraints.smallest.longestSide > breakPoint &&
                  MediaQuery.of(context).orientation == Orientation.landscape
          );
          return chooseMasterAndDetail ? const LayoutHorizontal() : const LayoutVertical();  // Diseño horizontal o vertical según la orientación del dispositivo
        }
    );
  }
}


class LayoutVertical extends StatelessWidget {
  final String texto = "buscar";  // ??????????????????????????????????????????

  const LayoutVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return const Botones("Vertical");  //???????????????????????????????????????
  }
}

class Botones extends StatefulWidget{
  final String orientacion;

  const Botones(this.orientacion, {super.key});

  @override
  _Botones createState() => _Botones();
}

class _Botones extends State<Botones>{
  late bool visible;

  @override
  void initState() {
    super.initState();
    visible = true;
  }

  update(bool valor){
    setState(() {
      visible = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
        body: Column(
          children: [
            Expanded(  // Imagen del logo de Edamam
                flex: 8,  // Espacio vertical correspondiente
                child:
                Image.asset('assets/images/Edamam_logo_full_RGB.png',
                    scale: 6
                )
            ),
            Expanded(
              flex: 8,  // Espacio vertical correspondiente
              child: Row(   // Fila para el widget donde se introduce el nombre de receta
                children: [
                  Spacer(flex: 15),  // Espacio vacío a la izquierda
                  Expanded(
                      flex: 70,
                      child: BuscadorNombreReceta()   // Widget línea ?????????????????????????
                  ),
                  Spacer(flex: 15),  // Espacio vacío a la derecha
                ],
              ),
            ),
            widget.orientacion == "Vertical" ?    // Si la orientación del dispositivo es vertical utilizamos un botón para Dietas y otro para Alergias
            Expanded(
                flex: 8,  // Espacio vertical correspondiente
                child: Row(   // Fila para el botón Dietas y el botón Alergias
                  children: [
                    Spacer(flex: 7),  // Espacio vacío a la izquierda de los botones
                    Expanded(
                      flex: 35,
                      child: Selector("Dietas"),  // Botón para dietas
                    ),
                    Spacer(flex: 15),  // Espacio que separa los botones
                    Expanded(
                      flex: 35,
                      child: Selector("Alergias"),  // Botón para alergias
                    ),
                    Spacer(flex: 7),  // Espacio vacío a la derecha de los botones
                  ],
                )
            )
                :   // Si la orientación del dispositivo es horizontal utilizamos un botón para Dietas y Alergias
            Expanded(
                flex: 8,  // Espacio vertical correspondiente
                child: Row(  // Fila para el botón
                  children: const [
                    Spacer(flex: 15,),  // Espacio vacío a la izquierda de los botones
                    Expanded(
                        flex: 70,
                        child: SelectorHorizontal()   // ???????????????????????????????????????????????????????
                    ),
                    Spacer(flex: 15,)   // Espacio vacío a la derecha de los botones
                  ],
                )
            ),
            Expanded(
              flex: 8,  // Espacio vertical correspondiente
              child: Row(   // Fila para introducir el mínimo y/o máximo de calorías
                children: [
                  const Spacer(flex: 5),  // Espacio vacío a la izquierda de los widgets
                  const Expanded(
                      flex: 23,
                      child: Text("Kcal:",  // Texto indicando que son los widgets para indicar las calorías
                        style: TextStyle(
                            fontSize: 22
                        ),
                      )
                  ),
                  Expanded(
                      flex: 31,
                      child: Calorias("Min")  // Widget para el mínimo de calorías
                  ),
                  Spacer(flex: 3),  // Espacio entre los widgets
                  Expanded(
                      flex: 31,
                      child: Calorias("Max")   // Widget para el máximo de calorías
                  ),
                  Spacer(flex: 6)  // Espacio vacío a la derecha de los widgets
                ],
              ),
            ),
            Expanded(
              flex: 8,  // Espacio vertical correspondiente
              child: Row(  // Fila para seleccionar el Nº de ingredientes
                children: [
                  const Spacer(flex: 5),  // Espacio vacío a la izquierda de los widgets
                  const Text(
                    "Ingredientes:",  // Texto indicando que se trata del selector de Nº de ingredientes
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  const Spacer(flex: 3),  // Espacio vacío entre texto y botón de decrementar
                  Expanded(
                    flex: 9,
                    child: BotonContadorIngredientes("Remove", this.visible),
                  ),
                  const Spacer(flex: 1),  // Espacio vacío entre el botón de decrementar y el número de ingredientes
                  Expanded(
                    flex: 6,
                    child: Center(
                        child: Text(
                            '${context.watch<Ingredientes>().ingredientes}',  // Texto indicando el número de ingredientes
                            style: const TextStyle(
                                fontSize: 20
                            )
                        )
                    ),
                  ),
                  const Spacer(flex: 1),  // Espacio vacío entre el número de ingredientes y el botón de incrementar
                  Expanded(
                    flex: 9,
                    child: BotonContadorIngredientes("Add", this.visible),
                  ),
                  SizedBox(
                      height: 55,
                      width: 100,
                      child: ConfiguradorIngredientes(update)
                  ),
                  const Spacer(flex: 6),  // Espacio vacío a la derecha de los widgets
                ],
              ),
            ),
            Expanded(
                flex: 8,
                child: Row(
                  children: [
                    const Spacer(flex: 65),
                    Expanded(
                        flex: 25,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: BotonBuscar(),
                        )
                    ),
                    const Spacer(flex: 5),
                  ],
                )
            ),
            widget.orientacion == "Vertical" ?  // Si la orientación del dispositivo es vertical
            const Expanded(
                flex: 50,   // utilizamos la mitad inferior de la pantalla para el widget en el que se muestra la lista de recetas
                child: LayoutRecetas("Vertical")
            )
                : const Spacer(flex: 1,)  // Si la orientación es horizontal establecemos un espacio vacío mínimo debajo del botón Buscar
          ],
        )
    );
  }
}


class AvisoError extends StatelessWidget{
  final String mensajeError;

  const AvisoError(this.mensajeError, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: Key("Error"),
      title: const Icon(CupertinoIcons.exclamationmark_bubble,
        color: Colors.green,
        size: 50,),
      content: Text(mensajeError, textAlign: TextAlign.center,),
      actions: <Widget>[
        TextButton(
          key: Key("Boton OK"),
          onPressed: () =>
              Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}


class LayoutRecetas extends StatelessWidget {
  final String orientacion;  // Guardamos la orientación del dispositivo

  const LayoutRecetas(this.orientacion, {super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,  // Establecemos el tamaño inicial del widget al total de su padre
      minChildSize: 1.0,  // Tamaño mínimo del widget (el total de su padre)
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            // Padding para que no se borre la línea curva verde (si la orientación es vertical por la parte superior y si es horizontal por la parte izquierda)
            padding: orientacion == "Vertical" ? const EdgeInsets.only(top: 10) : const EdgeInsets.only(left: 10, top: 10),
            decoration: orientacion == "Vertical" ?  // Si el dispositivo está vertical
            const BoxDecoration(  // Creamos curvas en los bordes superiores
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Colors.white, // Fondo blanco
              boxShadow: [
                BoxShadow(
                  color: Colors.green,  //Color de la curva
                  spreadRadius: 2,   // Grosor de la curva
                ),
              ],
            )
                :  // Si el dispositivo está horizontal
            const BoxDecoration(  // Creamos curvas en los bordes izquierdos
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              color: Colors.white,  // Fondo blanco
              boxShadow: [
                BoxShadow(
                  color: Colors.green,  // Color de la curva
                  spreadRadius: 2,  // Grosor de la curva
                ),
              ],
            ),
            child: ListaRecetas(orientacion)  // Creamos como hijo a la lista de recetas
        );
      },
    );
  }
}

class ListaRecetas extends StatelessWidget {
  final String orientacion;

  ListaRecetas(this.orientacion, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecipeBlock?> (
      future: context.watch<Recetas>().recetas,
      builder: (BuildContext context, AsyncSnapshot<RecipeBlock?> snapshot) {
        if (snapshot.hasError) {   // Si hubo error obteniendo información de Edamam
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //Image.asset('images/snoopy-penalty-box.gif'),
                  const Text('Ocurrió un error con la red'),  // Indicamos que hubo error
                  ElevatedButton(
                    child: const Text('Reintentar'),    // Y habilitamos botón para probar de nuevo la búsqueda
                    onPressed: () {},   //??????????????????????????????????????????
                  ),
                ],
              ),
            ),
          );
        }
        else if (snapshot.connectionState != ConnectionState.done) {  // Mientras la conexión para obtener datos de Edamam no termine mostramos un círculo de progreso
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else {   // Si no hubo errores y la conexión ha finalizado procedemos a mostrar la lista de recetas
          return Scaffold(
            resizeToAvoidBottomInset: false,  // Evitamos que el teclado redimensione pantalla
            body: Column(
              children: [
                Expanded(
                  child:
                  snapshot.data?.recipes?.length == null ?  // Si el contenido devuelto por Edamam es nulo mostramos que no se han encontrado recetas
                  Column(
                    children: const [
                      Spacer(flex: 15),
                      Center(
                          child: Icon(
                              Icons.sentiment_very_dissatisfied, size: 100
                          )
                      ),
                      Center(
                          child: Text(
                            "No se han encontrado recetas",
                            style: TextStyle(
                                fontSize: 25
                            ),
                          )
                      ),
                      Spacer(flex: 25)
                    ],
                  )
                      :   // Si Edamam devuelve contenido no vacío procedemos a mostrar las recetas
                  ListView.separated(
                    itemCount: (snapshot.data?.recipes?.length.toInt())!,  // Número de recetas a mostrar
                    itemBuilder: (context, index) {   // Mostramos cada receta de la siguiente forma
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 27,  // Tamaño imagen
                            child: OctoImage(image: NetworkImage((snapshot.data?.recipes?[index].image)!),  // Imagen de la receta
                              progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),   // Circulo de progreso mientras carga
                              errorBuilder: OctoError.icon(color: Colors.green,),    // Icono si no se obtuvo la imagen   CAMBIAR??????????????????????????????
                            ),
                          ),
                          title: Text(   // Nombre de la receta
                              (snapshot.data?.recipes?[index].label)!
                          ),
                          subtitle: Text("Kcal: ${(snapshot.data?.recipes?[index].calories?.toStringAsFixed(0))}     "
                              "     Ingredientes: ${(snapshot.data?.recipes?[index].ingredients?.length.toString())}"), // Nº de calorías e ingredientes
                          trailing: SizedBox(
                            height: 35,
                            width: 35,
                            child: FloatingActionButton(  // Botón para acceder al detalle de la receta
                              heroTag: "$index",  // Cada FloatingActionButon debe tener un heroTag único para que no se produzcan errores
                              onPressed: () => Navigator.push(  // Cuando se presiona el botón pasamos a una nueva pantalla
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LayoutDetalle((snapshot.data?.recipes?[index])!) // Pantalla de detalle de la receta LÍNEA ?????????????????????
                                  )
                              ),
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.green,),
                            ),
                          )
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {  // Separador entre recetas
                      return const Divider(
                        color: Colors.green,
                        thickness: 2,
                        indent: 16,  // Padding izquierdo
                        endIndent: 20,   // Padding derecho
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

//////////////////////// LIST VIEW /////////////////////////////////////////////
class CommonMethods {
  String prepareQuery(BuildContext context) {
    String nombreReceta = context.read<NombreReceta>().nombre_receta;
    String receta = "";
    if(nombreReceta.isNotEmpty) {
      receta = "&q=$nombreReceta";
    }

    String min = context.read<MinMaxCalorias>().min;
    String max = context.read<MinMaxCalorias>().max;
    String calorias = "";
    if(min.isEmpty){
      if(max.isNotEmpty){
        calorias = "&calories=$max";
      }
    }else{
      if(max.isEmpty){
        calorias = "&calories=$min%2B";
      }else{
        calorias = "&calories=$min-$max";
      }
    }

    List<Opcion> listaDietas = context.read<OpcionesSeleccionadas>().opcionesDietas;
    List<Opcion> listaAlergias = context.read<OpcionesSeleccionadas>().opcionesAlergias;
    String dietas = "";
    for(int i=0; i<listaDietas.length; i++){
      dietas += "&diet=${listaDietas[i].opcion}";
    }
    String alergias = "";
    for(int i=0; i<listaAlergias.length; i++){
      alergias += "&health=${listaAlergias[i].opcion}";
    }

    String ingredientes = "";
    if(context.read<Ingredientes>().aplicar){
      int numIngr = context.read<Ingredientes>().ingredientes;
      ingredientes = "&ingr=$numIngr";
    }

    return "$receta$ingredientes$dietas$alergias$calorias";
  }
}

class BotonBuscar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      key: Key("Buscar"),
      text: 'Buscar',
      onPress: () {
        CommonMethods methods = CommonMethods();
        String query = methods.prepareQuery(context);

        if(query.isNotEmpty){
          print(query);
          Provider.of<Recetas>(context, listen: false).buscarRecetas(query);
        }else{
          showDialog(
              context: context,
              builder: (BuildContext context) => const AvisoError("Rellene algún campo antes de realizar una búsqueda."));
        }
      },
      isReverse: true,
      selectedTextColor: Colors.black,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      backgroundColor: Colors.green,
      borderColor: Colors.green,
      borderRadius: 50,
      borderWidth: 2,
    );
  }
}

class BotonContadorIngredientes extends StatefulWidget{
  final String accion;
  final bool visible;

  const BotonContadorIngredientes(this.accion, this.visible, {super.key});

  @override
  _BotonContadorIngredientesState createState() => _BotonContadorIngredientesState();

}

class _BotonContadorIngredientesState extends State<BotonContadorIngredientes>{

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        key: Key(widget.accion),
        // Incrementamos o decrementamos el contador según el botón y escogemos el icono
        backgroundColor: widget.visible ? Colors.green : Colors.grey,
        heroTag: widget.accion == "Add" ? "Uno" : "Dos",  // Cada FloatingActionButon debe tener un heroTag único para que no se produzcan errores
        onPressed: () => {
          if(widget.visible){
            if(widget.accion == "Add"){
              context.read<Ingredientes>().increment()
            }else{
              if(context.read<Ingredientes>().ingredientes == 2){
                showDialog(context: context, builder: (BuildContext context) => const AvisoError("El mínimo de ingredientes son 2")),
              }else{
                context.read<Ingredientes>().decrement()
              }
            }
          }else{
            null
          }
        },
        child: Icon(widget.accion == "Add" ? Icons.add : Icons.remove));
  }
}


class BuscadorNombreReceta extends StatelessWidget {
  FocusNode myFocusNode = FocusNode();       // widget para pedir o soltar foco
  RegExp regex = RegExp(r'^[a-zA-Z ]*$');  // regex que solo permite letras y espacios
  final fieldText = TextEditingController();   // controlador del texto que se introduce en el widget

  @override
  Widget build(BuildContext context) {

    fieldText.text = context.read<NombreReceta>().nombre_receta;  // Valor inicial del texto del widget

    return TextFormField(
        key: const Key('Nombre receta'),
        focusNode: myFocusNode,
        controller: fieldText,
        decoration: const InputDecoration(
            filled: true,  // Fondo gris del widget
            icon: Icon(Icons.search),
            labelText: "Receta",
            hintText: "Buscar"
        ),
        onTap: () => myFocusNode.requestFocus(), // Cuando tocamos el widget se pide el foco

        onChanged: (text) => {  // Cuando el texto del widget cambia
          if(regex.hasMatch(text)){  // Comprobamos si el texto introducido cumple das reglas definidas en el regex
            context.read<NombreReceta>().set_nombre_receta(text),   // Si las cumple actualizamos el provider con el nuevo nombre de receta
          }else{     // Si no las cumple
            showDialog(context: context, builder: (BuildContext context) => const AvisoError("Solo se permiten letras y espacios")),  // Avisamos del error
            context.read<NombreReceta>().set_nombre_receta(""),   // Actualizamos nombre de receta a vacío
            fieldText.clear(),    // Eliminamos el texto del widget
            myFocusNode.unfocus()    // Quitamos foco del widget
          }
        }
    );
  }
}


class Calorias extends StatelessWidget {
  final String limite;  // Variable donde guardamos si se trata del máximo o mínimo de calorías
  FocusNode myFocusNode = FocusNode();     // widget para pedir o soltar foco
  final fieldText = TextEditingController();   // controlador del texto que se introduce en el widget
  RegExp regex = RegExp(r'^[0-9]*$');  // regex que solo permite dígitos (0-9)

  Calorias(this.limite);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        key: Key(limite),
        focusNode: myFocusNode,
        controller: fieldText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),  // Padding interno del widget
          filled: true,  // Fondo gris
          labelText: limite,
        ),

        onTap: () => myFocusNode.requestFocus(),  // Cuando tocamos el widget se pide el foco

        onChanged: (text) => {   // Cuando el texto del widget cambia
          if(regex.hasMatch(text)){  // Comprobamos si el texto introducido cumple las reglas del regex
            limite == "Min" ? context.read<MinMaxCalorias>().set_min(text)   // Si las cumple actualizamos el mínimo o máximo de calorías en el provider
                : context.read<MinMaxCalorias>().set_max(text),
          }else{     // Si no las cumple
            showDialog(context: context, builder: (BuildContext context) => const AvisoError("Solo se permiten dígitos")),  // Avisamos del error
            limite == "Min" ? context.read<MinMaxCalorias>().set_min("")
                : context.read<MinMaxCalorias>().set_max(""), // Actualizamos el mínimo o máximo de calorías a vacío
            fieldText.clear(),    // Eliminamos el texto del widget
            myFocusNode.unfocus(),    // Quitamos foco del widget
          }
        }
    );
  }
}


ListaOpciones listaAux = ListaOpciones();  // Variable con la lista de opciones para dietas y alergias

class Selector extends StatelessWidget {
  final String seleccion;  // Variable donde guardamos si estamos trabajando con dietas o alergias

  Selector(this.seleccion, {super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> _openFilterDialogOpciones() async {
      await FilterListDialog.display<Opcion>(   // Widget encargado de mostrar el diálogo
          context,
          resetButtonText: "Borrar",
          applyButtonText: "Guardar",
          hideSearchField: true,  // Ocultamos el buscador de opciones (???????????????????????????????????????)
          selectedItemsText: "Seleccionadas",  // Texto que se muestra al lado del número de opciones seleccionadas
          themeData: FilterListThemeData(context),
          headlineText: 'Selecciona  ${seleccion}', // Título del cuadro de diálogo

          // Lista de opciones disponibles (de dietas o alergias dependiendo del caso)
          listData: seleccion == "Dietas" ? listaAux.dietas
              : listaAux.alergias,

          // Lista donde se leen las opciones seleccionadas (leemos la lista del provider)
          selectedListData: seleccion == "Dietas" ? context.read<OpcionesSeleccionadas>().opcionesDietas
              : context.read<OpcionesSeleccionadas>().opcionesAlergias,

          choiceChipLabel: (item) => item!.opcion,  // Texto de la opción
          validateSelectedItem: (list, val) => list!.contains(val),  // Identifica si una opción está seleccionada o no
          controlButtons: [ControlButtonType.Reset],  // Añadimos un botón de borrar todas las opciones seleccionadas
          onItemSearch: (opt, query) {  // Acción a realizar en la búsqueda (obligatorio pese a tenerla deshabilitada)
            return opt.opcion.toLowerCase().contains(query.toLowerCase());
          },

          onApplyButtonClick: (list) {  // Cuando clickamos en el botón guardar
            // Guardamos en la lista correspondiente del provider (Dietas o Alergias) las opciones seleccionadas
            seleccion == "Dietas" ? context.read<OpcionesSeleccionadas>().set_opciones_dietas(List.from(list!))
                : context.read<OpcionesSeleccionadas>().set_opciones_alergias(List.from(list!));
            Navigator.pop(context);  // Y salimos del cuadro de diálogo
          }
      );
    }

    return ElevatedButton.icon(  // Creamos el botón
        key: Key(seleccion),
        onPressed: _openFilterDialogOpciones,  // Función que dispara el diálogo para seleccionar las opciones
        icon: const Icon(Icons.arrow_forward_ios),
        label: Text(
            seleccion,  // El texto correspondiente del botón (Dietas o Alergias)
            style: const TextStyle(
                fontSize: 16
            )
        )
    );
  }
}

class Opcion {
  final String _opcion;

  Opcion(this._opcion);

  String get opcion => _opcion;
}

class ListaOpciones {
  final List<Opcion> _dietas = [
    Opcion("balanced"),
    Opcion("high-fiber"),
    Opcion("high-protein"),
    Opcion("low-carb"),
    Opcion("low-fat"),
    Opcion("low-sodium")
  ];

  final List<Opcion> _alergias = [
    Opcion("alcohol-cocktail"),
    Opcion("alcohol-free"),
    Opcion("celery-free"),
    Opcion("crustacean-free"),
    Opcion("dairy-free"),
    Opcion("DASH"),
    Opcion("egg-free"),
    Opcion("fish-free"),
    Opcion("fodmap-free"),
    Opcion("gluten-free"),
    Opcion("immuno-supportive"),
    Opcion("keto-friendly"),
    Opcion("kidney-friendly"),
    Opcion("kosher"),
    Opcion("low-fat-abs"),
    Opcion("low-potassium"),
    Opcion("low-sugar"),
    Opcion("lupine-free"),
    Opcion("Mediterranean"),
    Opcion("mollusk-free"),
    Opcion("mustard-free"),
    Opcion("no-oil-added"),
    Opcion("paleo"),
    Opcion("peanut-free"),
    Opcion("pescatarian"),
    Opcion("pork-free"),
    Opcion("red-meat-free"),
    Opcion("sesame-free"),
    Opcion("shellfish-free"),
    Opcion("soy-free"),
    Opcion("sugar-conscious"),
    Opcion("sulfite-free"),
    Opcion("tree-nut-free"),
    Opcion("vegan"),
    Opcion("vegetarian"),
    Opcion("wheat-free")
  ];

  ListaOpciones();  // Constructor

  List<Opcion> get dietas => _dietas;

  List<Opcion> get alergias => _alergias;
}

class ConfiguradorIngredientes extends StatefulWidget {
  Function update;

  ConfiguradorIngredientes(this.update, {super.key});

  @override
  State<ConfiguradorIngredientes> createState() => _ConfiguradorIngredientesState();
}

class _ConfiguradorIngredientesState extends State<ConfiguradorIngredientes> {
  bool confIngredientes = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        key: const Key('Switch'),
        value: confIngredientes,
        onChanged: (bool value) {
          setState(() {
            confIngredientes = value;
            context.read<Ingredientes>().cambiarValor(value);
            widget.update(value);
          });
        }
    );
  }
}