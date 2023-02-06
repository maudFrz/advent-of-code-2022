import 'dart:io';

void main(List<String> args) async {
  final String realInputPath = 'day3/real_input.txt';

  final String exampleInputPath = 'day3/example_input.txt';

  final String rawContent = await File(realInputPath).readAsString();

  final List<RuckSack> rucksacks = parseData(rawContent);

  final int prioritiesSum = rucksacks.fold(
    0,
    (previousValue, element) =>
        previousValue + element.itemPresentInBothCompartment.priority,
  );

  print(
    'The sum of the priorities of the items that appears twice is : $prioritiesSum',
  );

  List<ElfGroup> elfGroups = <ElfGroup>[];
  for (int i = 0;
      i <= rucksacks.length - ElfGroup.elvesPerGroup;
      i = i + ElfGroup.elvesPerGroup) {
    elfGroups.add(ElfGroup(rucksacks.sublist(i, i + ElfGroup.elvesPerGroup)));
  }

  final int badgesPrioritiesSum = elfGroups.fold(
    0,
    ((previousValue, element) => previousValue + element.badge.priority),
  );

  print(
    'The sum of the priorities of the badges is  : $badgesPrioritiesSum',
  );
}

List<RuckSack> parseData(String rawContent) => rawContent
    .split('\n')
    .map((String rawRuckSack) => RuckSack(rawRuckSack))
    .toList(growable: false);

class ElfGroup {
  const ElfGroup(this.rucksacks);

  final List<RuckSack> rucksacks;

  static const int elvesPerGroup = 3;

  Item get badge {
    Set<Item> commonItems = rucksacks.first.allDistinctsItems;
    for (int i = 1; i < elvesPerGroup; i++) {
      commonItems = commonItems.intersection(rucksacks[i].allDistinctsItems);
    }
    return commonItems.first;
  }
}

class RuckSack {
  RuckSack(String content)
      : firstCompartment = content
            .substring(0, content.length ~/ 2)
            .split('')
            .map((e) => Item(e))
            .toList(growable: false),
        secondCompartment = content
            .substring(content.length ~/ 2)
            .split('')
            .map((e) => Item(e))
            .toList(growable: false);

  List<Item> firstCompartment;
  List<Item> secondCompartment;

  Set<Item> get allDistinctsItems =>
      {...firstCompartment, ...secondCompartment};

  Item get itemPresentInBothCompartment =>
      firstCompartment.toSet().intersection(secondCompartment.toSet()).first;
}

class Item {
  const Item(this.type);

  final String type;

  int get priority {
    final int codeUnit = type.codeUnitAt(0);

    // a -> z are in ASCII 97 -> 122
    if (97 <= codeUnit && codeUnit <= 122) {
      return codeUnit % 96;
    }

    // A -> Z are in ASCII 65 -> 90
    if (65 <= codeUnit && codeUnit <= 90) {
      return codeUnit % 64 + 26;
    }

    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && type == other.type;

  @override
  int get hashCode => type.hashCode;
}
