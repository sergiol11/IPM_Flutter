import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:practica/detalle_receta.dart';
import 'package:practica/providers.dart';
import 'edamam.dart';
import 'layout_horizontal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:octo_image/octo_image.dart';

const int breakPoint = 600;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Ingredientes()),
          ChangeNotifierProvider(create: (_) => NombreReceta()),
          ChangeNotifierProvider(create: (_) => MinMaxCalorias()),
          ChangeNotifierProvider(create: (_) => OpcionesSeleccionadas()),
          ChangeNotifierProvider(create: (_) => InfoEdamamRecetas())
        ],
        child: GestureDetector(   // Tocar pantalla e quitar foco do widget no que esté
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: MaterialApp(
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
  final String title;

  const MasterDetail({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool chooseMasterAndDetail = (
              constraints.smallest.longestSide > breakPoint &&
                  MediaQuery.of(context).orientation == Orientation.landscape
          );
          return chooseMasterAndDetail ? LayoutHorizontal() : const LayoutVertical();  // Diseño horizontal o vertical
        }
    );
  }
}


class LayoutVertical extends StatelessWidget {
  final String texto = "buscar";

  const LayoutVertical({super.key});

  @override
  Widget build(BuildContext context) {
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
            Expanded(
                flex: 8,
                child:
                Image.asset('assets/images/Edamam_logo_full_RGB.png',
                    scale: 6
                )
            ),
            Expanded(
              flex: 8,
              child: Row(   // BuscadorNombreReceta
                children: const [
                  Spacer(flex: 15),
                  Expanded(
                      flex: 70,      // %
                      child: BuscadorNombreReceta()
                  ),
                  Spacer(flex: 15),
                ],
              ),
            ),
            widget.orientacion == "Vertical" ?    // 2 botones para Dietas y Alergias en vertical
            Expanded(
                flex: 8,
                child: Row(   // Botóns Dietas e Alergias
                  children: const [
                    Spacer(flex: 7),
                    Expanded(
                      flex: 35,
                      child: Selector(opcion: "Dietas"),
                    ),
                    Spacer(flex: 15),
                    Expanded(
                      flex: 35,
                      child: Selector(opcion: "Alergias"),
                    ),
                    Spacer(flex: 7),
                  ],
                )
            )
                :   // 1 solo botón para dietas y alergias en horizontal
            Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Expanded(
                        flex: 15,
                        child: Container()
                    ),
                    const Expanded(
                        flex: 70,
                        child: SelectorHorizontal()
                    ),
                    Expanded(
                        flex: 15,
                        child: Container()
                    )
                  ],
                )
            ),
            Expanded(
              flex: 8,
              child: Row(   // Calorías
                children: const [
                  Spacer(flex: 5),
                  Expanded(
                      flex: 23,
                      child: Text("Calorías:",
                        style: TextStyle(
                            fontSize: 22
                        ),
                      )
                  ),
                  Expanded(
                      flex: 31,
                      child: Calorias("Min",)
                  ),
                  Spacer(flex: 3),
                  Expanded(
                      flex: 31,
                      child: Calorias("Max",)
                  ),
                  Spacer(flex: 6)
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  const Spacer(flex: 5),
                  IgnorePointer(
                    ignoring: !visible,
                    child: AnimatedOpacity(
                      opacity: visible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Text("Ingredientes:",
                        style: TextStyle(
                            fontSize: 22
                        ),
                      )
                    ),
                  ),
                  const Spacer(flex: 3),
                  Expanded(
                    flex: 9,
                    child: IgnorePointer(
                      ignoring: !visible,
                      child: AnimatedOpacity(
                          opacity: visible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const BotonContadorIngredientes("Remove")
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 6,
                    child: IgnorePointer(
                      ignoring: !visible,
                      child: AnimatedOpacity(
                          opacity: visible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Center(
                              child: Text(
                                  '${context.watch<Ingredientes>().ingredientes}',
                                  style: const TextStyle(
                                      fontSize: 20
                                  )
                              )
                          )
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 9,
                    child: IgnorePointer(
                      ignoring: !visible,
                      child: AnimatedOpacity(
                          opacity: visible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const BotonContadorIngredientes("Add")
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 55,
                      width: 100,
                      child: ConfiguradorIngredientes(update)
                  ),
                  const Spacer(flex: 6),
                ],
              ),
            ),
            //Spacer(flex: orientacion == "Vertical" ? 50 : 1)
            widget.orientacion == "Vertical" ?
            const Expanded(
                flex: 50,
                child: LayoutRecetas("Vertical")
            )
                : const Spacer(flex: 1,)
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
      title: const Icon(CupertinoIcons.exclamationmark_bubble,
        color: Colors.green,
        size: 50,),
      content: Text(mensajeError, textAlign: TextAlign.center,),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

////////////////////////// LIST VIEW  ///////////////////////////////////////////
class LayoutRecetas extends StatelessWidget {
  final String orientacion;

  const LayoutRecetas(this.orientacion, {super.key});


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,  // Para que se mostre inicialmente coa altura de todo o fillo,
      minChildSize: 1.0,  // Mínima altura poñemos a de todito o fillo así forzamos que non se faga drag para abaixo!
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          // Padding para que non se vaia a curva!
            padding: orientacion == "Vertical" ? const EdgeInsets.only(top: 10) : const EdgeInsets.only(left: 10, top: 10),  // PADDING DO BOTÓN BUSCAR + PARA MANTER A CURVA VERDE!
            decoration: orientacion == "Vertical" ?
            const BoxDecoration(  // Borde curvo + color de borde negro
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.green,
                  spreadRadius: 1,
                ),
              ],
            )
                :
            const BoxDecoration(  // Borde curvo + color de borde negro
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.green,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ListaRecetas(orientacion)
        );
      },
    );
  }
}

class ListaRecetas extends StatefulWidget{
  final String orientacion;

  ListaRecetas(this.orientacion, {super.key});

  @override
  _ListaRecetas createState() => _ListaRecetas();
}

class _ListaRecetas extends State<ListaRecetas>{
  late Future<RecipeBlock?>? recetas;

  @override
  void initState() {
    super.initState();
    recetas = search_recipes("&q=salad");
  }

  String _parser(String? palabra){
    return palabra ?? "Error";   // Cambiar por outro mensaje!!!!!!!!!!!!!!!!!!!!!!
  }

  Recipe _parser_recipe(Recipe? receta){
    return receta ?? Recipe();
  }

  update(String query){
    setState(() {
      recetas = search_recipes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecipeBlock?> (
      future: recetas,
      builder: (BuildContext context, AsyncSnapshot<RecipeBlock?> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset('images/snoopy-penalty-box.gif'),
                  const Text('There was a network error'),
                  ElevatedButton(
                    child: const Text('Try again'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        }
        else if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          return Scaffold(
            resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
            body: Column(
              children: [
                Expanded(
                    flex: 10,
                    child: Row(
                      children: [
                        const Spacer(flex: 30),
                        Expanded(
                            flex: 40,
                            child: BotonBuscar(update)
                        ),
                        const Spacer(flex: 30),
                      ],
                    )
                ),
                Expanded(
                  flex: 90,
                  child: ListView.separated(
                    itemCount: snapshot.data?.recipes?.length.toInt() ?? 0,  // Asi controlamos cando nn devolve info edadmam pintamos lista vacia
                    itemBuilder: (context, index) {
                      return ListTile(    // ANTES AQUÍ COMPROBAR SE PARA ES ITEM TEMOS INFO DA RECETA!!! Senn devolver ListTIle con error!
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 27,  // Tamaño imagen
                            child: OctoImage(image: NetworkImage(_parser(snapshot.data?.recipes?[index].image)),  // Imagen
                            progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),   // Circulo de progreso
                            errorBuilder: OctoError.icon(color: Colors.green,),    // Icono si no se obtuvo la imagen
                            ),
                          ),
                          title: Text(_parser(snapshot.data?.recipes?[index].label)),
                          subtitle: Text("Calorias: ${_parser(snapshot.data?.recipes?[index].calories?.toStringAsFixed(0))}     "
                              "     Ingredientes: ${_parser(snapshot.data?.recipes?[index].ingredients?.length.toString())}"),
                          trailing: SizedBox(
                            height: 35,
                            width: 35,
                            child: FloatingActionButton(
                              heroTag: "$index",
                              onPressed: () => Navigator.push(
                                  context,      // Navegamos á próxima pantalla
                                  MaterialPageRoute(
                                      builder: (context) => LayoutDetalle(widget.orientacion, _parser_recipe(snapshot.data?.recipes?[index])) // Devolvemos a receta ou unha receta vacía se nn temos info
                                  )
                              ),
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.green,),
                            ),
                          )
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {  // Separador de elementos
                      return const Divider(
                        color: Colors.green,
                        thickness: 2,
                        indent: 16,  // Espacio inicial
                        endIndent: 20,   // Espacio final
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

/*class ImageBuilder extends StatefulWidget{
  final String? urlImagen;

  const ImageBuilder(this.urlImagen, {super.key});

  @override
  _ImageBuilderState createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder>{

  @override
  void initState() {
    super.initState();// Cast
  }

  /*Future<Image> getImagen(String? url) async {
    return widget.urlImagen != null
        ?
    Image.network(
      url!,
      frameBuilder: (_, image, loadingBuilder, __) {
        if (loadingBuilder == null) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return image;
      },
      loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return image;
        return Expanded(
          // height: 300,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Image.asset(   // Preparar imagen de error!!!!!!!!!!!!!!!!!!!!!!!
        'images/snoopy-penalty-box.gif',
        //height: 300,
        fit: BoxFit.fitHeight,
      ),
    )
        : Image.asset('assets/images/Edamam_logo_full_RGB.png', scale: 6);
  }*/

  Future<Image> getImagen(String? url) async {
    return url != null ? Image.network(url) : Image.network(url!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image> (
      future: getImagen(widget.urlImagen),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if(snapshot.hasData){    // CASO BON
          return InkWell(
            child: snapshot.data,
          );
        } else if(snapshot.hasError){   // CASO ERROR!
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset('images/snoopy-penalty-box.gif'),
                  const Text('There was a network error'),
                  ElevatedButton(
                    child: const Text('Try again'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        } else {     // CALQUERA OUTRO CASO
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}*/



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
  Function update;

  BotonBuscar(this.update, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: 'Buscar',
      onPress: () {
        CommonMethods methods = CommonMethods();
        String query = methods.prepareQuery(context);

        if(query.isNotEmpty){
          print(query);
          update(query);
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

  const BotonContadorIngredientes(this.accion, {super.key});

  @override
  _BotonContadorIngredientesState createState() => _BotonContadorIngredientesState();

}

class _BotonContadorIngredientesState extends State<BotonContadorIngredientes>{

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // Incrementamos o decrementamos el contador según el botón y escogemos el icono
        heroTag: widget.accion == "Add" ? "Uno" : "Dos",
        onPressed: () => {
          if(widget.accion == "Add"){    // Incrementar
            context.read<Ingredientes>().increment()
          }else{    // Decrementar
            if(context.read<Ingredientes>().ingredientes == 2){
              showDialog(context: context, builder: (BuildContext context) => const AvisoError("El mínimo de ingredientes son 2")),
            }else{
              context.read<Ingredientes>().decrement()
            }
          }
        },
        child: Icon(widget.accion == "Add" ? Icons.add : Icons.remove));
  }
}

class Calorias extends StatefulWidget {
  final String limite;

  const Calorias(this.limite, {super.key});

  @override
  State<Calorias> createState() => _CaloriasState();
}


class _CaloriasState extends State<Calorias> {     // É sin estdo???
  late FocusNode myFocusNode;
  final fieldText = TextEditingController();   // controlamos texto que se introduce
  RegExp regex = RegExp(r'^[0-9]*$');  // regex que solo permite digitos

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
        focusNode: myFocusNode,
        controller: fieldText,
        restorationId: 'name_field',
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),  // Facer menos alto o widget
          filled: true,
          labelText: widget.limite,
        ),
        onTap: () => myFocusNode.requestFocus(),
        // Gardamos cada cambio que ocurra por se usuario non lle da a OK no teclado cando escriba!
        onChanged: (text) => {
          if(regex.hasMatch(text)){  // Actualizamos provider si se cumplen las condiciones
            widget.limite == "Min" ? context.read<MinMaxCalorias>().set_min(text)
                : context.read<MinMaxCalorias>().set_max(text),
          }else{     // Lanzamos aviso se non se cumplen condicións
            showDialog(context: context, builder: (BuildContext context) => const AvisoError("Solo se permiten dígitos")),
            widget.limite == "Min" ? context.read<MinMaxCalorias>().set_min("")
                : context.read<MinMaxCalorias>().set_max(""), // Actualizamos calorias a vacío
            fieldText.clear(),    // Eliminamos texto del widget
            myFocusNode.unfocus(),    // Quitamos foco del campo
          }
        }
    );
  }
}


class BuscadorNombreReceta extends StatefulWidget {    // É sin estado?

  const BuscadorNombreReceta({super.key});

  @override
  State<BuscadorNombreReceta> createState() => _BuscadorNombreRecetaState();  // Esto non sei se poñer como cabrero ou como prueba
}


class _BuscadorNombreRecetaState extends State<BuscadorNombreReceta> {    // ESTARÍA GUAI QUE ESTO SUGIERA MENTRES ESTÁ BUSCANDO NOMES DE RECETAS!!!!!!!!!!!!!
  late FocusNode myFocusNode;
  RegExp regex = RegExp(r'^[a-zA-Z ]*$');  // regex que solo permite letras y espacios
  final fieldText = TextEditingController();   // controlamos texto que se introduce

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
        focusNode: myFocusNode,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        initialValue: "Salad",
        decoration: const InputDecoration(
            filled: true,
            icon: Icon(Icons.search),
            labelText: "Receta",
            hintText: "Buscar"
        ),
        onTap: () => myFocusNode.requestFocus(), // Para doble clic hai que usar Gesture!

        // Gardamos o nome da receta introducido cada vez que hai un cambio por se usuario non lle dá a OK no teclado
        onChanged: (text) => {
          if(regex.hasMatch(text)){  // Actualizamos provider si se cumplen las condiciones do texto
            context.read<NombreReceta>().set_nombre_receta(text),
          }else{     // Lanzamos aviso se non se cumplen condicións
            showDialog(context: context, builder: (BuildContext context) => const AvisoError("Solo se permiten letras y espacios")),
            context.read<NombreReceta>().set_nombre_receta(""),   // Actualizamos nombre a vacio
            fieldText.clear(),    // Eliminamos texto del widget
            myFocusNode.unfocus()    // Quitamos foco del campo
          }
        }
    );
  }
}

class Selector extends StatefulWidget {
  final String opcion;

  const Selector({super.key, required this.opcion});

  @override
  State<Selector> createState() => _SelectorState();
}

ListaOpciones listaAux = ListaOpciones();

class _SelectorState extends State<Selector> {
  late List<Opcion> lista;
  List<Opcion>? selectedOptionsList = [];

  @override
  void initState() {
    super.initState();
    lista = widget.opcion == "Dietas" ? listaAux._dietas : listaAux._alergias;  // Inicializamos coa lista correspondente
  }

  Future<void> _openFilterDialogOpciones() async {
    await FilterListDialog.display<Opcion>(
        context,
        resetButtonText: "Borrar",
        applyButtonText: "Guardar",
        hideSelectedTextCount: false,   //Poñer a false se queremos ver cantos levamos seleccionados
        hideSearchField: true,  // Así en horizontal non temos problema
        themeData: FilterListThemeData(context),
        headlineText: 'Selecciona  ${widget.opcion}', // Poñer o qeu buscamos
        height: 500,     // Esto creo que é o tamaño do Dialog asi que tocar se eso
        listData: lista,    // Lista para crear os iconos
        selectedListData: widget.opcion == "Dietas" ? context.read<OpcionesSeleccionadas>().opcionesDietas
            : context.read<OpcionesSeleccionadas>().opcionesAlergias,    // Modificamos en el provider la lista de opciones correspondiente
        choiceChipLabel: (item) => item!.opcion,
        validateSelectedItem: (list, val) => list!.contains(val),
        controlButtons: [ControlButtonType.Reset],  // Quitamos botón todos de opcions de lista
        onItemSearch: (opt, query) {
          return opt.opcion.toLowerCase().contains(query.toLowerCase());
        },

        onApplyButtonClick: (list) {
          setState(() {
            widget.opcion == "Dietas" ? context.read<OpcionesSeleccionadas>().set_opciones_dietas(List.from(list!))
                : context.read<OpcionesSeleccionadas>().set_opciones_alergias(List.from(list!));  // Actualizamos la lista de opciones correspondiente
          }
          );
          Navigator.pop(context);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return BotonDietaAlergia(title: widget.opcion, funcion: _openFilterDialogOpciones);
  }
}


class BotonDietaAlergia extends StatelessWidget{
  final String title;
  final Future<void> Function() funcion;

  const BotonDietaAlergia({super.key, required this.title, required this.funcion});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: funcion,
        icon: const Icon(Icons.arrow_forward_ios),
        label: Text(
            title,
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