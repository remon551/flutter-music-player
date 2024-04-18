import 'package:flutter/material.dart';

class EditedTextWidget extends StatelessWidget {
  const EditedTextWidget(
      {super.key, required this.value, this.maxLines, this.inMiddle = true});
  final String value;
  final int? maxLines;
  final bool inMiddle;

  @override
  Widget build(BuildContext context) {
    if (inMiddle) {
      return Center(
          child: Text(
        value,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
      ));
    }
    return Text(
      value,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
    );
  }
}
