import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MaterialApp(
      home: Scaffold(body: VideoDemo())));
}

class VideoDemo extends StatefulWidget {
  const VideoDemo({Key? key}) : super(key: key);


  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  //
  double _currentSliderValue = 0;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {

    _controller = VideoPlayerController.asset('videos/butterfly.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _slider() async {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        _currentSliderValue = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _slider();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,// расположение кнопки play
      appBar: AppBar(
        title: const Text("VideoPlayer"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                const SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: Slider(
                      activeColor: Colors.black,
                      inactiveColor: Colors.black45,
                      value: _currentSliderValue,
                      min: 0,
                      max: _controller.value.duration.inSeconds.toDouble(),
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue =
                              _controller.value.position.inSeconds.toDouble();
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        });
                      }),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
        Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {},
              iconSize: 40.0,
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TakePictureScreen(camera: cameras!.first)));
                _controller.pause();
              },
              iconSize: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // create a CameraController.
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    // Next, initialize the controller.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                color: Colors.black,
                child: Center(child: CameraPreview(_controller)));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 40.0,
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {},
              iconSize: 40.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          mini: true,
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              print(image.path);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imagePath: image.path,
                  ),
                ),
              );
            } catch (e) {
              print("error");
            }
          },
          child: const Icon(Icons.camera)));
  }
}


class DisplayPictureScreen extends StatelessWidget {                            //картинка после сделанной фотографии
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture'), backgroundColor: Colors.black45,),
      body: Container(
          color: Colors.black45,
          child: Center(child: Image.file(File(imagePath)))),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const VideoDemo()));
              },
              iconSize: 40.0,
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}