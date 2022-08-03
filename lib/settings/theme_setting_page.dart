import 'package:flutter/material.dart';
import 'package:note/main.dart';
import 'package:note/settings/theme.dart';
import 'package:get/get.dart';

class DarkMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 100,
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                    const Text(
                      "Theme",
                      style: TextStyle(
                          fontSize: 32, color: Colors.deepOrangeAccent),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                  onTap: () {
                    Get.changeThemeMode(ThemeMode.system);
                  },
                  title: Text("Use device setting"),
                  leading: Icon(Icons.brightness_4_outlined),
                  subtitle: const Text(
                    "Auttomatically swtich between Light and Dark themes when your system does",
                  )),
              ListTile(
                onTap: () {
                  Get.changeThemeMode(ThemeMode.light);
                },
                title: Text("Light Mode"),
                leading: Icon(Icons.brightness_5),
                subtitle: null,
              ),
              ListTile(
                leading: Icon(Icons.brightness_2),
                onTap: () {
                  Get.changeThemeMode(ThemeMode.dark);
                },
                title: Text("Dark Mode"),
                subtitle: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
