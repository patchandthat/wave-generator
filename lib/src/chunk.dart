abstract class Chunk {
  String get sGroupId;

  int get length;

  Stream<int> bytes();
}

abstract class DataChunk extends Chunk {
  int get bytesPadding;
}
