import 'dart:io';

void main(List<String> args) async {
  final String realInputPath = 'day5/real_input.txt';

  final String exampleInputPath = 'day5/example_input.txt';

  final String rawContent = await File(realInputPath).readAsString();

  final List<String> rawContentSplitted = rawContent.split('\n\n');

  final Cargo9000 cargo9000 =
      Cargo9000(parseCratesStacks(rawContentSplitted[0]));

  final List<CraneOperation> craneOperations =
      parseCraneOperations(rawContentSplitted[1]);

  print("Cargo :\n$cargo9000");
  print("Crane operations :\n$craneOperations");

  cargo9000.performAllOperations(craneOperations);

  print('End cargo with CrateMover 9000 : \n$cargo9000');

  print(
      "With CrateMover 9000, the top most crates are : ${cargo9000.topMostCrates}");

  final Cargo9001 cargo9001 =
      Cargo9001(parseCratesStacks(rawContentSplitted[0]));

  cargo9001.performAllOperations(craneOperations);

  print('End cargo with CrateMover 9001 :\n$cargo9001');

  print(
      "With CrateMover 9001, the top most crates are : ${cargo9001.topMostCrates}");
}

List<CratesStack> parseCratesStacks(String rawContent) {
  final Iterable<String> reversedLines =
      (rawContent.split('\n')..removeLast()).reversed;
  List<List<String>> stacks =
      List.generate((reversedLines.first.length + 1) ~/ 4, (index) => []);
  for (final String line in reversedLines) {
    final List<String> splittedLine = line.split('');

    for (int i = 0; i < (splittedLine.length + 1) ~/ 4; i++) {
      final String crate = splittedLine[i * 4 + 1];
      if (crate != ' ') stacks[i].add(crate);
    }
  }

  return stacks
      .asMap()
      .entries
      .map((e) => CratesStack(e.key, e.value))
      .toList();
}

List<CraneOperation> parseCraneOperations(String rawContent) => rawContent
    .split('\n')
    .map((String rawLine) => CraneOperationModel.parse(rawLine))
    .toList(growable: false);

abstract class Cargo {
  const Cargo(this.cratesStacks);

  final List<CratesStack> cratesStacks;

  void performOperation(CraneOperation op);

  void performAllOperations(List<CraneOperation> operations) {
    operations.forEach((element) => performOperation(element));
  }

  String get topMostCrates => cratesStacks.map((e) => e.upperCrate).join();

  @override
  String toString() => cratesStacks
      .map((CratesStack cratesStack) => cratesStack.toString())
      .join('\n');
}

class Cargo9000 extends Cargo {
  const Cargo9000(super.cratesStacks);

  @override
  void performOperation(CraneOperation op) {
    Iterable.generate(op.quantity).forEach(
      (_) =>
          cratesStacks[op.dest - 1].addOnTop(cratesStacks[op.source - 1].pop()),
    );
  }
}

class Cargo9001 extends Cargo {
  const Cargo9001(super.cratesStacks);

  @override
  void performOperation(CraneOperation op) {
    cratesStacks[op.dest - 1]
        .addAllsOnTop(cratesStacks[op.source - 1].popAll(op.quantity));
  }
}

class CratesStack {
  const CratesStack(this.index, this._crates);

  final int index;
  final List<String> _crates;

  String pop() => _crates.removeLast();

  void addOnTop(String value) => _crates.add(value);

  List<String> popAll(int quantity) {
    final List<String> poppedItems = _crates.sublist(_crates.length - quantity);
    _crates.removeRange(_crates.length - quantity, _crates.length);
    return poppedItems;
  }

  void addAllsOnTop(List<String> values) => _crates.addAll(values);

  String get upperCrate => _crates.last;

  @override
  String toString() => "${index} : ${_crates.map((element) => " [$element] ")}";
}

class CraneOperation {
  const CraneOperation({
    required this.quantity,
    required this.source,
    required this.dest,
  });

  final int quantity;
  final int source;
  final int dest;

  @override
  String toString() => "move $quantity from $source to $dest";
}

class CraneOperationModel extends CraneOperation {
  const CraneOperationModel({
    required super.quantity,
    required super.source,
    required super.dest,
  });

  factory CraneOperationModel.parse(String raw) {
    final List<String> splitted = raw.split(' ');
    return CraneOperationModel(
      quantity: int.parse(splitted[1]),
      source: int.parse(splitted[3]),
      dest: int.parse(splitted[5]),
    );
  }
}
