// ignore_for_file: empty_constructor_bodies

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomInput extends HookWidget {
  TextEditingController controller;
  String? hintText;
  String? labelText;
  final Function(String)? validation;
  dynamic suffixIcon;
  dynamic prefixIcon;
  bool? isPassword;
  TextInputType? textType = TextInputType.text;
  int? minLines;
  int? maxLines;
  bool? isEnabled = true;

  CustomInput(
      {super.key,
      required this.controller,
      this.hintText,
      this.labelText,
      this.validation,
      this.suffixIcon,
      this.prefixIcon,
      this.isPassword,
      this.textType,
      this.minLines,
      this.maxLines,
      this.isEnabled
      });

  @override
  Widget build(BuildContext context) {
    final focussed = useState<bool>(false);
    final passwordVissible = useState<bool>(false);

    return TextFormField(
      enabled: isEnabled,
      style: DefaultTextStyle.of(context)
          .style
          .copyWith(fontStyle: FontStyle.normal, height: 2, fontSize: 14,),
      keyboardType: textType,
      cursorColor: Colors.black,
      obscureText: isPassword == true ? !passwordVissible.value : false,
      onTap: () => focussed.value = true,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword == true
            ? IconButton(
                icon: Icon(
                  passwordVissible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xff15B77C),
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                onPressed: () {
                  passwordVissible.value = !passwordVissible.value;
                })
            : null,
        filled: true,
        prefixIcon: prefixIcon,
        fillColor:
            focussed.value ? const Color(0xffDFEEE9) : const Color(0xffDFEEE9),
        hintText: hintText,
        labelText: labelText,
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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

class CustomInputField extends HookWidget {
  TextEditingController controller;
  String? hintText;
  String? labelText;
  final Function(String)? validation;
  dynamic suffixIcon;
  dynamic prefixIcon;
  int? minLines;
  int? maxLines;

  CustomInputField(
      {super.key,
      required this.controller,
      this.hintText,
      this.labelText,
      this.validation,
      this.suffixIcon,
      this.prefixIcon,
      this.minLines,
      this.maxLines
      });

  @override
  Widget build(BuildContext context) {
    final focussed = useState<bool>(false);
    final passwordVissible = useState<bool>(false);

    return TextFormField(
      style: DefaultTextStyle.of(context)
          .style
          .copyWith(fontStyle: FontStyle.italic, height: 2, fontSize: 16),
      keyboardType: TextInputType.multiline,
      minLines: minLines,
      maxLines: maxLines,
      onTap: () => focussed.value = true,
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        prefixIcon: prefixIcon,
        fillColor:
            focussed.value ? const Color(0xffDFEEE9) : const Color(0xffDFEEE9),
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

