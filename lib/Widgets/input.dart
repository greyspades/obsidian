// ignore_for_file: empty_constructor_bodies

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomInput extends HookWidget {

  TextEditingController controller;
  String? hintText;
  String? labelText;
  final Function(String)? validation;
  IconButton? suffixIcon;
  IconButton? prefixIcon;
  bool? isPassword;
  CustomInput({super.key, required this.controller, this.hintText, this.labelText, this.validation, this.suffixIcon, this.prefixIcon, this.isPassword});

  @override
  Widget build(BuildContext context) {
    final focussed = useState<bool>(false);
    final passwordVissible = useState<bool>(false);
    
    return TextFormField(
    obscureText: isPassword == true ? !passwordVissible.value : false,
    onTap: () => focussed.value = true,
    controller: controller,
    decoration: InputDecoration(
    suffixIcon: isPassword == true ? IconButton(icon: Icon(
      passwordVissible.value ? Icons.visibility : Icons.visibility_off,
      color: const Color(0xff15B77C),
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ), onPressed: () {
      passwordVissible.value = !passwordVissible.value;
    }
    ): null,
    filled: true,
    fillColor: focussed.value ? const Color(0xffDFEEE9) : const Color(0xffD9D9D9),
    hintText: hintText,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.black),
    focusColor: const Color(0xffDFEEE9),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff15B77C),
        width: 3.0,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff15B77C),
        width: 3.0,
      ),
    ),
  ),
  validator: ((value) => validation!(value ?? '')),
);
  }
}