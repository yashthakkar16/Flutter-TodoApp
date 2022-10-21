import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final String title, task;
  const Description({Key? key, required this.title, required this.task})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Description"),
      ),
      body: Container(
          margin: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                task,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                ),
              )
            ],
          )),
    );
  }
}
