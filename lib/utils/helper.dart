import 'dart:io';
import 'package:flutter/material.dart';
import 'package:random_string_generator/random_string_generator.dart';

String randomizeFileName(File file) {
  RandomStringGenerator generator = RandomStringGenerator(
    fixedLength: 10,
    hasDigits: false,
    hasSymbols: false,
    mustHaveAtLeastOneOfEach: true,
  );
  return '${generator.generate()}.${getFileExtension(file)}';
}

String getFileExtension(File file) {
  String filePath = file.path;
  List<String> filePathArr = filePath.split('.');
  return filePathArr[filePathArr.length - 1];
}

MaterialColor generateWhiteSwatch() {
  return const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
}
