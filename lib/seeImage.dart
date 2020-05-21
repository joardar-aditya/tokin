import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:path/path.dart';
import 'package:tokin/showImage.dart';


class seeImage extends StatelessWidget{
  File image_filtered;
  seeImage(this.image_filtered);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: Image.file(image_filtered,),
        ),
        Positioned(top:MediaQuery.of(context).size.height - 90, left:20,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Colors.deepOrange,
          child: Text("Apply filters", style: TextStyle(color:Colors.white, fontSize: 15),),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => showImage(image_filtered)));
          },
        ),
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Colors.purpleAccent,
            child: Text("SShaaaarrreee", style: TextStyle(color:Colors.white, fontSize: 25),),
            onPressed: () {
              //tobeimplemented
              FlutterShareFile.shareImage(image_filtered.path, basename(image_filtered.path));
            },
          )]))
      ],),
    );
  }

}