import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRecpiePage extends StatefulWidget {
  const AddRecpiePage({super.key});

  @override
  State<AddRecpiePage> createState() => _AddRecpiePage();
}

class _AddRecpiePage extends State<AddRecpiePage> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _cookingtimeController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;



    // here you write the codes to input the data into firestore



  handleSubmitRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleController.value.text;
    final ingredient = _ingredientsController.value.text;
    final type = _typeController.value.text;
    final cookingtime = _cookingtimeController.value.text;

    final User? user = auth.currentUser;
    final uid = user?.uid;
    final useremail = user?.email;


    setState(() => _loading = true);

    addRecipe(title,ingredient,type,cookingtime,useremail!);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Success"),
    ));

    setState(() => _loading = false);


  }

  Future addRecipe(String title, String ingredients, String type, String cookingtime, String useremail) async{
    await FirebaseFirestore.instance.collection('recipe').add({
      'title' : title,
      'Ingredients' : ingredients,
      'type' : type,
      'cokingtime' : cookingtime,
      'publisher' : useremail
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            //Add form to key to the Form Widget
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Add Recipe",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //Assign controller
                  controller: _titleController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your recipe title!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //Assign controller
                  controller: _ingredientsController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your recipe ingredients';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Ingredients',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //Assign controller
                  controller: _typeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your recipe type';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'type',
                    focusColor: Colors.black,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //Assign controller
                  controller: _cookingtimeController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your cooking time';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Cooking time',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => handleSubmitRegister(),
                  child: _loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text('Add'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
