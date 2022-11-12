import 'package:flutter/material.dart';
import 'edamam.dart';

void main() {
  runApp(const AppEdamam());
}

class AppEdamam extends StatelessWidget{

  const AppEdamam();  // Constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Say Hello',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LayoutMeu("App"),
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
                  child: ListView.builder(
                      itemCount: snapshot.data?.recipes?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: ImageBuilder(snapshot.data?.recipes?[index].image),
                            backgroundColor: Colors.white,
                          ),
                          title: Text(_parser(snapshot.data?.recipes?[index].label)),
                          subtitle: Text("Calorias: ${_parser(snapshot.data?.recipes?[index].calories?.toStringAsFixed(0))}          Ingredientes: ${_parser(snapshot.data?.recipes?[2].ingredients?.length.toString())}"),
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
                      }),
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