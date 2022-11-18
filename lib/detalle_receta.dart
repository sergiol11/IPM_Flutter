import 'dart:core';
import 'package:flutter/material.dart';
import 'edamam.dart';
import 'package:octo_image/octo_image.dart';



class LayoutDetalle extends StatelessWidget{
  final String orientacion;
  final Recipe info_receta;

  LayoutDetalle(this.orientacion, this.info_receta);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // Evitamos que teclado redimensione pantalla
      body: orientacion == "Vertical" ? LayoutDetalleVertical(info_receta) : LayoutDetalleHorizontal()
    );
  }
}

class LayoutDetalleVertical extends StatelessWidget{
  final Recipe info_receta;

  LayoutDetalleVertical(this.info_receta);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2,),
        Expanded(
          flex: 8,
          child: Center(
            child: Image.asset('assets/images/Edamam_logo_full_RGB.png',
                scale: 6
            ),
          ),
        ),
        const Divider(thickness: 2,
        color: Colors.green,),
        const Spacer(flex: 1,),
        Expanded(
          flex: 9,
          child: Text(info_receta.label!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30
          ),),
        ),
        const Spacer(flex: 1,),
        Expanded(
          flex: 30,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 110,  // Tamaño imagen
            child: OctoImage(image: NetworkImage(info_receta.image!),  // Imagen
              progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),   // Circulo de progreso
              errorBuilder: OctoError.icon(color: Colors.green,),    // Icono si no se obtuvo la imagen
            ),
          ),
        ),
        const Spacer(flex: 2,),
        Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                    child: Center(
                      child: Text("Calorías: ${info_receta.calories!.toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontSize: 16
                          )),))
              ],
            )),
        const Spacer(flex: 2,),
        Expanded(
            flex: 36,
            child: Row(  // Fila info en detalle
              children: [
                const Spacer(flex: 2,),
                Expanded(
                    flex: 45,
                    child: PestanaIngredientes(info_receta.ingredients!)),
                const Spacer(flex: 6,),   // ESPACIO NO MEDIO
                Expanded(flex: 45,
                child: PestanasDietasAlergias(info_receta.dietLabels!, info_receta.healthLabels!)),
                const Spacer(flex: 2,)
              ],
            )),
        const Spacer(flex: 2,),
        const Divider(thickness: 2,
          color: Colors.green,),
        Expanded(
            flex: 5,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Volver"),
              ),
            )),
        const Spacer(flex: 3,)
      ],
    );
  }
}

class PestanasDietasAlergias extends StatelessWidget{
  final List<String> dietas;
  final List<String> alergias;

  PestanasDietasAlergias(this.dietas, this.alergias);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Expanded(
                flex: 20,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: Colors.green,   // Cambiar color!!!!!!!!!
                          child: TabBar(
                            indicatorColor: Colors.green[900],
                            tabs: const [
                              Tab(text: "Dietas",),
                              Tab(text: "Alergias",),
                            ],
                          ),
                        ))
                  ],
                )),
            Expanded(
                flex: 80,
                child: Container(
                  color: Colors.grey[200],
                  child: TabBarView(
                    children: [
                      dietas.isEmpty ?
                          const Center(child: Icon(Icons.browser_not_supported_sharp))
                      :
                      ListView.builder(   // Lista dietas
                          itemCount: dietas.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.no_food,),
                              title: Text(dietas[index]),
                            );
                          }
                      ),
                      alergias.isEmpty ?
                          const Center(child: Icon(Icons.browser_not_supported_sharp),)
                          :
                      ListView.builder(   // Lista dietas
                          itemCount: alergias.length,
                          itemBuilder: (context, index) {
                            return ListTile(
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
  final List<String> ingredientes;

  PestanaIngredientes(this.ingredientes);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Column(
          children: [
            Expanded(
                flex: 20,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: Colors.green,   // Cambiar color!!!!!!!!!
                          child: TabBar(
                            indicatorColor: Colors.green[900],
                            tabs: [
                              Tab(text: "Ingredientes: ${ingredientes.length}",),
                            ],
                          ),
                        ))
                  ],
                )),
            Expanded(
                flex: 80,
                child: Container(
                  color: Colors.grey[200],
                  child: TabBarView(
                    children: [
                      ingredientes.isEmpty ?
                          const Center(child: Icon(Icons.browser_not_supported_sharp),)
                          :
                      ListView.builder(   // Lista dietas   AQUI NN VEMOS CASO VACIO PORQUE NUNCA VAI PODER
                          itemCount: ingredientes.length,
                          itemBuilder: (context, index) {
                            return ListTile(
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

class LayoutDetalleHorizontal extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}