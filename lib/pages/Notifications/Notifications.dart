import 'package:gebeya/constants/Colors.dart';
import 'package:flutter/material.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Notifications',style: TextStyle(
          color: black,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              secondaryColor,
            ],
          )
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 10),
            child: Center(
              child: Text('there are no Notifications',style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),),
            )
              
            ),
          ),
          ),
    );
    
}
}