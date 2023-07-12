import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipekita/viewrecipePage.dart';
import 'auth.dart';

class MyRecipe extends StatelessWidget {
  MyRecipe({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _recipe = FirebaseFirestore.instance.collection('recipe');



  @override
  Widget build(BuildContext context) {
    Future<void> _delete(String recipeId) async {
      await _recipe.doc(recipeId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have successfully deleted a recipe')));
    }
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final myRecipe = FirebaseFirestore.instance.collection('recipe');
    final query = myRecipe.where('publisher', isEqualTo: useremail);
    return Scaffold(
        appBar: AppBar(
          title: Padding(padding:const EdgeInsets.only(left: 10.0), child: Text('RecipeKita')),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black,fontSize: 20),
        ),
        body: StreamBuilder(
          stream: query.snapshots(),
          builder: (context, AsyncSnapshot <QuerySnapshot> streamSnapshot)  {
            if(streamSnapshot.hasData){
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index){
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];

                  return Card (
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title : Text(documentSnapshot['title']),
                      subtitle: Text(documentSnapshot['publisher']),
                      trailing: SizedBox(
                        width:  50,
                        child: Row(
                          children: [
                            IconButton(icon: const Icon(Icons.cancel,color: Colors.red,), onPressed: () {
                              _delete(documentSnapshot.id);
                            },)
                          ],
                        ),
                      ),
                      onTap: () {
                        Recipe recipe = Recipe(documentSnapshot['title'], documentSnapshot['publisher'], documentSnapshot['type'],documentSnapshot['Ingredients'],documentSnapshot['cookingtime']) ;


                        Navigator.push(context,MaterialPageRoute(builder: (context) => ViewRecipe(recipe: recipe)));
                      },
                    ),
                  );
                },
              );
            } return const Center(
              child: CircularProgressIndicator(),
            ) ;
          } ,
        )
    );
  }
}
