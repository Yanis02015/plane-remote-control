import 'dart:io';
import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double pi = 3.1415926535897932;
const double minimalSensitivity = 0.4;
const top = "U";
const bottom = "D";
const right = "R";
const left = "L";
const topRight = "UR";
const topLeft = "UL";
const bottomRight = "DR";
const bottomLeft = "DL";
const init = "init";
const speed = "speed";
const stop = "stop";
const List<String> arrayOfRequestParams = [
  top,
  bottom,
  right,
  left,
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
  init
];

bool isSending = false;
String lastSent = "";
double varDegress = 0;
double varDistance = 0;
String url = "";
bool ready = false;

class ControlScreen extends StatefulWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ControlScreen();
  }
}

class _ControlScreen extends State<ControlScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isOnSpeed = false;
  bool isOnDirectionChange = false;

  Future<void> setIsOnDirectionChange(bool value) async {
    setState(() {
      isOnDirectionChange = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getIpFromStorage();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> getIpFromStorage() async {
    final SharedPreferences prefs = await _prefs;
    final String ip = prefs.getString('ip-server').toString();
    url = ip;
    ready = true;
  }

  String getDirection() {
    final bool isFar = varDistance > minimalSensitivity;
    if (!isFar) return "";

    final tCondition = varDegress < 60 || varDegress > 300;
    final trCondition = varDegress > 30 && varDegress < 60;
    final tlCondition = varDegress < 330 && varDegress > 300;
    final bCondition = varDegress > 120 && varDegress < 240;
    final brCondition = varDegress < 160 && varDegress > 120;
    final blCondition = varDegress > 210 && varDegress < 240;
    final rCondition = varDegress >= 60 && varDegress <= 120;
    final lCondition = varDegress >= 240 && varDegress <= 300;

    if (tCondition) {
      return top +
          (tlCondition
              ? left
              : trCondition
                  ? right
                  : "");
    }

    if (bCondition) {
      return bottom +
          (brCondition
              ? right
              : blCondition
                  ? left
                  : "");
    }

    if (rCondition) return right;

    if (lCondition) return left;

    return "";
  }

  void fetchDirection() async {
    bool conditionLoop = true;
    while (conditionLoop) {
      String direction = getDirection();
      String res = direction;
      conditionLoop = res.isNotEmpty;
      if (lastSent != res && res.isNotEmpty) {
        if (arrayOfRequestParams.contains(res) && lastSent != init) {
          dioCall(init);
        }
        lastSent = res;
        dioCall(res);
      }
      await Future.delayed(const Duration(microseconds: 300));
    }
    if (lastSent.isNotEmpty && lastSent != init) {
      lastSent = init;
      dioCall(init);
    }
    isSending = false;
  }

  Future dioCall(String param) async {
    final api = Dio(BaseOptions(
      baseUrl: '$url/',
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      headers: {
        'Content-type': ContentType.json.mimeType,
      },
    ));

    try {
      api.get(param);
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Plane Remote Control'),
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF88d8ff),
                Color(0xffd899ff),
              ],
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 6, // 20%
                child: JoystickView(
                  backgroundColor: const Color.fromARGB(53, 0, 0, 0),
                  innerCircleColor: const Color.fromARGB(20, 0, 0, 0),
                  showArrows: false,
                  size: 150,
                  onDirectionChanged:
                      (double degrees, double distanceFromCenter) {
                    varDegress = degrees;
                    varDistance = distanceFromCenter;
                    if (!isSending && ready) {
                      isSending = true;
                      fetchDirection();
                    }
                  },
                ),
              ),
              Expanded(
                  flex: 4, // 60%
                  child: GestureDetector(
                    onPanStart: (details) {
                      dioCall(speed);
                      setState(() {
                        isOnSpeed = true;
                      });
                    },
                    onPanEnd: (details) {
                      dioCall(stop);
                      setState(() {
                        isOnSpeed = false;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isOnSpeed
                                ? Color.fromARGB(185, 216, 153, 255)
                                : const Color.fromARGB(90, 0, 0, 0),
                            width: 4),
                        shape: BoxShape.circle,
                        color: isOnSpeed
                            ? Color(0x63D899FF)
                            : const Color.fromARGB(30, 0, 0, 0),
                      ),
                      // Change button text when light changes state.
                      child: Icon(
                        Icons.speed,
                        color: isOnSpeed
                            ? const Color(0xFF88D8FF)
                            : const Color.fromARGB(53, 0, 0, 0),
                        size: 50,
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
