import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:tokin/seeImage.dart';
import 'package:tokin/showImage.dart';
import 'package:tokin/videoPlayer.dart';


class home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _stateI();
  }

}

class _stateI extends State<home> {

  var cameras ;
  var firstCamera;
  int selectedCamera = 0;
  CameraDescription useCamera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool recording = false;
  String videoName = "";

  void stopit(String p) async{
    _controller.stopVideoRecording();
    setState(() {
      recording   = false;
      videoName = "";
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => videoPlayer(p)));
  }

  void ChangeCamera() {
    if(selectedCamera==0){
      setState(() {
        selectedCamera = 1;
        firstCamera = cameras[1];
        _controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);
        _initializeControllerFuture = _controller.initialize();
      });
    }else{
      setState(() {
        selectedCamera = 0;
        firstCamera = cameras[0];
        _controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);
        _initializeControllerFuture = _controller.initialize();
      });
    }
  }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initialiseCamera();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();

  }

  void initialiseCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras[0];
    _controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);
    _initializeControllerFuture = _controller.initialize();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBody: true,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                CameraPreview(_controller),
                Positioned(top:50,left:20,child:Container(child:Text("TokIn", style: TextStyle(color:Colors.white,fontWeight:FontWeight.w900,fontSize: 50),))),
                Positioned(top: 700, left:60, child: Container(height:120,child:Center(child:ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                        onTap: () {ChangeCamera();},
                        child:Container(margin:EdgeInsets.all(20),decoration: BoxDecoration(color:Colors.pinkAccent, shape:BoxShape.circle),padding: EdgeInsets.all(10),
                    child:Icon(Icons.sync, color: Colors.white, size:30.0,))),
                    InkWell(
                        onTap: () async{
                          try {
                            if(!recording) {
                              await _initializeControllerFuture;
                              final pa = path.join(
                                  (await getTemporaryDirectory()).path,
                                  '${DateTime.now()}.png');
                              await _controller.takePicture(pa);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => seeImage(File(pa))));
                            }else{
                              stopit(videoName);
                            }

                          }catch(e){
                            print(e);
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Image Couldn't be saved!")));
                          }
                        },
                        child:Container(margin:EdgeInsets.all(20),decoration: BoxDecoration(color:Colors.pinkAccent, shape:BoxShape.circle),padding: EdgeInsets.all(10),
                        child:Icon(recording?Icons.stop:Icons.camera_alt, color: Colors.white, size:50.0,))),
                    recording?Container():InkWell(
                        onTap: () async{
                          try {
                            if(!recording) {
                              setState(() {
                                recording = true;
                              });
                              await _initializeControllerFuture;
                              final pa = path.join(
                                  (await getTemporaryDirectory()).path,
                                  '${DateTime.now()}.mp4');
                              setState(() {
                                videoName = pa;
                              });
                              await _controller.startVideoRecording(pa);
                            }else{
                              return null;
                            }

                          }catch(e){
                            print(e);
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Image Couldn't be saved!")));
                          }

                        },
                        child:Container(margin:EdgeInsets.all(20),decoration: BoxDecoration(color:Colors.pinkAccent, shape:BoxShape.circle),padding: EdgeInsets.all(10),
                        child:Icon(Icons.videocam, color: Colors.white, size:30.0,))),

                  ],
                ))))
              ],
              overflow:Overflow.visible,
            );
          }else{
            return Center(child:RaisedButton(onPressed:() {
              initialiseCamera();
              setState(() {
              });
            }, color:Colors.deepPurpleAccent,child:Text("Reload Camera", style: TextStyle(color:Colors.white, fontSize: 30),),padding: EdgeInsets.all(20),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),);
          }
        },
      ),
    );
  }

}