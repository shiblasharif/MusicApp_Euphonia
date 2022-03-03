import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notify = true;
  final snackBarNotify = SnackBar(
    content: const Text(
      'App need to restart to change the settings',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );

  @override
  void initState() {
    super.initState();
    getSwitchValues();
  }

  getSwitchValues() async {
    notify = await getSwitchState();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    return prefs.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notify = prefs.getBool("switchState");

    return notify ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B46),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091B46),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            title: const Text(
              "Notifications",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            trailing: IconButton(
                icon: Switch(
                    value: notify,
                    activeColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        notify = value;
                        saveSwitchState(value);
                        if (notify == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarNotify);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarNotify);
                        }
                      });
                    }),
                onPressed: () {}),
          ),
          ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onTap: () {},
            title: Text(
              'Share',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            onTap: () {},
            title: Text(
              'Privacy Policies',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.receipt,
              color: Colors.white,
            ),
            title: Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onTap: () => showAboutDialog(
                applicationIcon: Image.asset(
                  'assets/images/musiclogo.png',
                  width: 70,
                  height: 70,
                ),
                context: context,
                applicationName: 'Euphonia',
                applicationVersion: '1.0.0',
                children: [
                  Text(
                      "Euphonia is a Offline Music Player Created by Shibla Sharif.It's the First version of this App"),
                ]),
            title: Text(
              'About',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 250),
          bottom(),
        ],
      ),
    );
  }
}

Widget bottom() => Column(
      children: const [
        Text("Version", style: TextStyle(color: Colors.white, fontSize: 15)),
        Text(
          "1.0.0",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
