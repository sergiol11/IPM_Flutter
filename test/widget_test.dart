import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica/main.dart' as app;


void main() {

  testWidgets('FloatingActionButton Ingredientes', (WidgetTester tester) async {
    // Arrancamos la app.
    app.main();
    // Esperamos a que se rendericen los widgets.
    await tester.pumpAndSettle();

    // Buscamos el FloatingActionButton que permite aumentar el límite máximo de ingredientes.
    final Finder botonAdd = find.byKey(const Key('Add'));
    // Buscamos el FloatingActionButton que permite disminuir el límite máximo de ingredientes.
    final Finder botonRemove = find.byKey(const Key('Remove'));
    // Aumentamos el límite 2 veces.
    await tester.tap(botonAdd);
    await tester.tap(botonAdd);
    // Disminuímos el límite 1 vez.
    await tester.tap(botonRemove);
    await tester.pumpAndSettle();
    // Comprobamos que existe el widget con el valor de límite de ingredientes correcto.
    expect(find.text('3'), findsOneWidget);

    // Buscamos el AlertDialog que salta cuando ocurre un error.
    final Finder error = find.byKey(const Key("Error"));
    // Comprobamos que el AlertDialog no se lanzó.
    expect(error, findsNothing);

    // Disminuímos el límite 2 veces para que surja un error (al bajar de 2 ingredientes).
    await tester.tap(botonRemove);
    await tester.tap(botonRemove);
    await tester.pumpAndSettle();

    // Comprobamos que el AlertDialog sí se lanzó.
    expect(error, findsOneWidget);
    // Buscamos el botón del AlertDialog que lo permite cerrar.
    final Finder botonOK = find.byKey(const Key("Boton OK"));
    // Pulsamos en el botón para cerrarlo.
    await tester.tap(botonOK);
    await tester.pumpAndSettle();
    // Comprobamos que se cerró correctamente.
    expect(error, findsNothing);
  });

  testWidgets('TextFormField nombre de recetas', (WidgetTester tester) async {
    // Arrancamos la app.
    app.main();
    // Esperamos a que se rendericen los widgets.
    await tester.pumpAndSettle();

    // Buscamos el TextFormField que permite buscar una receta por su nombre.
    final Finder txtReceta = find.byKey(const Key('Nombre receta'));
    // Escribimos algo en él.
    await tester.enterText(txtReceta, 'Pasta');
    await tester.pumpAndSettle();

    // Buscamos el AlertDialog que salta cuando ocurre un error.
    final Finder error = find.byKey(const Key("Error"));
    // Comprobamos que el AlertDialog no se lanzó.
    expect(error, findsNothing);

    //Escribimos un número como nombre de receta.
    await tester.enterText(txtReceta, '2');
    await tester.pumpAndSettle();
    // Comprobamos que el AlertDialog sí se lanzó.
    expect(error, findsOneWidget);

    // Buscamos el botón del AlertDialog que lo permite cerrar.
    final Finder botonOK = find.byKey(const Key("Boton OK"));
    // Pulsamos en el botón para cerrarlo.
    await tester.tap(botonOK);
    await tester.pumpAndSettle();
    // Comprobamos que se cerró correctamente.
    expect(error, findsNothing);
  });

  testWidgets('TextFormField calorías mínimas', (WidgetTester tester) async {
    // Arrancamos la app.
    app.main();
    // Esperamos a que se rendericen los widgets.
    await tester.pumpAndSettle();

    // Buscamos el TextFormField que permite establecer un mínimo de calorías.
    final Finder txtMinCal = find.byKey(const Key('Min'));
    // Escribimos algo en él.
    await tester.enterText(txtMinCal, '2000');
    await tester.pumpAndSettle();

    // Buscamos el AlertDialog que salta cuando ocurre un error.
    final Finder error = find.byKey(const Key("Error"));
    // Comprobamos que el AlertDialog no se lanzó.
    expect(error, findsNothing);

    //Escribimos una letra en el TextFormField.
    await tester.enterText(txtMinCal, 'a');
    await tester.pumpAndSettle();
    // Comprobamos que el AlertDialog sí se lanzó.
    expect(error, findsOneWidget);

    // Buscamos el botón del AlertDialog que lo permite cerrar.
    final Finder botonOK = find.byKey(const Key("Boton OK"));
    // Pulsamos en el botón para cerrarlo.
    await tester.tap(botonOK);
    await tester.pumpAndSettle();
    // Comprobamos que se cerró correctamente.
    expect(error, findsNothing);
  });

  testWidgets('TextFormField calorías máximas', (WidgetTester tester) async {
    // Arrancamos la app.
    app.main();
    // Esperamos a que se rendericen los widgets.
    await tester.pumpAndSettle();

    // Buscamos el TextFormField que permite establecer un mínimo de calorías.
    final Finder txtMaxCal = find.byKey(const Key('Max'));
    // Escribimos algo en él.
    await tester.enterText(txtMaxCal, '2000');
    await tester.pumpAndSettle();

    // Buscamos el AlertDialog que salta cuando ocurre un error.
    final Finder error = find.byKey(const Key("Error"));
    // Comprobamos que el AlertDialog no se lanzó.
    expect(error, findsNothing);

    //Escribimos una letra en el TextFormField.
    await tester.enterText(txtMaxCal, 'a');
    await tester.pumpAndSettle();
    // Comprobamos que el AlertDialog sí se lanzó.
    expect(error, findsOneWidget);

    // Buscamos el botón del AlertDialog que lo permite cerrar.
    final Finder botonOK = find.byKey(const Key("Boton OK"));
    // Pulsamos en el botón para cerrarlo.
    await tester.tap(botonOK);
    await tester.pumpAndSettle();
    // Comprobamos que se cerró correctamente.
    expect(error, findsNothing);
  });

  testWidgets('Búsqueda vacía', (WidgetTester tester) async {
    // Arrancamos la app.
    app.main();
    // Esperamos a que se rendericen los widgets.
    await tester.pumpAndSettle();

    // Buscamos el TextFormField que permite buscar una receta por su nombre.
    final Finder txtReceta = find.byKey(const Key('Nombre receta'));
    // Lo vaciamos.
    await tester.enterText(txtReceta, '');
    await tester.pumpAndSettle();

    // Buscamos el SwitchListTile que permite no limitar los ingredientes.
    final Finder _switch = find.byKey(const Key('Switch'));
    // Lo desactivamos.
    await tester.tap(_switch);
    await tester.pumpAndSettle();

    // Buscamos el AnimatedButton que permite realizar una búsqueda de recetas.
    final Finder botonBuscar = find.byKey(const Key("Buscar"));
    // Realizamos la búsqueda vacía para ver que salta un error.
    await tester.tap(botonBuscar);
    await tester.pumpAndSettle();

    // Buscamos el AlertDialog que salta cuando ocurre un error.
    final Finder error = find.byKey(const Key("Error"));
    // Comprobamos que el AlertDialog sí se lanzó.
    expect(error, findsOneWidget);

    // Buscamos el botón del AlertDialog que lo permite cerrar.
    final Finder botonOK = find.byKey(const Key("Boton OK"));
    // Pulsamos en el botón para cerrarlo.
    await tester.tap(botonOK);
    await tester.pumpAndSettle();
    // Comprobamos que se cerró correctamente.
    expect(error, findsNothing);
  });

}

