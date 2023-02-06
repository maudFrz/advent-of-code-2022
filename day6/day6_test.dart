import 'package:test/test.dart';
import 'day6.dart';

void main(List<String> args) {
  group('The start-of-packet marker should be detected', () {
    Map<String, int?> problemSolutionMap = {
      'mjqjpqmgbljsphdztnvjfqwrcgsmlb': 7,
      'bvwbjplbgvbhsrlpgdmjqwftvncz': 5,
      'nppdvjthqldpwncqszvftbrmjlhg': 6,
      'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg': 10,
      'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw': 11,
    };

    for (final MapEntry<String, int?> problemAndSolution
        in problemSolutionMap.entries) {
      test(
          '${problemAndSolution.value != null ? 'at range ${problemAndSolution.value}' : 'as absent'} for signal ${problemAndSolution.key}',
          () {
        expect(findStartOfPacket(problemAndSolution.key),
            equals(problemAndSolution.value));
      });
    }
  });

  group('The start-of-message marker should be detected', () {
    Map<String, int?> problemSolutionMap = {
      'mjqjpqmgbljsphdztnvjfqwrcgsmlb': 19,
      'bvwbjplbgvbhsrlpgdmjqwftvncz': 23,
      'nppdvjthqldpwncqszvftbrmjlhg': 23,
      'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg': 29,
      'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw': 26,
    };

    for (final MapEntry<String, int?> problemAndSolution
        in problemSolutionMap.entries) {
      test(
          '${problemAndSolution.value != null ? 'at range ${problemAndSolution.value}' : 'as absent'} for signal ${problemAndSolution.key}',
          () {
        expect(findStartOfMessage(problemAndSolution.key),
            equals(problemAndSolution.value));
      });
    }
  });
}
