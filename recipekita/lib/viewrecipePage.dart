import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:recipekita/core/constant/color/color.dart';
import 'package:recipekita/core/constant/style/style.dart';

class ViewRecipe extends StatelessWidget {
  ViewRecipe({super.key, required this.recipe});



  final Recipe recipe;


  //Text("posted by ${recipe.publisher}"),
  //Text("Ingredients \n ${recipe.ingredients}"),

  @override

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("View Recipe",style: TextStyle(color: Colors.black),),backgroundColor: Colors.amber,
      ),
      body:ListView(
        children: [
            Container(
            height: MediaQuery.of(context).size.height * .15,
            padding: const EdgeInsets.only(bottom: 5),
            width: double.infinity,
            child: Icon(Icons.restaurant, size: 50,),
            ),
            Positioned(
            bottom: 0,
            child: Container(
            height: size.height / 0.2,
            width: size.width,
            decoration: BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(34),
            ),
            child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
            child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 5,
            width: 32 * 1.5,
            decoration: BoxDecoration(
            gradient: AppColor.gradient,
            borderRadius: BorderRadius.circular(3),
            ),
            ),
            ),
            const SizedBox(
            height: 16,
            ),
            Text('${recipe.title}',
            style: AppStyle.h1Light),
              Text(recipe.publisher, style: AppStyle.text
                  .copyWith(color: Colors.white.withOpacity(.5))),
              SizedBox(height: 20,),
              Text("Type : " + recipe.type , style: AppStyle.text.copyWith(color : Colors.white.withOpacity(1))),
              Text("Time Taking : " + recipe.cookingtime , style: AppStyle.text.copyWith(color : Colors.white.withOpacity(1))),

              SizedBox(height: 20,),
              Text("Ingredients", style: AppStyle.h2.copyWith(color : Colors.white.withOpacity(1))),

              Text(recipe.ingredients,style: AppStyle.text.copyWith(color : Colors.white.withOpacity(1)),),







    ],
      ),

    )))]));
  }
}

class Recipe {
  final String title;
  final String publisher;
  final String type;
  final String ingredients;
  final String cookingtime;

  const Recipe(this.title,this.publisher,this.type,this.ingredients,this.cookingtime);
}