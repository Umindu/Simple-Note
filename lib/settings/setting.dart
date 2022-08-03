import 'package:flutter/material.dart';
import 'package:note/settings/theme_setting_page.dart';

class Setting extends StatelessWidget {
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
                      "Settings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32, color: Colors.deepOrangeAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {},
                title: Text("Account"),
                leading: Icon(Icons.account_circle_outlined),
                subtitle: null,
              ),
              ListTile(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DarkMode()),
                  );
                },
                title: Text("Themes"),
                leading: Icon(Icons.brightness_4_outlined),
                subtitle: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
