import 'package:flutter/material.dart';
import 'package:music_player/utils/constatns.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.maxLines,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.initialValue,
  });

  final String hintText;
  final String labelText;
  final String? initialValue;
  final int? maxLines;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          border: const OutlineInputBorder(borderSide: BorderSide()),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2)),
          hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: kdefaultTextColor,
          ),
          hintStyle: const TextStyle(
            color: kdefaultTextColor,
          ),
          focusColor: kdefaultTextColor),
    );
  }
}
