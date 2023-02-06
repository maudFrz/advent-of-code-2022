import 'dart:io' as io;

void main(List<String> args) async {
  final String realInputPath = 'day7/real_input.txt';

  final String exampleInputPath = 'day7/example_input.txt';

  final String rawContent = await io.File(realInputPath).readAsString();

  final List<Command> commands = parseData(rawContent);

  final FileSystem fileSystem = FileSystem(Directory('/'));

  List<String> path = [];

  for (final Command command in commands) {
    if (command is LsCommand) {
      Directory currentDir = fileSystem.rootDirectory;

      for (final String dir in path.sublist(1)) {
        currentDir =
            currentDir.content.singleWhere((e) => e.name == dir) as Directory;
      }
      currentDir.declareContent(command.dirContent);
    }
    if (command is CdCommand) {
      if (command.isOut) {
        path.removeLast();
      } else {
        path.add(command.destination);
      }
    }
  }

  print("File system : \n$fileSystem");
  print("Total file system size : ${fileSystem.rootDirectory.size}");

  final Iterable<Directory> directoriesWithSizeLesserThan100000 = fileSystem
      .rootDirectory.subDirectories
      .where((element) => element.size <= 100000);

  print('Directories with size under 100000 :');
  directoriesWithSizeLesserThan100000
      .forEach((e) => print(' - ${e.name} (${e.size})'));

  print(
      'Sum of the size : ${directoriesWithSizeLesserThan100000.toSet().fold(0, (int previousValue, element) => element.size + previousValue)}');

  print("Available space on disk : ${fileSystem.availableSpace}");
  final int updateSize = 30000000;
  final int sizeToFree = updateSize - fileSystem.availableSpace;

  List<Directory> subDirectoriesSorted = fileSystem.rootDirectory.subDirectories
    ..sort((a, b) => a.size.compareTo(b.size));

  print('Directories sorted by size :');
  subDirectoriesSorted.forEach((e) => print(' - ${e.name} (${e.size})'));

  final Directory directoryToDelete = subDirectoriesSorted
      .firstWhere((Directory dir) => dir.size >= sizeToFree);

  print(
    'We should delete the directory ${directoryToDelete.name} whith size ${directoryToDelete.size}',
  );
}

List<Command> parseData(String rawContent) => rawContent
    .replaceFirst('\$ ', '')
    .split('\n\$ ')
    .map(
      (String command) =>
          command.startsWith('ls') ? LsCommand(command) : CdCommand(command),
    )
    .toList(growable: false);

class LsCommand extends Command {
  const LsCommand(super.commandLine);

  List<FileOrDir> get dirContent => command
      .split('\n')
      .sublist(1)
      .map((e) => e.startsWith('dir') ? Directory.parse(e) : File.parse(e))
      .toList();

  @override
  String toString() =>
      '\$ ls\n${dirContent.map((e) => e.name.toString()).toList()}';
}

class CdCommand extends Command {
  const CdCommand(super.commandLine);

  String get destination => command.replaceAll('cd ', '');

  bool get isOut => destination == '..';

  @override
  String toString() => '\$ cd $destination';
}

abstract class Command {
  const Command(this.command);

  final String command;
}

class FileSystem {
  const FileSystem(this.rootDirectory);

  final Directory rootDirectory;

  static const int diskSize = 70000000;

  int get availableSpace => diskSize - rootDirectory.size;
}

/// Represents either a Directory or a File
abstract class FileOrDir {
  const FileOrDir(this.name);

  final String name;
  int get size;
}

class Directory extends FileOrDir {
  Directory(super.name) : content = const <FileOrDir>[];

  factory Directory.parse(String raw) => Directory(raw.replaceAll('dir ', ''));

  List<FileOrDir> content;

  void declareContent(List<FileOrDir> content) {
    this.content = content;
  }

  @override
  int get size => content.fold(
        0,
        (previousValue, element) => previousValue + element.size,
      );

  List<Directory> get directSubDirectories => <Directory>[
        ...content.whereType<Directory>(),
      ];

  List<Directory> get subDirectories => <Directory>[
        ...directSubDirectories,
        ...directSubDirectories
            .expand((Directory subDir) => subDir.subDirectories),
      ];

  @override
  String toString() =>
      "$name (dir)\n${content.map((FileOrDir e) => ' - ${e.toString()}\n')}";

  bool operator ==(o) => o is Directory && name == o.name && size == o.size;
  int get hashCode => Object.hash(name.hashCode, size.hashCode);
}

class File extends FileOrDir {
  const File(this.size, super.name);

  factory File.parse(String rawLine) {
    final List<String> splittedLine = rawLine.split(' ');
    return File(int.parse(splittedLine[0]), splittedLine[1]);
  }

  @override
  final int size;

  @override
  String toString() => "$name (file, size=$size)";
}
