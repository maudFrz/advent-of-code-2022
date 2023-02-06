import 'dart:io';

void main(List<String> args) async {
  final String realInputPath = 'day9/real_input.txt';

  final String exampleInputPath = 'day9/example_input.txt';

  final String example2InputPath = 'day9/example_input_2.txt';

  final String rawContent = await File(realInputPath).readAsString();

  final List<Motion> motions = parseData(rawContent);

  final SimpleRope simpleRope = SimpleRope.initial();

  motions.forEach((Motion m) => simpleRope.movesHeadAndTail(m));

  print(
      "Visited positions ammount for simple rope : ${simpleRope.visitedPosition.length}");

  final TenKnotsRope tenKnotsRope = TenKnotsRope.initial();

  motions.forEach((Motion m) {
    tenKnotsRope.moveHeadAndFollow(m);
  });

  print(
      "Visited positions ammount by tail of ten knot rope : ${tenKnotsRope.knots.last.visitedPosition.length}");
}

List<Motion> parseData(String rawContent) {
  List<String> lines = rawContent.split('\n');

  List<Motion> motions = <Motion>[];
  for (final String line in lines) {
    final List<String> lineSplitted = line.split(' ');
    motions.addAll(
      List.generate(
        int.parse(lineSplitted[1]),
        (_) => Motion.values.byName(lineSplitted[0]),
      ),
    );
  }
  return motions;
}

enum Motion { U, R, L, D }

class SimpleRope {
  SimpleRope.initial()
      : head = Position(0, 0),
        tail = Position(0, 0);

  Position head;
  Position tail;

  Set<Position> visitedPosition = {Position(0, 0)};

  void movesHeadAndTail(Motion headMotion) {
    moveHead(headMotion);
    moveTail();
  }

  void moveHead(Motion motion) {
    head = head.newPosition(motion);
  }

  bool doesTailNeedToMove() =>
      (head.x - tail.x).abs() >= 2 || (head.y - tail.y).abs() >= 2;

  void moveTail() {
    if (!doesTailNeedToMove()) {
      return;
    } else if (head.x == tail.x) {
      tail = Position(head.x, (tail.y < head.y) ? tail.y + 1 : tail.y - 1);
    } else if (head.y == tail.y) {
      tail = Position((tail.x < head.x) ? tail.x + 1 : tail.x - 1, head.y);
    } else {
      tail = Position((tail.x < head.x) ? tail.x + 1 : tail.x - 1,
          (tail.y < head.y) ? tail.y + 1 : tail.y - 1);
    }
    visitedPosition.add(tail);
  }
}

class TenKnotsRope {
  TenKnotsRope.initial()
      : knots = List.generate(9, (_) => SimpleRope.initial());

  final List<SimpleRope> knots;

  void moveHeadAndFollow(Motion headMotion) {
    Position newHeadPosition = knots[0].head.newPosition(headMotion);
    for (int i = 0; i < knots.length; i++) {
      knots[i].head = newHeadPosition;
      knots[i].moveTail();
      newHeadPosition = knots[i].tail;
    }
  }

  void printOutKnotsPositions() {
    for (int x = 0; x < knots.length; x++) {
      print('Head of rope segment $x : ${knots.first.head.toString()} ');
    }
  }
}

class Position {
  const Position(this.x, this.y);

  final int x;
  final int y;

  Position newPosition(Motion motion) {
    switch (motion) {
      case Motion.U:
        return Position(x, y + 1);
      case Motion.R:
        return Position(x + 1, y);
      case Motion.L:
        return Position(x - 1, y);
      case Motion.D:
        return Position(x, y - 1);
    }
  }

  @override
  String toString() => '($x,$y)';

  bool operator ==(o) => o is Position && x == o.x && y == o.y;
  int get hashCode => Object.hash(x.hashCode, y.hashCode);
}
