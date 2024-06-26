import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/sharing_screen.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// Load image and preprocess

class StagesScreen extends StatefulWidget {
  const StagesScreen({super.key});
  static String id = 'stagesscreen';
  @override
  _StagesScreenState createState() => _StagesScreenState();
}

class _StagesScreenState extends State<StagesScreen> {
  File? _image;
  List<dynamic>? _output;
  bool _loading = false;
  String result = '';
  String information = '';
  bool moreInfo = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Uint8List> preprocessImage(String imagePath) async {
    img.Image image = img.decodeImage(File(imagePath).readAsBytesSync())!;
    image = img.copyResize(image, width: 160, height: 160);

    // Convert image to a list of normalized float values
    Float32List imageAsFloat32List = Float32List(160 * 160 * 3);
    for (int i = 0; i < 160; i++) {
      for (int j = 0; j < 160; j++) {
        int pixel = image.getPixel(j, i);
        imageAsFloat32List[(i * 160 + j) * 3 + 0] = img.getRed(pixel) / 255.0;
        imageAsFloat32List[(i * 160 + j) * 3 + 1] = img.getGreen(pixel) / 255.0;
        imageAsFloat32List[(i * 160 + j) * 3 + 2] = img.getBlue(pixel) / 255.0;
      }
    }
    return imageAsFloat32List.buffer.asUint8List();
  }

  Future<void> runModel(Uint8List imageAsBytes) async {
    _loading = true;
    Interpreter interpreter =
        await Interpreter.fromAsset('assets/model.tflite');

    var input = imageAsBytes.buffer.asUint8List();
    var output = List.filled(5, 0).reshape([1, 5]);

    interpreter.run(input, output);
    interpreter.close();

    // Find the index with the maximum probability
    int maxIndex = 0;
    double maxProbability = output[0][0];
    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > maxProbability) {
        maxIndex = i;
        maxProbability = output[0][i];
      }
    }

    if (mounted) {
      switch (maxIndex) {
        case 0:
          result = context.tr('Early Stage');
          information = context.tr('Early stage_info');
          break;
        case 1:
          result = context.tr('Intermediate Stage');
          information = context.tr('Intermediate Stage_info');
          break;
        case 2:
          result = context.tr('Late Stage');
          information = context.tr('Late stage_info');
          break;
        case 3:
          result = context.tr('Fresh Leaf');
          information = context.tr('Fresh Leaf_info');
          break;
        default:
          result = context.tr('Unknown');
          information = '';
      }
    }
    setState(() {
      _loading = false;
      _output = output;
    });
    print('Prediction: $output');
  }

  Future<void> _pickImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });

    // await classifyImage(_image!);
    await runModel(await preprocessImage(_image!.path));
  }

  Future<void> _pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Stages')),
      ),
      backgroundColor: const Color.fromARGB(255, 221, 241, 224),
      body: Center(
        child: (result == context.tr('Unknown'))
            ? Column(
                children: [
                  Center(
                    child: Image.file(
                      _image!, // Replace with your image path
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    alignment: Alignment.center, // Align text to the right
                    child: Text(
                      context.tr('Not Sure'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    alignment: Alignment.center, // Align text to the right
                    child: Text(
                      context.tr('help share'),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, SharingScreen.id, (route) => false,
                          arguments:
                              _image); // Replace with your image path
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(400, 60)),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      // Adjust other properties as needed
                    ),
                    child: Text(
                      context.tr('Share'),
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ],
              )
            : _loading
                ? const CircularProgressIndicator()
                : _output != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 300,
                            height: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.lightGreen,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _image!,
                              width: 300,
                              height: 300,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${context.tr('Result')}: $result'
                                    //  ${_output![0]['label']}'
                                    ,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Visibility(
                                      visible: moreInfo,
                                      child: Text(information)),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      moreInfo = !moreInfo;
                                    });
                                  },
                                  child: Text(context.tr('More Info'))),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      result = context.tr('Unknown');
                                    });
                                  },
                                  child: Text(context.tr('Share'))),
                            ],
                          )
                        ],
                      )
                    : Text(context.tr('No image selected')),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: _pickImageFromGallery,
            tooltip: 'Pick Image from Gallery',
            child: const Icon(Icons.image),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: _pickImageFromCamera,
            tooltip: 'Capture Image from Camera',
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
