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
    recetas = search_recipes("Banana");
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
          return Center(
              child: Text("$snapshot.data.count"),
          );
        }
      },
    );
  }

}