import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart'as imageLib;

class showImage extends StatefulWidget{
  File p;
  showImage(this.p);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _stae(p);
  }

}
class _stae extends State<showImage> {
  File ps ;
  _stae(this.ps);
  imageLib.Image _image;
  List<Filter> filters = presetFiltersList;

  Future getImage() async{
    var imageFile = ps;
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResizeCropSquare(image, 600);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBody: true,
      body: Stack(children: <Widget>[Positioned.fill(child:
      PhotoFilterSelector(image:_image,filters: presetFiltersList,filename: basename(ps.path),loader: CircularProgressIndicator(),circleShape: false,)), ],),
    );
  }

}