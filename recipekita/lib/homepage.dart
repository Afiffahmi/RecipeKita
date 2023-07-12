import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:recipekita/viewrecipePage.dart';

import 'main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  final CollectionReference _recipe = FirebaseFirestore.instance.collection('recipe');

  HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(padding:const EdgeInsets.only(left: 10.0), child: Text('RecipeKita')),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black,fontSize: 20),
          leading :  Icon(Icons.local_restaurant,color: Colors.amber,)
        ),
        body: StreamBuilder(
          stream: _recipe.snapshots(),
          builder: (context, AsyncSnapshot <QuerySnapshot> streamSnapshot)  {
            if(streamSnapshot.hasData){
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,

                      itemBuilder: (context, index){
                        final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                        return Container (
                        child:  ListTile(
                          title : Text(documentSnapshot['title']),
                          subtitle: Text(documentSnapshot['publisher']),
                          trailing: Icon(documentSnapshot['type']=='Food' ?  Icons.fastfood : Icons.local_drink),
                          onTap: () {
                            Recipe recipe = Recipe(documentSnapshot['title'], documentSnapshot['publisher'], documentSnapshot['type'],documentSnapshot['Ingredients'],documentSnapshot['cookingtime']) ;


                            Navigator.push(context,MaterialPageRoute(builder: (context) => ViewRecipe(recipe: recipe)));
                          },
                        ),
                            margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                        BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(
                        0.0,
                        10.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: -6.0,
                        ),
                        ],
                        ));
                      },
                    ),
                  ),
                ],
              );
            } return const Center(
              child: CircularProgressIndicator(),
            ) ;
          } ,
        )
    );


  }

}