import 'dart:core';
import 'package:flutter/material.dart';
import 'edamam.dart';
import 'package:octo_image/octo_image.dart';
import 'package:flutter/services.dart';



class LayoutDetalle extends StatelessWidget{
  final Recipe info_receta;  // Información de la receta

  LayoutDetalle(this.info_receta, {super.key});

  Widget build(BuildContext context){
    return MediaQuery.of(context).orientation == Orientation.portrait ?  // Comprobamos que layout devolver (Vertical o horizontal)
    LayoutDetalleVertical(info_receta)
        :
    LayoutDetalleHorizontal(info_receta);
  }
}

class LayoutDetalleVertical extends StatelessWidget{
  final Recipe info_receta;

  LayoutDetalleVertical(this.info_receta, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
      body: Column(
        children: [
          const Spacer(flex: 2,),
          Expanded(  // Imagen con el logo de Edamam
            flex: 8,
            child: Center(
              child: Image.asset('assets/images/Edamam_logo_full_RGB.png',
                  scale: 6
              ),
            ),
          ),
          const Divider(thickness: 2,   // Separador
            color: Colors.green,),
          const Spacer(flex: 1,),
          Expanded(   // Título de la receta
            flex: 9,
            child: Text(info_receta.label!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 30
              ),),
          ),
          const Spacer(flex: 1,),
          Expanded(  // Imagen de la receta
            flex: 30,
            child: OctoImage(image: NetworkImage(info_receta.image!),  // Imagen
              progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),   // Circulo de progreso mientras se obtiene
              errorBuilder: OctoError.icon(color: Colors.green,),    // Icono si no se obtuvo la imagen
            ),
          ),
          const Spacer(flex: 2,),
          Expanded(  // Calorías de la receta
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                        child: Text("${info_receta.calories!.toStringAsFixed(0)} Kcal",
                            style: const TextStyle(
                                fontSize: 16
                            )),))
                ],
              )),
          const Spacer(flex: 2,),
          Expanded(  // Pestañas de ingredientes, dietas y alergias
              flex: 36,
              child: Row(
                children: [
                  const Spacer(flex: 2,),
                  Expanded(
                      flex: 45,
                      child: PestanaIngredientes(info_receta.ingredients!)),
                  const Spacer(flex: 6,),
                  Expanded(flex: 45,
                      child: PestanasDietasAlergias(info_receta.dietLabels!, info_receta.healthLabels!)),
                  const Spacer(flex: 2,)
                ],
              )),
          const Spacer(flex: 2,),
          const Divider(thickness: 2,   // Separador
            color: Colors.green,),
          Expanded(   // Botón para regresar a la pantalla anterior
              flex: 5,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),  // Volver a la pantalla anterior
                  child: const Text("Volver"),
                ),
              )),
          const Spacer(flex: 3,)
        ],
      ),
    );
  }
}

class PestanasDietasAlergias extends StatelessWidget{
  final List<String> dietas;  // Información sobre las dietas qeu cumple la receta
  final List<String> alergias;  // Información sobre alergias que no están presentes en la receta

  PestanasDietasAlergias(this.dietas, this.alergias, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(  // Widget principal
        length: 2, // Nº de pestañas
        child: Column(
          children: [
            Expanded(  // Espacio de la columna correspondiente al título de las pestañas
                flex: 20,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: Colors.green,
                          child: TabBar(
                            indicatorColor: Colors.green[900],
                            tabs: const [
                              Tab(text: "Dietas",),  // Título de la pestaña Dietas
                              Tab(text: "Alergias",),  // Título de la pestaña Alergias
                            ],
                          ),
                        ))
                  ],
                )),
            Expanded(  // Espacio de la columna para la información que se muestra en cada pestaña
                flex: 80,
                child: Container(
                  color: Colors.grey[200],
                  child: TabBarView(  // Widget que contiene la información de cada pestaña
                    children: [
                      dietas.isEmpty ?
                      const Center(child: Icon(Icons.browser_not_supported_sharp))  // Si no tenemos información sobre dietas mostramos un icono indicándolo
                          :
                      ListView.builder(   // Lista con la información de dietas
                          itemCount: dietas.length,  // Nº de elementos
                          itemBuilder: (context, index) {
                            return ListTile(  // Icono con texto para mostrar cada opción de dietas
                              leading: const Icon(Icons.no_food,),
                              title: Text(dietas[index]),
                            );
                          }
                      ),
                      alergias.isEmpty ?
                      const Center(child: Icon(Icons.browser_not_supported_sharp),)  // Si no tenemos información sobre alergias mostramos un icono indicándolo
                          :
                      ListView.builder(   // Lista con la información de alergias
                          itemCount: alergias.length,  // Nº de elementos
                          itemBuilder: (context, index) {
                            return ListTile(  // Icono con texto para mostrar cada opción de alergias
                              leading: const Icon(Icons.done,),
                              title: Text(alergias[index]),
                            );
                          }
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}

class PestanaIngredientes extends StatelessWidget{
  final List<String> ingredientes;  // Información sobre ingredientes de la receta

  PestanaIngredientes(this.ingredientes, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,  // Nº de pestañas
        child: Column(
          children: [
            Expanded(  // Espacio de la columna correspondiente al título de la pestaña
                flex: 20,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: Colors.green,
                          child: TabBar(
                            indicatorColor: Colors.green[900],
                            tabs: [
                              Tab(text: "Ingredientes: ${ingredientes.length}",),  // Título de la pestaña
                            ],
                          ),
                        ))
                  ],
                )),
            Expanded(
                flex: 80,  // Espacio de la columna para la información que se muestra en cada pestaña
                child: Container(
                  color: Colors.grey[200],
                  child: TabBarView(
                    children: [
                      ingredientes.isEmpty ?
                      const Center(child: Icon(Icons.browser_not_supported_sharp),)  // Si la información sobre ingredientes está vacía mostramos un icono indicándolo
                          :
                      ListView.builder(   // Lista con los ingredientes
                          itemCount: ingredientes.length,  // Nº de ingredientes
                          itemBuilder: (context, index) {
                            return ListTile(  // Icono con texto para mostrar cada ingrediente
                              leading: const Icon(Icons.kitchen),
                              title: Text(ingredientes[index]),
                            );
                          }
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}

class TodasPestanas extends StatelessWidget{
  final List<String> ingredientes;  // Info ingredientes
  final List<String> dietas;  // Info dietas
  final List<String> alergias;  // Info alergias

  TodasPestanas(this.ingredientes, this.dietas, this.alergias, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 84,  // Parte para pestañas
              child: Row(
                children: [
                  Expanded(  // Pestaña ingredientes
                      flex: 48,
                      child: Material(
                        child: PestanaIngredientes(ingredientes),
                      )
                  ),
                  const VerticalDivider(thickness: 2,
                    color: Colors.green,),
                  Expanded(  // Pestañas de Dietas y Alergias
                      flex: 48,
                      child: Material(
                        child: PestanasDietasAlergias(dietas, alergias),
                      )
                  ),
                ],
              )
          ),
          const Spacer(flex: 3,),
          Expanded(    // Parte para el botón de volver
              flex: 10,
              child: Column(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),  // Al pulsar se regresa a la pantalla anterior
                      child: const Text("Volver"),
                    ),),
                ],
              )),
          const Spacer(flex: 3,)  // Espacio inferior botón
        ],
      ),
    );
  }
}

class LayoutDetalleHorizontal extends StatelessWidget{
  final Recipe info_receta;

  LayoutDetalleHorizontal(this.info_receta, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(  // Parte principal de la pantalla, información a la izquierda y foto a la derecha
            flex: 87,
            child: Row(
              children: [
                Expanded(  // Mitad izquierda de la pantalla
                  flex: 50,
                  child: Column(
                    children: [
                      Expanded(   // Imagen Edamam
                        flex: 25,
                        child: Image.asset('assets/images/Edamam_logo_full_RGB.png',
                            scale: 6
                        ),),
                      Expanded(   // Nombre Receta
                        flex: 25,
                        child: Text(info_receta.label!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 27
                          ),),),
                      Expanded(
                          flex: 12,  // Ingredientes
                          child: Text("${info_receta.ingredients?.length} Ingredientes")),
                      Expanded(
                          flex: 12,  // Calorías
                          child: Text("${info_receta.calories!.toStringAsFixed(0)} Kcal")),
                      const Spacer(flex: 10,),
                      Expanded(    // Botón + info
                          flex: 12,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,      // Navegamos á próxima pantalla
                                MaterialPageRoute(
                                    builder: (context) => TodasPestanas(info_receta.ingredients!, info_receta.dietLabels!, info_receta.healthLabels!) // Pestaña ingredientes, dietas y alergias
                                )
                            ),
                            child: const Text("+ Info",),
                          )),
                      const Spacer(flex: 3,)
                    ],
                  ),
                ),
                const VerticalDivider(thickness: 2,  // Divisor entre información e imagen
                  color: Colors.green,
                  indent: 25,),
                Expanded(    // Mitad derecha de la pantalla
                  flex: 50,
                  child: Column(
                    children: [
                      const Spacer(flex: 10,),
                      Expanded(
                        flex: 87,
                        child: OctoImage(image: NetworkImage(info_receta.image!),  // Imagen
                          progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),   // Circulo de progreso mientras carga
                          errorBuilder: OctoError.icon(color: Colors.green,),    // Icono si no se obtuvo la imagen
                        ),),
                      const Spacer(flex: 3,)    // Espacio inferior imagen
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(   // Parte inferior de la pantalla para el botón de volver
              flex: 10,
              child: Row(
                children: [
                  const Spacer(flex: 75,),
                  Expanded(
                      flex: 15,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context), // Al pulsar el botón se regresa a la página anterior
                        child: const Text("Volver"),
                      )
                  ),
                  const Spacer(flex: 10,),
                ],
              )
          ),
          const Spacer(flex: 3,)
        ],
      ),
    );
  }
}