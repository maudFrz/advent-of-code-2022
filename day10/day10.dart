import 'dart:io';

void main(List<String> args) async {
  final String realInputPath = 'day10/real_input.txt';

  final String exampleInputPath = 'day10/large_example_input.txt';

  final String rawContent = await File(realInputPath).readAsString();

  final List<Instruction> instructions = parseData(rawContent);

  final CpuCycles cpu = CpuCycles();
  instructions.forEach(cpu.applyInstruction);

  int signalStrengthSum = 0;

  for (int i = 20; i <= 220; i = i + 40) {
    print('Value of X at cycle $i : ${cpu.getSignalStrengthAtCycle(i)}');
    signalStrengthSum = signalStrengthSum + cpu.getSignalStrengthAtCycle(i);
  }

  print(
    'Sum of the six signal strengths : ${signalStrengthSum}',
  );

  cpu.displayCRT();
}

List<Instruction> parseData(String rawContent) => rawContent
    .split('\n')
    .map((String instruction) =>
        instruction.startsWith('noop') ? Noop() : AddX(instruction))
    .toList(growable: false);

abstract class Instruction {
  const Instruction(this.instruction);

  final String instruction;
}

class Noop extends Instruction {
  const Noop() : super('noop');
}

class AddX extends Instruction {
  const AddX(super.instruction);

  int get valueXIncrement => int.parse(instruction.split(' ')[1]);
}

class CpuCycles {
  int x = 1;

  List<int> _valuesByCycle = <int>[];

  void applyInstruction(Instruction instruction) {
    if (instruction is Noop) {
      _tick();
    } else if (instruction is AddX) {
      _tick();
      _tick();
      x = x + instruction.valueXIncrement;
    }
  }

  int getSignalStrengthAtCycle(int cycle) =>
      _getValueAtCycle(cycle - 1) * cycle;

  int _getValueAtCycle(int cycle) => _valuesByCycle[cycle];

  void _tick() {
    _valuesByCycle.add(x);
  }

  void displayCRT() {
    int spriteCenter = 1;
    for (int row = 0; row < 6; row++) {
      String currentCrtRow = '';
      for (int cycle = 0; cycle < 40; cycle++) {
        spriteCenter = _valuesByCycle[cycle + row * 40];
        if (spriteCenter - 1 <= cycle && cycle <= spriteCenter + 1) {
          currentCrtRow = '$currentCrtRow#';
        } else {
          currentCrtRow = '$currentCrtRow.';
        }
      }
      print(currentCrtRow);
    }
  }
}
