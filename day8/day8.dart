import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  final String realInputPath = 'day8/real_input.txt';

  final String exampleInputPath = 'day8/example_input.txt';

  final String rawContent = await File(exampleInputPath).readAsString();

  final Forest forest = parseData(rawContent);

  int visibleTrees = 0;
  int highestScenicScore = 0;
  for (int i = 0; i < forest.trees.length; i++) {
    for (int j = 0; j < forest.trees[0].length; j++) {
      if (forest.isTreeVisible(i, j)) {
        visibleTrees++;
        highestScenicScore = max(highestScenicScore, forest.scenicScore(i, j));
      }
    }
  }

  print('There are $visibleTrees trees visible.');
  print('The highest scenic score is $highestScenicScore');
}

Forest parseData(String rawContent) {
  final List<List<Tree>> treesGrid = rawContent
      .split('\n')
      .map(
        (String line) =>
            line.split('').map((String e) => Tree(int.parse(e))).toList(),
      )
      .toList(growable: false);
  return Forest(treesGrid);
}

class Forest {
  const Forest(this.trees);

  final List<List<Tree>> trees;

  bool isTreeVisible(int x, int y) =>
      _isTreeVisibleFromEdge(x, y, _treesInTheWayDown(x, y)) ||
      _isTreeVisibleFromEdge(x, y, _treesInTheWayUp(x, y)) ||
      _isTreeVisibleFromEdge(x, y, _treesInTheWayLeft(x, y)) ||
      _isTreeVisibleFromEdge(x, y, _treesInTheWayRight(x, y));

  bool _isTreeVisibleFromEdge(int x, int y, Iterable<Tree> treesInTheWay) =>
      treesInTheWay.every((element) => element.height < trees[x][y].height);

  Iterable<Tree> _treesInTheWayUp(int x, int y) =>
      List.generate(x, (index) => trees[index][y]).reversed;

  Iterable<Tree> _treesInTheWayDown(int x, int y) =>
      List.generate(trees.length - x - 1, (index) => trees[x + index + 1][y]);

  Iterable<Tree> _treesInTheWayLeft(int x, int y) =>
      trees[x].sublist(0, y).reversed;

  Iterable<Tree> _treesInTheWayRight(int x, int y) => trees[x].sublist(y + 1);

  int scenicScore(int x, int y) =>
      _scenicScoreOfOneDirection(x, y, _treesInTheWayDown(x, y)) *
      _scenicScoreOfOneDirection(x, y, _treesInTheWayUp(x, y)) *
      _scenicScoreOfOneDirection(x, y, _treesInTheWayLeft(x, y)) *
      _scenicScoreOfOneDirection(x, y, _treesInTheWayRight(x, y));

  int _scenicScoreOfOneDirection(int x, int y, Iterable<Tree> treesInTheWay) {
    final int smallerTreesAmount = treesInTheWay
        .takeWhile((element) => element.height < trees[x][y].height)
        .length;
    return (smallerTreesAmount < treesInTheWay.length)
        ? smallerTreesAmount + 1
        : smallerTreesAmount;
  }
}

class Tree {
  const Tree(this.height);

  final int height;
}
