import 'package:flutter/material.dart';
import 'package:hanafi/control_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration extends StatefulWidget {
  const Configuration({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Configuration();
  }
}

var ipServerController = TextEditingController();

class _Configuration extends State<Configuration> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _ipServer = 'Chargement';

  Future<void> getIpOnStorage() async {
    final SharedPreferences prefs = await _prefs;
    final String ip = prefs.getString('ip-server').toString();
    setState(() {
      _ipServer = 'IP SERVER: $ip';
      if (ip != 'null') loading = false;
    });
  }

  Future<void> setIpOnStorage(String ip) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('ip-server', ip);
  }

  void initState() {
    super.initState();
    print("initState");
    getIpOnStorage();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  bool loading = true;
  final _formKey = GlobalKey<FormState>();

  void setIp(String ip) {
    setState(() {
      ip.isNotEmpty
          ? _ipServer = 'IP SERVER: $ip'
          : _ipServer = "Aucune adresse IP attribué";
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child: SingleChildScrollView(
              child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // y
              crossAxisAlignment: CrossAxisAlignment.center, // x
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Image.asset(
                          "assets/images/Logo_Univ_Bejaia.png",
                          height: 100,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Image.asset(
                          "assets/images/atelogo.png",
                          height: 100,
                        ),
                      ),
                    ]),
                Title(
                    color: Colors.black,
                    child: const Text(
                      "Wireless Control",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    _ipServer,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 60),
                    ),
                    onPressed: loading
                        ? null
                        : () {
                            // ping before navigate
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ControlScreen(),
                              ),
                            );
                          },
                    child: Text(
                      loading ? "Chargement..." : "Continuer",
                      style: TextStyle(fontSize: 22),
                    )),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: Stack(
                                children: <Widget>[
                                  InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: ipServerController,
                                              decoration: const InputDecoration(
                                                  labelText: "IP SERVER",
                                                  hintText: 'http://...'),
                                            ),
                                          ),
                                          const Text(
                                              "L'IP doit être de la forme suivante: http://ip:port/ exemple:\n"),
                                          const Text(
                                              "http://192.168.1.98:8081/",
                                              style: TextStyle(
                                                  color: Colors.green)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              child: const Text("Confirmer"),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  Navigator.of(context).pop();
                                                  var ip =
                                                      ipServerController.text;
                                                  await setIpOnStorage(ip);
                                                  setState(() {
                                                    _ipServer =
                                                        "IP SERVER: $ip";
                                                    loading = false;
                                                  });
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                    // ping before navigate
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ControlScreen(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                  child: const Text("Configurer la connexion"),
                )
              ],
            ),
          ))),
    );
  }
}
