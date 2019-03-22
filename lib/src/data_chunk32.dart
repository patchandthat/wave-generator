import 'dart:typed_data';

import 'package:wave_generator/src/chunk.dart';

class DataChunk32 implements DataChunk {

  final String _sGroupId = "data";
  int _dwChunkSize;
  List<double> _data;

  static const double min = -1.0;
  static const double max = 1.0;

  @override
  Stream<int> bytes() {
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  // TODO: implement sGroupId
  String get sGroupId => throw UnimplementedError();

  @override
  // TODO: implement bytesPadding
  int get bytesPadding => null;
}