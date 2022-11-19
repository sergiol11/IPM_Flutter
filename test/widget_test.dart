import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica/main.dart' as app;


void main() {
  testWidgets('Error en el TextFormField del nombre de recetas.', (WidgetTester tester) async {
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

  testWidgets('Error en el TextFormField del nombre de recetas.', (WidgetTester tester) async {
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
}

