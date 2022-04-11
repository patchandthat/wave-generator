import 'dart:typed_data';

import 'byte_helpers.dart';
import 'chunk.dart';
import 'format_chunk.dart';

class WaveHeader implements Chunk {
  final String _sGroupId = 'RIFF';
  final String _sRifType = 'WAVE';

  final FormatChunk formatChunk;
  final DataChunk dataChunk;

  const WaveHeader(this.formatChunk, this.dataChunk);

  @override
  int get length =>
      4 +
      (8 + formatChunk.length) +
      (8 + dataChunk.length + dataChunk.bytesPadding);

  @override
  String get sGroupId => _sGroupId;

  @override
  Stream<int> bytes() async* {
    var strBytes = ByteHelpers.toBytes(_sGroupId);
    var bytes = strBytes.buffer.asByteData();
    for (int i = 0; i < 4; i++) {
      yield bytes.getUint8(i);
    }

    var byteData = ByteData(4);
    byteData.setUint32(0, length, Endian.little);
    for (int i = 0; i < 4; i++) {
      yield byteData.getUint8(i);
    }

    strBytes = ByteHelpers.toBytes(_sRifType);
    bytes = strBytes.buffer.asByteData();
    for (int i = 0; i < 4; i++) {
      yield bytes.getUint8(i);
    }
  }
}
