import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/group_form.dart';
import 'package:izibagde/screens/add_listUser_screen.dart';

class GroupScreen extends StatefulWidget {

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        backgroundColor: CustomColors.backgroundDark,
        title: Text("Add group"),
        //AppBarTitle()
        centerTitle: true,
        leadingWidth: 100,
        leading: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_left_sharp),
            label: const Text("Back",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.textSecondary,
                )),
            style: ElevatedButton.styleFrom(
                elevation: 0, primary: Colors.transparent)),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  CustomColors.backgroundDark,
                )),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListUserScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Text("Next",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.textSecondary,
                    )),
                Icon(Icons.arrow_right_sharp)
              ],
            ),
          )
        ],
      ),
      body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: GroupForm(),
          ),
        ),
    );
  }
}
