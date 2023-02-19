import 'package:flutter/material.dart';

void navigateAndFinish(context, widget) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context)=>
            widget),
            (router)
        {
          return false;
        }
    );


void navigateTo(context, widget) => Navigator.push(context, MaterialPageRoute(builder: (context)=> widget));

