import 'dart:io';

void main(List<String> args) async {
  final String realInputPath = 'day4/real_input.txt';

  final String exampleInputPath = 'day4/example_input.txt';

  final String rawContent = await File(realInputPath).readAsString();

  final List<ElfPair> elfpairs = parseData(rawContent);

  final int fullOverlapingPairs = elfpairs.fold(
    0,
    (previousValue, element) =>
        element.isFullOverlap() ? previousValue + 1 : previousValue,
  );

  print(
    'There are ${fullOverlapingPairs} pairs of elfs that fully overlaps',
  );

  final int overlapingPairs = elfpairs.fold(
    0,
    (previousValue, element) =>
        element.isOverlap() ? previousValue + 1 : previousValue,
  );

  print(
    'There are ${overlapingPairs} pairs of elfs that overlaps',
  );
}

List<ElfPair> parseData(String rawContent) => rawContent
    .split('\n')
    .map((String rawElfPair) => ElfPairModel.parse(rawElfPair))
    .toList(growable: false);

class ElfPair {
  const ElfPair(this.elf1Sections, this.elf2Sections);

  final SectionsRange elf1Sections;
  final SectionsRange elf2Sections;

  bool isFullOverlap() =>
      elf1Sections.contains(elf2Sections) ||
      elf2Sections.contains(elf1Sections);

  bool isOverlap() => elf1Sections.overlaps(elf2Sections);
}

class SectionsRange {
  const SectionsRange(this.downRange, this.upperRange);

  final int downRange;
  final int upperRange;

  bool contains(SectionsRange s2) =>
      downRange <= s2.downRange && s2.upperRange <= upperRange;

  bool overlaps(SectionsRange s2) =>
      (upperRange >= s2.downRange && downRange <= s2.upperRange) ||
      (downRange >= s2.upperRange && upperRange <= s2.downRange);
}

class SectionsRangeModel extends SectionsRange {
  SectionsRangeModel(super.downRange, super.upperRange);

  factory SectionsRangeModel.parse(String rawSection) {
    final List<String> splittedSections = rawSection.split('-');
    return SectionsRangeModel(
      int.parse(splittedSections[0]),
      int.parse(splittedSections[1]),
    );
  }
}

class ElfPairModel extends ElfPair {
  ElfPairModel(super.elf1Sections, super.elf2Sections);

  factory ElfPairModel.parse(String rawElfPairs) {
    final List<String> splittedElfs = rawElfPairs.split(',');
    return ElfPairModel(
      SectionsRangeModel.parse(splittedElfs[0]),
      SectionsRangeModel.parse(splittedElfs[1]),
    );
  }
}
