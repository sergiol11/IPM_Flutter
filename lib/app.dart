import 'dart:core';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:practica/providers.dart';
import 'edamam.dart';
import 'layout_horizontal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const int breakPoint = 600;


// PAGINA ayusch.com/flutter-provider-pattern-explained/


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Contador()),
        ChangeNotifierProvider(create: (_) => NombreReceta()),
        ChangeNotifierProvider(create: (_) => MinMaxCalorias()),
        ChangeNotifierProvider(create: (_) => OpcionesSeleccionadas()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: MasterDetail(title: 'Edamam',)
      ),);
  }
}


class MasterDetail extends StatelessWidget {
  final String title;

  MasterDetail({required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool chooseMasterAndDetail = (
              constraints.smallest.longestSide > breakPoint &&
                  MediaQuery.of(context).orientation == Orientation.landscape
          );
          return chooseMasterAndDetail ? LayoutHorizontal() : LayoutEu();  // Diseño horizontal o vertical
        }
    );
  }
}


class LayoutEu extends StatelessWidget {
  final String texto = "buscar";
  //final FocusNode focusNode;


  @override
  Widget build(BuildContext context) {
    return Botones("Vertical");
  }
}


class Botones extends StatelessWidget{
  static const double tamano_letra = 23;
  final String orientacion;

  Botones(this.orientacion);

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
              child: Row(   // Buscador
                children: const [
                  Spacer(flex: 15),
                  Expanded(
                      flex: 70,      // %
                      child: Buscador()
                  ),
                  Spacer(flex: 15),
                ],
              ),
            ),
            orientacion == "Vertical" ?    // 2 botones para Dietas y Alergias en vertical
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
                      child: Calorias(limite: "Min",)
                  ),
                  Spacer(flex: 3),
                  Expanded(
                      flex: 31,
                      child: Calorias(limite: "Max",)
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
                  const Expanded(
                      flex: 30,
                      child: Text("Ingredientes:",
                        style: TextStyle(
                            fontSize: 22
                        ),
                      )
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                      flex: 9,
                      child: BotonContador("Remove")
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                      flex: 6,     // Mínimo 6 ou 7 %!!
                      child: Center(
                          child: ContadorListener()
                      )
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                      flex: 9,
                      child: BotonContador("Add")
                  ),
                  const Spacer(flex: 30),
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
            //Spacer(flex: orientacion == "Vertical" ? 50 : 1)
            orientacion == "Vertical" ?
            const Expanded(
                flex: 50,
                child: ModalBottomSheetDemo("Vertical",)
            )
                : const Spacer(flex: 1,)
          ],
        )
    );
  }
}

////////////////////////// LIST VIEW  ///////////////////////////////////////////

class ModalBottomSheetDemo extends StatelessWidget {
  final String orientacion;

  const ModalBottomSheetDemo(this.orientacion);


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,  // Para que se mostre inicialmente coa altura de todo o fillo,
      minChildSize: 1.0,  // Mínima altura poñemos a de todito o fillo así forzamos que non se faga drag para abaixo!
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          // Padding para que non se vaia a curva!
          padding: orientacion == "Vertical" ? EdgeInsets.only(top: 10) : EdgeInsets.only(left: 10,),
          child: LayoutMeu("Hola"),   // AQUI E ONDE POÑERMOS INFO DE COUSA DE ABAIXO!!!
          decoration: orientacion == "Vertical" ? const BoxDecoration(  // Borde curvo + color de borde negro
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
          )
        );
      },
    );
  }
}


class LayoutMeu extends StatefulWidget{
  final String title;

  LayoutMeu(this.title);

  @override
  _LayoutMeuState createState() => _LayoutMeuState();
}


class _LayoutMeuState extends State<LayoutMeu>{
  late Future<RecipeBlock?>? recetas;

  @override
  void initState() {
    super.initState();
    recetas = search_recipes("Salad");
  }

  String _parser(String? palabra){
    return palabra != null ? palabra : "Error";
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
                  Text('There was a network error'),
                  ElevatedButton(
                    child: Text('Try again'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        }
        else if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemCount: snapshot.data?.recipes?.length.toInt() ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: ImageBuilder(snapshot.data?.recipes?[index].image),
                            ),
                            title: Text(_parser(snapshot.data?.recipes?[index].label)),
                            subtitle: Text("Calorias: ${_parser(snapshot.data?.recipes?[index].calories?.toStringAsFixed(0))}     "
                                "     Ingredientes: ${_parser(snapshot.data?.recipes?[2].ingredients?.length.toString())}"),
                            trailing: SizedBox(
                              height: 35,
                              width: 35,
                              child: FloatingActionButton(
                                onPressed: () {},
                                backgroundColor: Colors.white,
                                child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.green,),
                              ),
                            )
                        );
                      }, separatorBuilder: (BuildContext context, int index) {  // Separador de elementos
                    return const Divider(
                      color: Colors.green,
                      thickness: 2,
                      indent: 16,  // Espacio inicial
                      endIndent: 20,   // Espacio final
                    );
                  },),
                )
              ],
            ),
          );
        }
      },
    );
  }
}




class ImageBuilder extends StatefulWidget{
  final String? url_imagen;

  ImageBuilder(this.url_imagen);

  @override
  _ImageBuilderState createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder>{

  @override
  void initState() {
    super.initState();// Cast
  }

  Future<Image> get_imagen(String? url) async {
    return widget.url_imagen != null
        ?
    Image.network(
      url!,
      frameBuilder: (_, image, loadingBuilder, __) {
        if (loadingBuilder == null) {
          return Expanded(
            child: Container(
              //color: Colors.redAccent,
              child:  Center(child: CircularProgressIndicator()),
            ),
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image> (
      future: get_imagen(widget.url_imagen),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        return InkWell(
          child: Center(
            child: snapshot.data,
          ),
        );
      },
    );
  }

}



//////////////////////// LIST VIEW /////////////////////////////////////////////



class BotonBuscar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: 'Buscar',
      onPress: () {},    // OJO CAMBIAR ESTO DESPOIS MÁIS ADIANTE!!!!!!! PARA QUE CAMBIE O RECIPE BLOCK QUE TEMOS!!!!
      isReverse: true,
      selectedTextColor: Colors.black,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      //textStyle: submitTextStyle,
      backgroundColor: Colors.grey,
      borderColor: Colors.green,
      borderRadius: 50,
      borderWidth: 2,
    );
  }
}

class BotonContador extends StatefulWidget{
  final String accion;

  BotonContador(this.accion);

  @override
  _BotonContadorState createState() => _BotonContadorState();

}


class _BotonContadorState extends State<BotonContador>{

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // Incrementamos o decrementamos el contador según el botón y escogemos el icono
        onPressed: () => widget.accion == "Add" ? context.read<Contador>().increment() : context.read<Contador>().decrement(),
        child: Icon(widget.accion == "Add" ? Icons.add : Icons.remove));
  }
}

class ContadorListener extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text('${context.watch<Contador>().count}',   // Leemos en todo momento el valor del contador
      style: const TextStyle(
          fontSize: 20
      ),);
  }

}



class Calorias extends StatefulWidget {
  final String limite;

  const Calorias({required this.limite, key}) : super(key: key);

  @override
  _CaloriasState createState() => _CaloriasState();
}


class _CaloriasState extends State<Calorias> {     // É sin estdo???
// Crea un controlador de texto. Lo usaremos para recuperar el valor actual
  // del TextField!
  //final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  TextField(   // NON POÑAS AQUÍ CONST QUE JODES TODO COÑO
      //controller: myController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),  // Tamaño do Widget
        filled: true,
        labelText: widget.limite,
      ),
      // Gardamos cada cambio que ocurra por se usuario non lle da a OK no teclado cando escriba!
      onChanged: (text) => widget.limite == "Min" ? () => context.read<MinMaxCalorias>().set_min(text)
          : context.read<MinMaxCalorias>().set_max(text),   // Modificamos el valor máximo o mínimo de las calorías
    );
  }
}


class Buscador extends StatefulWidget {    // É sin estado?
//final String receta;

  const Buscador();

  @override
  State<Buscador> createState() => _BuscadorState();  // Esto non sei se poñer como cabrero ou como prueba
}


class _BuscadorState extends State<Buscador> {    // ESTARÍA GUAI QUE ESTO SUGIERA MENTRES ESTÁ BUSCANDO NOMES DE RECETAS!!!!!!!!!!!!!
  late FocusNode myFocusNode;
  // Crea un controlador de texto. Lo usaremos para recuperar el valor actual
  // del TextField!
  //final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    //myController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      //controller: myController,
        focusNode: myFocusNode,
        restorationId: 'name_field',
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          filled: true,
          icon: Icon(Icons.search),
          labelText: "Receta",
          hintText: "Buscar",
          //helperText: "Obligatorio *"
        ),
        onTap: () => myFocusNode.requestFocus(), // Para doble clic hai que usar Gesture!

        // Gardamos o nome da receta introducido cada vez que hai un cambio por se usuario non lle dá a OK no teclado
        onChanged: (text) => context.read<NombreReceta>().set_nombre_receta(text)
      //myFocusNode.unfocus(),  //Esta parte é cando se lle da ao enter de deixar de escribir para gardar o valor este aquí
      //person.name = value;
      //_phoneNumber.requestFocus();
      //validator: _validateName,*/// Aquí é cando se pon error se está vacío! Con esto do validator
    );
  }
}



class Selector extends StatefulWidget {
  final String opcion;

  const Selector({super.key, required this.opcion});


  @override
  State<Selector> createState() => _SelectorState();  // Esto non sei se poñer como cabrero ou como prueba
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
      allButtonText: "Todos",
      resetButtonText: "Borrar",
      applyButtonText: "Guardar",
      hideSelectedTextCount: false,   //Poñer a false se queremos ver cantos levamos seleccionados
      themeData: FilterListThemeData(context),
      headlineText: 'Selecciona  ' + widget.opcion, // Poñer o qeu buscamos
      height: 500,     // Esto creo que é o tamaño do Dialog asi que tocar se eso
      listData: lista,    // Lista para crear os iconos
      selectedListData: widget.opcion == "Dietas" ? context.read<OpcionesSeleccionadas>().opcionesDietas
          : context.read<OpcionesSeleccionadas>().opcionesAlergias,    // Modificamos en el provider la lista de opciones correspondiente
      choiceChipLabel: (item) => item!.opcion,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (opt, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return opt.opcion!.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          widget.opcion == "Dietas" ? context.read<OpcionesSeleccionadas>().set_opciones_dietas(List.from(list!))
              : context.read<OpcionesSeleccionadas>().set_opciones_alergias(List.from(list!));  // Actualizamos la lista de opciones correspondiente
        });
        Navigator.pop(context);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BotonDietaAlergia(title: widget.opcion, funcion: _openFilterDialogOpciones);
  }
}


class BotonDietaAlergia extends StatelessWidget{
  final String title;
  final Future<void> Function() funcion;  // Función a executar!!!


  BotonDietaAlergia({required this.title, required this.funcion});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: funcion,
        icon: const Icon(Icons.arrow_forward_ios),
        label: Text(title,
          style: const TextStyle(
              fontSize: 16
          ),));
  }
}




class Opcion {
  final String _opcion;

  Opcion(this._opcion);

  // Getters

  String get opcion => _opcion;


}

class ListaOpciones {
  List<Opcion> _dietas = [
    Opcion("Alcohol-free"),
    Opcion("Balanced"),
    Opcion("High-Fiber"),
    Opcion("High-Protein"),
    Opcion("Keto"),
    Opcion("Kidney friendly"),
    Opcion("Kosher"),
    Opcion("Low-Carb"),
    Opcion("Low-Fat"),
    Opcion("Low potassium"),
    Opcion("Low-Sodium"),
    Opcion("No oil added"),
    Opcion("No-sugar"),
    Opcion("Paleo"),
    Opcion("Pescatarian"),
    Opcion("Pork-free"),
    Opcion("Red meat-free"),
    Opcion("Sugar-conscious"),
    Opcion("Vegan"),
    Opcion("Vegetarian"),
  ];

  List<Opcion> _alergias = [
    Opcion("Celery-free"),
    Opcion("Crustacean-free"),
    Opcion("Dairy-free"),
    Opcion("Egg-free"),
    Opcion("Fish-free"),
    Opcion("Gluten-free"),
    Opcion("Lupine-free"),
    Opcion("Mustard-free"),
    Opcion("Peanut-free"),
    Opcion("Sesame-free"),
    Opcion("Shellfish-free"),
    Opcion("Soy-free"),
    Opcion("Tree-Nut-free"),
    Opcion("Wheat-free"),
  ];

  ListaOpciones();  // Constructor

  List<Opcion> get dietas => _dietas;

  List<Opcion> get alergias => _alergias;
}