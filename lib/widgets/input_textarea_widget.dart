import 'package:flutter/material.dart';
import 'package:submission_proyek3/common/styles.dart';

class InputTextareaWidget extends StatelessWidget {
  const InputTextareaWidget({
    super.key,
    this.controller,
    this.onEditingComplete,
    this.textInputAction,
    required this.hintText,
    this.minLines,
    this.validator,
    this.autovalidateMode,
    this.errorText,
    this.initialValue,
  });

  final TextEditingController? controller;
  final void Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  final String hintText;
  final String? errorText;
  final String? initialValue;
  final int? minLines;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 253, 226),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: primaryColor,
          width: 0.1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        minLines: minLines,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        validator: validator,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 7),
          errorText: errorText,
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 12, color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }
}
