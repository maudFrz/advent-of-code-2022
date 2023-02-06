import 'dart:io';

void main(List<String> args) async {
  final String caloriesInputs =
      await _getFileContent('day1/calories_inputs.txt');

  List<Elf> elves = parseCaloriesInputs(caloriesInputs);

  elves.sort((a, b) => b.calories.compareTo(a.calories));

  print(
    "The elf n°${elves.first.index} has the snacks with the more calories, the total is ${elves.first.calories}",
  );

  int threeTopElvesCalories = elves
      .sublist(0, 3)
      .fold(0, (int previousValue, Elf elf) => previousValue + elf.calories);

  print(
      "The 3 elves carrying the most calories totalize : $threeTopElvesCalories");
}

Future<String> _getFileContent(String fileName) {
  return File(fileName).readAsString();
}

List<Elf> parseCaloriesInputs(String caloriesInputs) {
  final List<String> caloriesByElf = caloriesInputs.split('\n\n');
  print("There are ${caloriesByElf.length} elves carrying snacks.");

  return caloriesByElf
      .asMap()
      .entries
      .map(
        (MapEntry<int, String> elfEntry) => Elf(
          index: elfEntry.key,
          calories: elfEntry.value
              .split('\n')
              .map((String e) => int.parse(e))
              .toList(growable: false)
              .reduce((value, element) => value + element),
        ),
      )
      .toList(growable: false);
}

class Elf {
  const Elf({required this.index, required this.calories});

  final int index;
  final int calories;
}
