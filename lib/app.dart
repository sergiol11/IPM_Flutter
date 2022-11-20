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
        // Detector para tocar pantalla y quitarle el foco al widget que lo tenga en ese momento.
        child: GestureDetector(   
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: MaterialApp(  // Aplicación
                theme: ThemeData(
                  primarySwatch: Colors.green,
                ),
                home: const MasterDetail()
            )
        )
    );
  }
}


class MasterDetail extends StatelessWidget {

  const MasterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Comprobamos si el dispositivo está en vertical o en horizontal.
          bool chooseMasterAndDetail = (   
              constraints.smallest.longestSide > breakPoint &&
                  MediaQuery.of(context).orientation == Orientation.landscape
          );
          // Cargamos el diseño horizontal o el vertical según la orientación del dispositivo.
          return chooseMasterAndDetail ? const LayoutHorizontal() : const LayoutVertical();  
        }
    );
  }
}


class LayoutVertical extends StatelessWidget {

  const LayoutVertical({super.key});

  @override
  Widget build(BuildContext context) {
    // Le enviamos el string "Vertical" para que más tarde sepa que widgets 
    // cargar y cuales no.
    return const Botones("Vertical"); 
  }
}

class Botones extends StatefulWidget{
  final String orientacion;

  const Botones(this.orientacion, {super.key});

  @override
  _Botones createState() => _Botones();
}

class _Botones extends State<Botones>{
  // Esta variable indica si la búsqueda de recetas tiene que aplicar el filtro
  // de límite de ingredientes.
  late bool permitirIngr;

  @override
  void initState() {
    super.initState();
    // Inicialmente permitimos aplicar el filtro de límite de ingredientes
    // en las próximas búsquedas.
    permitirIngr = true;
  }

  // Este método será llamado por el SwitchListTile para reconstruír los botones
  // con respecto al valor de la variable "permitirIngr".
  update(bool valor){
    setState(() {
      permitirIngr = valor;
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
                      child: BuscadorNombreReceta() // Clase que contiene el TextFormField para el nombre de recetas.
                  ),
                  Spacer(flex: 15),  // Espacio vacío a la derecha
                ],
              ),
            ),
            widget.orientacion == "Vertical" ?  // Si la orientación del dispositivo es vertical utilizamos un botón para Dietas y otro para Alergias
            Expanded(
                flex: 8,  // Espacio vertical correspondiente
                child: Row(   // Fila para el botón Dietas y el botón Alergias
                  children: [
                    Spacer(flex: 7),  // Espacio vacío a la izquierda de los botones
                    Expanded(
                      flex: 35,
                      child: Selector("Dietas"),  // Clase que contiene el botón para dietas
                    ),
                    Spacer(flex: 15),  // Espacio que separa los botones
                    Expanded(
                      flex: 35,
                      child: Selector("Alergias"),  // Clase que contiene el botón para alergias
                    ),
                    Spacer(flex: 7),  // Espacio vacío a la derecha de los botones
                  ],
                )
            )
                :   // Si la orientación del dispositivo es horizontal utilizamos un único botón para Dietas y Alergias
            Expanded(
                flex: 8,  // Espacio vertical correspondiente
                child: Row(  // Fila para el botón
                  children: const [
                    Spacer(flex: 15,),  // Espacio vacío a la izquierda de los botones
                    Expanded(
                        flex: 70,
                        child: SelectorHorizontal()  // Clase que contiene el botón para dietas y alergias.
                    ),
                    Spacer(flex: 15,)   // Espacio vacío a la derecha de los botones
                  ],
                )
            ),
            Expanded(
              flex: 8,  // Espacio vertical correspondiente
              child: Row(   // Fila con los TextFormFields para las kcal.
                children: [
                  const Spacer(flex: 5),  // Espacio vacío a la izquierda de los widgets
                  const Expanded(
                      flex: 23,
                      child: Text("Kcal:",  // Texto indicando que son los widgets para indicar las calorías.
                        style: TextStyle(
                            fontSize: 22
                        ),
                      )
                  ),
                  Expanded(
                      flex: 31,
                      // Clase que contiene el el TextFormField para introducir el mínimo de kcal.
                      child: Calorias("Min")
                  ),
                  Spacer(flex: 3),  // Espacio entre los widgets
                  Expanded(
                      flex: 31,
                      // Clase que contiene el el TextFormField para introducir el máximo de kcal.
                      child: Calorias("Max")
                  ),
                  Spacer(flex: 6)  // Espacio vacío a la derecha de los widgets
                ],
              ),
            ),
            Expanded(
              flex: 8,  // Espacio vertical correspondiente
              child: Row(  // Fila donde estarán los widgets que configuran el número de ingredientes máximo.
                children: [
                  const Spacer(flex: 5),  // Espacio vacío a la izquierda de los widgets
                  const Text(
                    "Ingredientes:",  // Texto indicativo.
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  const Spacer(flex: 3),  // Espacio vacío entre el texto y el botón de decrementar
                  Expanded(
                    flex: 9,
                    // Clase que contiene el botón que permite disminuir el límite de ingredientes máximo.
                    child: BotonContadorIngredientes("Remove", this.permitirIngr),
                  ),
                  const Spacer(flex: 1),  // Espacio vacío entre el botón de decrementar y el número de ingredientes
                  Expanded(
                    flex: 6,
                    child: Center(
                        child: Text( // Texto indicando el número de ingredientes
                            // Se escucha en todo momento el valor que tiene la variable en el provider.
                            // Esto permite que siempre se muestre dicho valor en tiempo real.
                            '${context.watch<Ingredientes>().ingredientes}',
                            style: const TextStyle(
                                fontSize: 20
                            )
                        )
                    ),
                  ),
                  const Spacer(flex: 1),  // Espacio vacío entre el número de ingredientes y el botón de incrementar
                  Expanded(
                    flex: 9,
                    // Clase que contiene el botón que permite aumentar el límite de ingredientes máximo.
                    child: BotonContadorIngredientes("Add", this.permitirIngr),
                  ),
                  SizedBox(
                      height: 55,
                      width: 100,
                      // Clase que contiene el SwitchListTile que decide si se
                      // aplica o no el límite de ingredientes en la búsqueda.
                      child: ConfiguradorIngredientes(update)
                  ),
                  const Spacer(flex: 6),  // Espacio vacío a la derecha de los widgets
                ],
              ),
            ),
            Expanded(
                flex: 8,
                child: Row( // Fila que contiene el botón que realiza la búsqueda.
                  children: [
                    const Spacer(flex: 65), // Más espacio a la izquierda del botón.
                    Expanded(
                        flex: 25,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: BotonBuscar(), // Clase que contiene el botón que realiza la búsqueda.
                        )
                    ),
                    const Spacer(flex: 5), // Menos espacio a la derecha del botón.
                  ],
                )
            ),
            widget.orientacion == "Vertical" ?
            const Expanded(
                // Si la orientación del dispositivo es vertical utilizamos la mitad
                // inferior de la pantalla para el widget en el que se muestra la lista de recetas
                flex: 50,
                child: LayoutRecetas("Vertical") // Clase que contiene la lista de recetas encontradas.
            )
                : const Spacer(flex: 1,)  // Si la orientación es horizontal establecemos un espacio vacío mínimo debajo del botón de búsqueda.
          ],
        )
    );
  }
}

// Clase que contiene el AlertDialog que se lanza en los distintos casos de error.
class AvisoError extends StatelessWidget{
  // Este es el mensaje que se mostrará en el AlertDialog. Como el mensaje
  // es distinto dependiendo de cada caso, se le envía en el momento en el que
  // se le llama.
  final String mensajeError;

  const AvisoError(this.mensajeError, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: Key("Error"), // Clave para encontrar el widget en los test.
      title: const Icon(CupertinoIcons.exclamationmark_bubble,
        color: Colors.green,
        size: 50,),
      content: Text(mensajeError, textAlign: TextAlign.center,),
      actions: <Widget>[
        TextButton( // Botón que permite cerrar el AlertDialog.
          key: Key("Boton OK"), // Clave para encontrar el widget en los test.
          onPressed: () =>
              Navigator.pop(context), // Acción que cierra el AlertDialog cuando pulsas en el botón.
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// Clase que contiene el widget que permite hacer scroll.
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
            // Padding para que no se sopreponga nada a la línea curva verde.
            // Si la orientación es vertical, el padding se aplica en la parte superior,
            // si es horizontal por la parte izquierda.
            padding: orientacion == "Vertical" ? const EdgeInsets.only(top: 10) : const EdgeInsets.only(left: 10, top: 10),
            decoration: orientacion == "Vertical" ?
            // Si el dispositivo está vertical
            const BoxDecoration(  // Creamos curvas en los bordes superiores
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Colors.white, // Fondo blanco
              boxShadow: [
                BoxShadow(
                  color: Colors.green,  // Color de la curva
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
            // Creamos como hija la clase que contiene la lista de recetas encontradas.
            // Esto permitirá hacer scroll en dicha lista.
            child: ListaRecetas()
        );
      },
    );
  }
}

// Clase que contiene la lista donde se mostrarán las recetas encontradas.
class ListaRecetas extends StatelessWidget {

  ListaRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecipeBlock?> (
      // El future escucha en tiempo real el valor que tiene la variable en el provider.
      // Esa variable contiene el RecipeBlock que usaremos para mostrar las recetas.
      future: context.watch<Recetas>().recetas,
      builder: (BuildContext context, AsyncSnapshot<RecipeBlock?> snapshot) {
        if (snapshot.hasError) {   // Si hubo error obteniendo información de Edamam
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Mostramos un texto indicando el error.
                  const Text('Ocurrió un error con la red'),
                  ElevatedButton(
                    child: const Text('Reintentar'), // Habilitamos un botón para probar de nuevo la búsqueda.
                    onPressed: () {
                      // Llamamos al método del provider que vuelve a realizar la
                      // búsqueda anterior. Esto actualizará la variable que se lee
                      // a tiempo real y se recargará la lista.
                      Provider.of<Recetas>(context, listen: false).realizarBusquedaAnterior();
                    },
                  ),
                ],
              ),
            ),
          );
        }
        else if (snapshot.connectionState != ConnectionState.done) {
          // Mientras la conexión para obtener datos de Edamam no termine mostramos un círculo de progreso
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          // Si no hubo errores y la conexión ha finalizado procedemos a mostrar la lista de recetas
          return Scaffold(
            resizeToAvoidBottomInset: false,  // Evitamos que el teclado redimensione pantalla
            body: Column(
              children: [
                Expanded(
                  child:
                  snapshot.data?.recipes?.length == null ?
                  // Si el contenido devuelto por Edamam es nulo mostramos
                  // un icono y un texto indicándolo.
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
                    itemBuilder: (context, index) { // Bucle que devuelve un ListTile por cada receta.
                      return ListTile(
                          // Imagen de la receta.
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 27,  // Tamaño imagen
                            child: OctoImage(image: NetworkImage((snapshot.data?.recipes?[index].image)!),
                              // Spinner mientras carga.
                              progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),
                              // Icono mostrado si no se obtuvo la imagen real.
                              errorBuilder: OctoError.icon(color: Colors.green,),
                            ),
                          ),
                          title: Text(   // Nombre de la receta
                              (snapshot.data?.recipes?[index].label)!
                          ),
                          subtitle: Text( // Nº de calorías e ingredientes
                              "Kcal: ${(snapshot.data?.recipes?[index].calories?.toStringAsFixed(0))}     "
                              "     Ingredientes: ${(snapshot.data?.recipes?[index].ingredients?.length.toString())}"
                          ),
                          trailing: SizedBox(
                            height: 35,
                            width: 35,
                            child: FloatingActionButton(  // Botón para acceder al detalle de la receta
                              // Cada FloatingActionButon debe tener un heroTag único para que no se produzcan errores
                              heroTag: "$index",
                              onPressed: () => Navigator.push(  // Cuando se presiona el botón cambiamos a la pantalla de detalle de la receta.
                                  context,
                                  MaterialPageRoute(
                                      // Pantalla de detalle de la receta.
                                      // Le enviamos por constructor la información de la receta concreta para que pueda utilizarla en la otra pantalla.
                                      builder: (context) => LayoutDetalle((snapshot.data?.recipes?[index])!)
                                  )
                              ),
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.green,),
                            ),
                          )
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      // Separador entre recetas
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

// Clase que permite definir métodos que cualquier otra clase puede utilizar.
class CommonMethods {
  // Método que se encarga de leer del provider los valores introducidos en los
  // distintos widgets y prepara la query (String) que se enviará a edamam.dart
  String prepareQuery(BuildContext context) {
    String nombreReceta = context.read<NombreReceta>().nombre_receta;
    String receta = "";
    if(nombreReceta.isNotEmpty) {
      // Si el TextFormField del nombre de la receta no está vacío guardamos su
      // contenido en la query.
      receta = "&q=$nombreReceta";
    }

    String min = context.read<MinMaxCalorias>().min;
    String max = context.read<MinMaxCalorias>().max;
    String calorias = "";
    if(min.isEmpty){
      // El TextFormField del mínimo de calorías SÍ está vacío, por lo que no
      // guardamos su contenido en la query.
      if(max.isNotEmpty){
        // El TextFormField del máximo de calorías NO  está vacío, por lo que
        // solo guardamos el máximo en la query.
        calorias = "&calories=$max";
      }
    }else{
      if(max.isEmpty){
        // El TextFormField del máximo de calorías SÍ está vacío, por lo que solo
        // guardamos el mínimo en la query.
        calorias = "&calories=$min%2B";
      }else{
        // El TextFormField del máximo de calorías NO  está vacío, por lo que
        // guardamos mínimo y máximo el máximo en la query.
        calorias = "&calories=$min-$max";
      }
    }

    List<Opcion> listaDietas = context.read<OpcionesSeleccionadas>().opcionesDietas;
    List<Opcion> listaAlergias = context.read<OpcionesSeleccionadas>().opcionesAlergias;
    String dietas = "";
    for(int i=0; i<listaDietas.length; i++){
      // Por cada dieta seleccionada en el FilterListDialog la guardamos en la query.
      dietas += "&diet=${listaDietas[i].opcion}";
    }
    String alergias = "";
    for(int i=0; i<listaAlergias.length; i++){
      // Por cada alergia seleccionada en el FilterListDialog la guardamos en la query.
      alergias += "&health=${listaAlergias[i].opcion}";
    }

    String ingredientes = "";
    if(context.read<Ingredientes>().aplicar){
      // Si se puede aplicar el filtro de límite máximo de ingredientes guardamos
      // dicho límite en la query.
      int numIngr = context.read<Ingredientes>().ingredientes;
      ingredientes = "&ingr=$numIngr";
    }

    return "$receta$ingredientes$dietas$alergias$calorias";
  }
}

// Clase que contiene el botón que permite realizar la búsqueda de recetas.
class BotonBuscar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      key: Key("Buscar"), // Clave para encontrar el widget en los test.
      text: 'Buscar',
      onPress: () {
        CommonMethods methods = CommonMethods();
        // Cuando se pulsa el botón llamamos al método "prepareQuery" para que
        // nos devuelva la query que tenemos que enviar a edamam.
        String query = methods.prepareQuery(context);

        if(query.isNotEmpty){
          print(query);
          // Le enviamos la query al provider, para que se comunique con edamam
          // y guarde el RecipeBlock actual, que la lista estará escuchando en tiempo real.
          Provider.of<Recetas>(context, listen: false).buscarRecetas(query);
        }else{
          // Si la query está vacía significa que no se rellenó nada en la app,
          // por tanto mostramos un AlertDialog con el mensaje correspondiente.
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

// Clase que contiene los botones que permiten incrementar o decrementar el
// límite máximo de ingredientes.
class BotonContadorIngredientes extends StatefulWidget{
  final String accion; // Variable que indica si la acción a realizar es de incremento o disminución.
  final bool permitirIngr; // Variable que indica si los botones están disponibles.

  const BotonContadorIngredientes(this.accion, this.permitirIngr, {super.key});

  @override
  _BotonContadorIngredientesState createState() => _BotonContadorIngredientesState();

}

class _BotonContadorIngredientesState extends State<BotonContadorIngredientes>{

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        key: Key(widget.accion), // Clave para encontrar el widget en los test.
        // Si los botones están disponibles los pintamos de verde, sino de gris.
        backgroundColor: widget.permitirIngr ? Colors.green : Colors.grey,
        // Cada FloatingActionButon debe tener un heroTag único para que no se produzcan errores
        heroTag: widget.accion == "Add" ? "Uno" : "Dos",
        onPressed: () => {
          if(widget.permitirIngr){ // Si los botones están disponibles:
            if(widget.accion == "Add"){
              // Si la acción es de incremento avisamos al provider de que sume 1.
              context.read<Ingredientes>().increment()
            }else{ // Si la acción es de disminución:
              if(context.read<Ingredientes>().ingredientes == 2){
                // Comprobamos si el número actual es 2 (el mínimo) y por tanto no se puede realizar la disminución.
                // Además lanzamos un AlertDialog con el mensaje correspondiente.
                showDialog(context: context, builder: (BuildContext context) => const AvisoError("El mínimo de ingredientes son 2")),
              }else{
                // Avisamos al provider de que reste 1.
                context.read<Ingredientes>().decrement()
              }
            }
          }else{
            // Si los botones no están disponibles no realizarán nada cuando los pulsas.
            null
          }
        },
        child: Icon(widget.accion == "Add" ? Icons.add : Icons.remove));
  }
}

// Clase que contiene el TextFormField que permite introducir el nombre de la receta.
class BuscadorNombreReceta extends StatelessWidget {
  FocusNode myFocusNode = FocusNode();  // Widget para pedir o soltar foco
  RegExp regex = RegExp(r'^[a-zA-Z ]*$');  // Regex que solo permite letras y espacios
  final fieldText = TextEditingController();   // Controlador del texto que se introduce en el widget

  @override
  Widget build(BuildContext context) {

    // Valor inicial del texto del TextFormField. Lo encontramos guardado en el provider.
    fieldText.text = context.read<NombreReceta>().nombre_receta;

    return TextFormField(
        key: const Key('Nombre receta'),  // Clave para encontrar el widget en los test.
        focusNode: myFocusNode,
        controller: fieldText,
        decoration: const InputDecoration(
            filled: true,  // Fondo gris del widget
            icon: Icon(Icons.search),
            labelText: "Receta",
            hintText: "Buscar"
        ),
        onTap: () => myFocusNode.requestFocus(), // Cuando tocamos el widget se pide el foco.

        onChanged: (text) => {  // Cuando el texto del widget cambia.
          if(regex.hasMatch(text)){  // Comprobamos si el texto introducido cumple las reglas definidas en el regex.
            context.read<NombreReceta>().set_nombre_receta(text),   // Si las cumple actualizamos el provider con el nuevo nombre de receta.
          }else{  // Si no las cumple lanzamos un AlertDialog con el mensaje correspondiente.
            showDialog(context: context, builder: (BuildContext context) => const AvisoError("Solo se permiten letras y espacios")),
            context.read<NombreReceta>().set_nombre_receta(""),   // Le enviamos al provider un texto vacío para que lo guarde.
            fieldText.clear(),    // Eliminamos el texto del widget.
            myFocusNode.unfocus()    // Quitamos foco del widget.
          }
        }
    );
  }
}

// Clase que contiene el TextFormField que permite introducir el valor mínimo y máximo de kcal.
class Calorias extends StatefulWidget {
  final String limite;

  const Calorias(this.limite, {super.key});

  @override
  State<Calorias> createState() => _CaloriasState(limite);
}


class _CaloriasState extends State<Calorias> {
  final String limite;  // Variable que indica si el valor a introducir es de mínimo o máximo.
  FocusNode myFocusNode = FocusNode();   // Widget para pedir o soltar foco
  final fieldText = TextEditingController();   // Controlador del texto que se introduce en el widget
  RegExp regex = RegExp(r'^[0-9]*$');  // Regex que solo permite dígitos (0-9)

  _CaloriasState(this.limite);

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    fieldText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        key: Key(limite), // Clave para encontrar el widget en los test.
        focusNode: myFocusNode,
        controller: fieldText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),  // Padding interno del widget
          filled: true,  // Fondo gris
          labelText: limite,
        ),

        onTap: () => myFocusNode.requestFocus(),  // Cuando tocamos el widget se pide el foco.

        onChanged: (text) => {   // Cuando el texto del widget cambia
          if(regex.hasMatch(text)){  // Comprobamos si el texto introducido cumple las reglas del regex
            // Si las cumple actualizamos el provider con el nuevo mínimo o máximo de kcal.
            limite == "Min" ? context.read<MinMaxCalorias>().set_min(text)
                : context.read<MinMaxCalorias>().set_max(text),
          }else{  // Si no las cumple lanzamos un AlertDialog con el mensaje correspondiente.
            showDialog(context: context, builder: (BuildContext context) => const AvisoError("Solo se permiten dígitos")),
            limite == "Min" ? context.read<MinMaxCalorias>().set_min("")
                : context.read<MinMaxCalorias>().set_max(""), // Le enviamos al provider un texto vacío para que lo guarde.
            fieldText.clear(),    // Eliminamos el texto del widget.
            myFocusNode.unfocus(),    // Quitamos foco del widget.
          }
        }
    );
  }
}


ListaOpciones listaAux = ListaOpciones();  // Variable con la lista de opciones para dietas y alergias

// Clase que contiene el botón que permite seleccionar a través de un FilterListDialog
// las dietas o alergias.
class Selector extends StatelessWidget {
  final String seleccion;  // Variable que indica si se quieren seleccionar dietas o alergias.

  Selector(this.seleccion, {super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> _openFilterDialogOpciones() async {
      await FilterListDialog.display<Opcion>(   // Widget encargado de mostrar el diálogo
          context,
          resetButtonText: "Borrar",
          applyButtonText: "Guardar",
          hideSearchField: true,  // Ocultamos el buscador de opciones.
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

    // Botón que permite abrir el FilterListDialog con las distintas opciones.
    return ElevatedButton.icon(
        key: Key(seleccion), // Clave para encontrar el widget en los test.
        onPressed: _openFilterDialogOpciones,  // Acción que abre el FilterListDialog.
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

// Clase para crear objetos que representen las opciones del FilterListDialog.
class Opcion {
  final String _opcion;

  Opcion(this._opcion);

  String get opcion => _opcion;
}

// Clase que guarda las 2 listas de opciones disponibles en el FilterListDialog.
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

  ListaOpciones();

  List<Opcion> get dietas => _dietas;

  List<Opcion> get alergias => _alergias;
}

// Clase que contiene el SwitchListTile que permité decidir si aplicar el filtro
// de límite máximo de ingredientes.
class ConfiguradorIngredientes extends StatefulWidget {
  // Recibe por parámetro la función que se encarga de avisar a los botones de
  // si se tienen que habilitar o deshabilitar.
  Function update;

  ConfiguradorIngredientes(this.update, {super.key});

  @override
  State<ConfiguradorIngredientes> createState() => _ConfiguradorIngredientesState();
}

class _ConfiguradorIngredientesState extends State<ConfiguradorIngredientes> {
  // Variable que usa de referencia para saber si mostrarse activado o desactivado.
  bool confIngredientes = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        key: const Key('Switch'), // Clave para encontrar el widget en los test.
        value: confIngredientes,
        onChanged: (bool value) { // Cuando lo pulsas:
          setState(() {
            confIngredientes = value; // Cambia su propio valor.
            // Avisa al provider de que actualice la variable que usará para saber
            // si aplicar el filtro de límite máximo de ingredientes o no.
            context.read<Ingredientes>().cambiarValor(value);
            widget.update(value); // Avisa a los botones de ingredientes de que se activen o desactiven.
          });
        }
    );
  }
}