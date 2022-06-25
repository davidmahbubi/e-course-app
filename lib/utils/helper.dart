import 'dart:io';
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
