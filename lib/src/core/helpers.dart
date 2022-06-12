

String getFileExtension({required String fileName}) {
  print('testing $fileName');
  RegExp dotExp = RegExp(r'\.');

  if (!dotExp.hasMatch(fileName)) return '';

  print('there is a dot. Getting extension.');

  RegExp afterDotExp = RegExp(r'.*\.(\w+)$', dotAll: true);

  var matches = afterDotExp.firstMatch(fileName);
  if (matches != null) {
    return matches[1] as String;
  } else {
    return '';
  }
}
