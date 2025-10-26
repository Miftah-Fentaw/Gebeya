import 'package:flutter/material.dart';


class Inputfield extends StatelessWidget {
  final String Label;
  final String TitleText;
  final TextEditingController? controller;
  const Inputfield({super.key, required this. Label, this.controller, required this.TitleText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              TitleText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              label: Text(
                Label,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              filled: true,
              fillColor: Colors.white70,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}