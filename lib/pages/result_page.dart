// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/home_page.dart';
import 'package:gg/pages/sharing_screen.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});
  static String id = 'result_page1';

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  File? _image;
  List<dynamic>? _output;
  bool _loading = false;
  String result = '';
  String result1 = '';
  String information = '';
  String information2 = '';

  bool moreInfo = false;
  List<dynamic>? _output1;
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _image = ModalRoute.of(context)!.settings.arguments as File;
    preprocessImage(_image!.path).then((imageAsBytes) {
      runModel(imageAsBytes).then((value) {
        if (result == 'Downy Mildew') {
          preprocessImage2(_image!.path).then((imageAsBytes) {
            runModel2(imageAsBytes);
          });
        }
      });
    });
  }

  Future<Uint8List> preprocessImage(String imagePath) async {
    img.Image image = img.decodeImage(File(imagePath).readAsBytesSync())!;
    image = img.copyResize(image, width: 250, height: 250);

    // Convert image to a list of normalized float values
    Float32List imageAsFloat32List = Float32List(250 * 250 * 3);
    for (int i = 0; i < 250; i++) {
      for (int j = 0; j < 250; j++) {
        int pixel = image.getPixel(j, i);
        imageAsFloat32List[(i * 250 + j) * 3 + 0] = img.getRed(pixel) / 255.0;
        imageAsFloat32List[(i * 250 + j) * 3 + 1] = img.getGreen(pixel) / 255.0;
        imageAsFloat32List[(i * 250 + j) * 3 + 2] = img.getBlue(pixel) / 255.0;
      }
    }
    return imageAsFloat32List.buffer.asUint8List();
  }

  Future<void> runModel(Uint8List imageAsBytes) async {
    _loading = true;
    Interpreter interpreter =
        await Interpreter.fromAsset('assets/model_1.tflite');

    var input = imageAsBytes.buffer.asUint8List();
    var output = List.filled(10, 0).reshape([1, 10]);

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
          result = context.tr('Anthracnose');
          information = context.tr('Anthracnose_info');
          break;
        case 1:
          result = context.tr('Bacterial Wilt');
          information = context.tr('Bacterial Wilt_info');
          break;
        case 2:
          result = context.tr('Belly Rot');
          information = context.tr('Belly Rot_info');
          break;
        case 3:
          result = context.tr('Downy Mildew');
          information = context.tr('Downy Mildew_info');
          break;
        case 4:
          result = context.tr('Fresh Cucumber');
          information = context.tr('Fresh cucumber info');
          break;
        case 5:
          result = context.tr('Fresh Leaf');
          information = context.tr('Fresh Leaf');
          break;
        case 6:
          result = context.tr('Gummy Stem Blight');
          information = context.tr('Gummy stem blight_info');
          break;
        case 7:
          result = context.tr('New Aphids');
          information = context.tr('Aphids_info');
          break;
        case 8:
          result = context.tr('New Whitefly');
          information = context.tr('New Whitefly_info');
          break;
        case 9:
          result = context.tr('Pythium Fruit Rot');
          information = context.tr('Pythium fruit Rot_info');
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

  Future<Uint8List> preprocessImage2(String imagePath) async {
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

  Future<void> runModel2(Uint8List imageAsBytes) async {
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
          result1 = context.tr('Early Stage');
          information2 = context.tr('Early stage_info');
          break;
        case 1:
          result1 = context.tr('Intermediate Stage');
          information2 = context.tr('Intermediate Stage_info');
          break;
        case 2:
          result1 = context.tr('Late Stage');
          information2 = context.tr('Late stage_info');
          break;
        case 3:
          result1 = context.tr('Fresh Leaf');
          information2 = context.tr('Fresh Leaf_info');
          break;
        default:
          result1 = context.tr('Unknown');
          information2 = '';
      }
    }
    setState(() {
      _loading = false;
      _output1 = output;
    });
    print('Prediction: $output');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 241, 224),
        title: Text(context.tr('Result')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(context, MyHomePage.id);
          },
        ),
      ),
      body: Center(
        child: (result1 == context.tr('Unknown') ||
                result == context.tr('Unknown'))
            ? Column(
                children: [
                  Center(
                    child: Image.file(
                      ModalRoute.of(context)!.settings.arguments
                          as File, // Replace with your image path
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
                              ModalRoute.of(context)!.settings.arguments);
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
            : Column(
                children: [
                  _loading
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
                                        // model 2 result
                                        if (_output1 != null) ...[
                                          Text(
                                            '${context.tr('Result')}: $result1'
                                            //  ${_output![0]['label']}'
                                            ,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Visibility(
                                              visible: moreInfo,
                                              child: Text(information2)),
                                        ]
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
                                            result1 = context.tr('Unknown');
                                            result = context.tr('Unknown');
                                          });
                                        },
                                        child: Text(context.tr('Share'))),
                                  ],
                                )
                              ],
                            )
                          : Text(context.tr('No image selected')),
                ],
              ),
      ),
    );
  }
}
