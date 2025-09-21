import 'package:flutter/material.dart';

class CardInfoNoteScreen extends StatelessWidget {
  const CardInfoNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a note',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
