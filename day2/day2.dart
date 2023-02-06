import 'dart:io';

void main(List<String> args) async {
  // Path of the asset containing the full strategy guide
  final String strategyGuidePath = 'day2/strategy_guide.txt';

  // Path of the asset containing the example strategy guide
  final String exampleGuidePath = 'day2/example_strategy_guide.txt';

  final String rawStrategyGuide = await File(strategyGuidePath).readAsString();

  final List<Round> roundsFirstStrategy =
      parseGuide(rawStrategyGuide, parseRoundFirstStrategy);

  print(
      "Following the first part strategy, after ${roundsFirstStrategy.length} rounds, I have won "
      "${roundsFirstStrategy.fold(0, (int previousValue, Round round) => previousValue + round.score)} points");

  final List<Round> rounds2ndStrategy =
      parseGuide(rawStrategyGuide, parseRoundSecondStrategy);

  print(
      "Following the second part strategy, after ${rounds2ndStrategy.length} rounds, I have won "
      "${rounds2ndStrategy.fold(0, (int previousValue, Round round) => previousValue + round.score)} points");
}

List<Round> parseGuide(String guide, Round Function(String) roundParser) {
  return guide.split('\n').map(roundParser).toList(growable: false);
}

Round parseRoundFirstStrategy(String rawRound) {
  final List<String> rawSigns = rawRound.split(' ');
  return Round(Sign.parseData(rawSigns[0]), Sign.parseData(rawSigns[1]));
}

Round parseRoundSecondStrategy(String rawRound) {
  final List<String> rawSigns = rawRound.split(' ');

  final Sign opponentGame = Sign.parseData(rawSigns[0]);
  final RoundOutcome roundOutcome = RoundOutcome.parseData(rawSigns[1]);

  Sign myGame;
  switch (roundOutcome) {
    case RoundOutcome.win:
      myGame = opponentGame.beatenBy;
      break;
    case RoundOutcome.draw:
      myGame = opponentGame;
      break;
    case RoundOutcome.lost:
      myGame = Sign.values.singleWhere(
          (Sign sign) => sign != opponentGame && sign != opponentGame.beatenBy);
      break;
  }

  return Round(opponentGame, myGame);
}

enum Sign {
  rock,
  paper,
  scissors;

  int get score {
    switch (this) {
      case Sign.rock:
        return 1;
      case Sign.paper:
        return 2;
      case Sign.scissors:
        return 3;
    }
  }

  Sign get beatenBy {
    switch (this) {
      case Sign.rock:
        return Sign.paper;
      case Sign.paper:
        return Sign.scissors;
      case Sign.scissors:
        return Sign.rock;
    }
  }

  static Sign parseData(String char) {
    switch (char) {
      case 'A':
      case 'X':
        return Sign.rock;
      case 'B':
      case 'Y':
        return Sign.paper;
      case 'C':
      case 'Z':
        return Sign.scissors;
      default:
        throw (UnimplementedError());
    }
  }
}

enum RoundOutcome {
  win,
  lost,
  draw;

  int get score {
    switch (this) {
      case RoundOutcome.win:
        return 6;
      case RoundOutcome.lost:
        return 0;
      case RoundOutcome.draw:
        return 3;
    }
  }

  static RoundOutcome compute(Sign opponent, Sign me) {
    if (opponent == me) return RoundOutcome.draw;
    if (opponent.beatenBy == me) return RoundOutcome.win;
    return RoundOutcome.lost;
  }

  static RoundOutcome parseData(String char) {
    switch (char) {
      case 'X':
        return RoundOutcome.lost;
      case 'Y':
        return RoundOutcome.draw;
      case 'Z':
        return RoundOutcome.win;
      default:
        throw (UnimplementedError());
    }
  }
}

class Round {
  const Round(this.opponentGame, this.myGame);

  final Sign opponentGame;
  final Sign myGame;

  // We could have here a getter to compute the outcome of the match
  RoundOutcome get roundOutcome => RoundOutcome.compute(opponentGame, myGame);

  int get score => myGame.score + roundOutcome.score;
}
