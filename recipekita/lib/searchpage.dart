import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipekita/viewrecipePage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController seachtf = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('recipe')
        .where(
      'title',
      isGreaterThanOrEqualTo: seachtf.text
    ).where('title', isLessThan:  seachtf.text + 'z' )
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 10,
          ),
          child: TextField(

            controller: seachtf,
            decoration: InputDecoration(
              hintText: 'Search',
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      snapshot.data!.docChanges[index].doc['title'],

                    ),
                    subtitle: Text(snapshot.data!.docChanges[index].doc['publisher']),
                    trailing: Icon(snapshot.data!.docChanges[index].doc['type']=='Food' ?  Icons.fastfood : Icons.local_drink),
                    onTap: () {
                      Recipe recipe = Recipe(snapshot.data!.docChanges[index].doc['title'], snapshot.data!.docChanges[index].doc['publisher'], snapshot.data!.docChanges[index].doc['type'],snapshot.data!.docChanges[index].doc['Ingredients'],snapshot.data!.docChanges[index].doc['cookingtime']) ;


                      Navigator.push(context,MaterialPageRoute(builder: (context) => ViewRecipe(recipe: recipe)));
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }}
