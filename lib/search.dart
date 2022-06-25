import 'parsed/parsed_cv.dart';

List<ParsedCV> filterCVs(List<ParsedCV> data, String querry) {
  var orQuerry = querry.split("|");
  var binOutput = <bool>[];
  for (int i = 0; i < orQuerry.length; i++) {
    var andQuerry = orQuerry[i].split("&");
    var curAndBin = findCVs(data, generateRegExp(andQuerry[0]));

    for (int j = 1; j < andQuerry.length; j++) {
      curAndBin =
          andList(curAndBin, findCVs(data, generateRegExp(andQuerry[i])));
    }
    if (binOutput.isEmpty) {
      binOutput = curAndBin;
    } else {
      binOutput = orList(binOutput, curAndBin);
    }
  }

  var filtered = <ParsedCV>[];
  for (int i = 0; i < binOutput.length; i++) {
    if (binOutput[i]) filtered.add(data[i]);
  }
  return filtered;
}

List<bool> andList(List<bool> a, List<bool> b) {
  var output = List.generate(a.length, (index) => false);
  for (var i = 0; i < a.length; i++) {
    if (a[i] && b[i]) {
      output[i] = true;
    }
  }
  return output;
}

List<bool> orList(List<bool> a, List<bool> b) {
  var output = List.generate(a.length, (index) => false);
  for (var i = 0; i < a.length; i++) {
    if (a[i] || b[i]) {
      output[i] = true;
    }
  }
  return output;
}

List<bool> findCVs(List<ParsedCV> data, RegExp querry) {
  var output = List.generate(data.length, (index) => false);
  for (var i = 0; i < data.length; i++) {
    if (data[i].satisfies(querry)) {
      output[i] = true;
    }
  }
  return output;
}

RegExp generateRegExp(String querry) {
  RegExp fnPattern =
      new RegExp(r"(?<=filename:)(.*?)(?=label:|match:|sentence:|$)");
  RegExp lblPattern =
      new RegExp(r"(?<=label:)(.*?)(?=filename:|match:|sentence:|$)");
  RegExp matchPattern =
      new RegExp(r"(?<=match:)(.*?)(?=filename:|label:|sentence:|$)");
  RegExp sentencePattern =
      new RegExp(r"(?<=sentence:)(.*?)(?=filename:|label:|match:|$)");

  var str_tmp = "";
  if (!(new RegExp("filename:|label:|match:|sentence:")).hasMatch(querry)) {
    str_tmp = querry;
  } else {
    if (fnPattern.hasMatch(querry)) {
      str_tmp += "filename:.*" + fnPattern.stringMatch(querry)!.trim() + ".*\n";
    }
    if (lblPattern.hasMatch(querry)) {
      str_tmp += "label:.*" + lblPattern.stringMatch(querry)!.trim() + ".*\n";
    }
    if (matchPattern.hasMatch(querry)) {
      str_tmp += "match:.*" + matchPattern.stringMatch(querry)!.trim() + ".*\n";
    }
    if (sentencePattern.hasMatch(querry)) {
      str_tmp +=
          "sentence:.*" + sentencePattern.stringMatch(querry)!.trim() + ".*\n";
    }
  }
  RegExp regExp = RegExp(str_tmp, unicode: true, caseSensitive: false);
  return regExp;
}
