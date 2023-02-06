import 'dart:io';

void main(List<String> args) async {
  final String realInputPath = 'day4/real_input.txt';

  final String exampleInputPath = 'day4/example_input.txt';

  final String rawContent = await File(realInputPath).readAsString();

  final List<MainObject> elements = parseData(rawContent);

  // final int result = elements.fold(
  //   0,
  //   ((previousValue, element) =>
  //       element.isFullOverlap() ? previousValue + 1 : previousValue),
  // );

  // print(
  //   'There are ',
  // );

  // final int result2 = elements.fold(
  //   0,
  //   ((previousValue, element) =>
  //       element.isOverlap() ? previousValue + 1 : previousValue),
  // );

  // print(
  //   'There are',
  // );
}

List<MainObject> parseData(String rawContent) => rawContent
    .split('\n')
    .map((String rawElfPair) => MainObjectModel.parse(rawElfPair))
    .toList(growable: false);

class MainObject {
  const MainObject();
}

class MainObjectModel extends MainObject {
  MainObjectModel() : super();

  factory MainObjectModel.parse(String rawElfPairs) {
    final List<String> split = rawElfPairs.split(',');
    return MainObjectModel();
  }
}
