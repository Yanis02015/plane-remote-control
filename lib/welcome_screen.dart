import 'package:flutter/material.dart';
import 'package:hanafi/configuration_screen.dart';
import 'package:flutter/services.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Welcome();
  }
}

class _Welcome extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF88D8FF),
                  Color(0xFFD899FF),
                ],
              ),
            ),
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // y
                      crossAxisAlignment: CrossAxisAlignment.center, // x
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.info),
                            color: Colors.white,
                            iconSize: 35,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("À propos"),
                                      content: const Text(
                                          "Cette application a été réalisée par: \n\n * MASSIOUN Hanafi \n *ABDALI Basma\n\nDans le cadre d'un projet fin d'étude automatique et informatique industrielle."),
                                      actions: [
                                        TextButton(
                                          child: const Text("Fermer"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: Image.asset(
                            "assets/images/logo.png",
                            height: 100,
                          ),
                        ),
                        const Text(
                          "Plane\nRemote Control",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text("Welcome to\nYour best remote control",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size(300, 60),
                                side: const BorderSide(
                                  width: 5.0,
                                  color: Colors.white,
                                )),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Configuration(),
                                ),
                              );
                            },
                            child: const Text(
                              'Commencer',
                              style: TextStyle(fontSize: 20),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                "AUTOMATIQUE INFORMATIQUE\nINDUSTRIELLE 2021-2022",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    )),
              ],
            )))));
  }
}
