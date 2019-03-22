import 'dart:typed_data';

import 'package:wave_generator/src/byte_helpers.dart';
import 'package:wave_generator/src/chunk.dart';
import 'package:wave_generator/src/format_chunk.dart';

class WaveHeader implements Chunk {

  String _sGroupId = "RIFF";
  String _sRifType = "WAVE";

  final FormatChunk _formatChunk;
  final DataChunk _dataChunk;

  WaveHeader(this._formatChunk, this._dataChunk);

  @override
  int get length => 4 + (8 + _formatChunk.length) + (8 + _dataChunk.length + _dataChunk.bytesPadding);

  @override
  String get sGroupId => _sGroupId;

  @override
  Stream<int> bytes() async* {

    var strBytes = ByteHelpers.toBytes(_sGroupId);
    var bytes = strBytes.buffer.asByteData();
    for (int i = 0; i < 4; i++)
      yield bytes.getUint8(i);

    var byteData = ByteData(4);
    byteData.setUint32(0, length, Endian.little);
    for (int i = 0; i < 4; i++)
      yield byteData.getUint8(i);

    strBytes = ByteHelpers.toBytes(_sRifType);
    bytes = strBytes.buffer.asByteData();
    for (int i = 0; i < 4; i++)
      yield bytes.getUint8(i);

  }
}