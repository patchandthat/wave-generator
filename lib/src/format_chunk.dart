import 'dart:typed_data';

import 'package:wave_generator/src/byte_helpers.dart';
import 'package:wave_generator/src/chunk.dart';

import '../wave_generator.dart';

class FormatChunk implements Chunk {
  final int BITS_PER_BYTE = 8;

  final String _sGroupId = "fmt ";
  int _dwChunkSize = 16;
  final int _wFormatTag = 1;
  final int _wChannels;
  final int _dwSamplesPerSecond;
  int _dwAverageBytesPerSecond;
  int _wBlockAlign;
  int _wBitsPerSample;

  FormatChunk(
      this._wChannels, this._dwSamplesPerSecond, BitDepth bitsPerSample) {
    switch (bitsPerSample) {
      case BitDepth.Depth8bit:
        _wBitsPerSample = 8;
        break;
//      case BitDepth.Depth16bit:
//        _wBitsPerSample = 16;
//        break;
//      case BitDepth.Depth32bit:
//        _wBitsPerSample = 32;
//        break;
    }

    _wBlockAlign = _wChannels * (_wBitsPerSample ~/ BITS_PER_BYTE);
    _dwAverageBytesPerSecond = _wBlockAlign * _dwSamplesPerSecond;
  }

  @override
  int get length => _dwChunkSize;

  int get sampleRate => _dwSamplesPerSecond;

  int get blockAlign => _wBlockAlign;

  int get bytesPerSecond => _dwAverageBytesPerSecond;

  int get bitDepth => _wBitsPerSample;

  @override
  String get sGroupId => _sGroupId;

  @override
  Stream<int> bytes() async* {
    // sGroupId
    var groupIdBytes = ByteHelpers.toBytes(_sGroupId);
    var bytes = groupIdBytes.buffer.asByteData();

    for (int i = 0; i < 4; i++) yield bytes.getUint8(i);

    // chunkLength
    var byteData = ByteData(4);
    byteData.setUint32(0, length, Endian.little);
    for (int i = 0; i < 4; i++) yield byteData.getUint8(i);

    // Audio format
    byteData = ByteData(2);
    byteData.setUint16(0, _wFormatTag, Endian.little);
    for (int i = 0; i < 2; i++) yield byteData.getUint8(i);

    // Num channels
    byteData = ByteData(2);
    byteData.setUint16(0, _wChannels, Endian.little);
    for (int i = 0; i < 2; i++) yield byteData.getUint8(i);

    // Sample rate
    byteData = ByteData(4);
    byteData.setUint32(0, _dwSamplesPerSecond, Endian.little);
    for (int i = 0; i < 4; i++) yield byteData.getUint8(i);

    // Byte rate
    byteData = ByteData(4);
    byteData.setUint32(0, _dwAverageBytesPerSecond, Endian.little);
    for (int i = 0; i < 4; i++) yield byteData.getUint8(i);

    // Block align
    byteData = ByteData(2);
    byteData.setUint16(0, _wBlockAlign, Endian.little);
    for (int i = 0; i < 2; i++) yield byteData.getUint8(i);

    // Bits per sample
    byteData = ByteData(2);
    byteData.setUint16(0, _wBitsPerSample, Endian.little);
    for (int i = 0; i < 2; i++) yield byteData.getUint8(i);
  }
}
