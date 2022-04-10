import 'chunk.dart';

class DataChunk16 implements DataChunk {
  final String _sGroupId = 'data';
  // int _dwChunkSize;
  // Int16List _data;

  // nb- stored as two's-complement form

  static const int min = -32760;
  static const int max = 32760;

  @override
  Stream<int> bytes() {
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  // TODO: implement sGroupId
  String get sGroupId => _sGroupId;

  @override
  // TODO: implement bytesPadding
  int get bytesPadding => throw UnimplementedError();
}
