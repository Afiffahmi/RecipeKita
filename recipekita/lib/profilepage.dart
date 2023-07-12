
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:recipekita/myrecipepage.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _user = FirebaseFirestore.instance.collection(
      'users');

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final userRef = FirebaseFirestore.instance.collection('users');
    final query = userRef.where('email', isEqualTo: useremail);

    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        _firstnameController.text = documentSnapshot['first name'];
        _lastnameController.text = documentSnapshot['last name'];
      }

      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context)
        {
          return Padding(padding: EdgeInsets.only(
              top: 20, left: 20, right: 20, bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(onPressed: () async {
                    final String firstname = _firstnameController.text;
                    final String lastname = _lastnameController.text;
                    if (lastname != null) {
                      await _user.doc(documentSnapshot!.id).update(
                          {"first name": firstname, "last name": lastname});
                      _firstnameController.text = '';
                      _lastnameController.text = '';
                    }
                  }, child: const Text('Update'))
                ],

              ));
        },);}


    return Scaffold(
        appBar: AppBar(
          title: Padding(padding: const EdgeInsets.only(left: 10.0),
              child: Text('My Profile')),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          actions: <Widget>[
            IconButton(onPressed: () {
              FirebaseAuth.instance.signOut();
            }, icon: Icon(Icons.logout), color: Colors.black,)
          ],),
        body: StreamBuilder(
          stream: query.snapshots(),
          builder: (context, AsyncSnapshot <QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];

                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Stack(children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100), child: const Icon(Icons.person,size: 100)),
                          ),



                        ],

                        ),
                        SizedBox(height: 10,),
                        Text(documentSnapshot['first name'] +" " +  documentSnapshot['last name'], style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(documentSnapshot['email'], style: TextStyle(fontSize: 10),),
                        ElevatedButton(
                          onPressed: () => _update(documentSnapshot),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber, side: BorderSide.none, shape: const StadiumBorder()),
                          child: const Text('Update', style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return MyRecipe();}));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber, side: BorderSide.none, shape: const StadiumBorder()),
                          child: const Text('My Recipe', style: TextStyle(color: Colors.black),),

                        ),
                      ],

                    ),

                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
}