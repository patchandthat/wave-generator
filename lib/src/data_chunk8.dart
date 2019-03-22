import 'dart:typed_data';
import 'dart:math';

import 'package:wave_generator/note.dart';
import 'package:wave_generator/src/byte_helpers.dart';
import 'package:wave_generator/src/chunk.dart';
import 'package:wave_generator/src/format_chunk.dart';
import 'package:wave_generator/src/generator_function.dart';

class DataChunk8 implements DataChunk {

  final FormatChunk format;
  final List<Note> notes;

  final String _sGroupId = "data";

  int _dwChunkSize;
  Uint8List _data;

  // nb. Stored as unsigned bytes in the rage 0 to 255
  static const int min = 0;
  static const int max = 255;

  int clamp(int byte)
  {
    return byte.clamp(min, max);
  }

  DataChunk8(this.format, this.notes);

  @override
  Stream<int> bytes() async* {

    // sGroupId
    var groupIdBytes = ByteHelpers.toBytes(_sGroupId);
    var bytes = groupIdBytes.buffer.asByteData();

    for (int i = 0; i < 4; i++)
      yield bytes.getUint8(i);

    // length
    var byteData = ByteData(4);
    byteData.setUint32(0, length, Endian.little);
    for (int i = 0; i < 4; i++)
      yield byteData.getUint8(i);

    // Todo: Extract Factory+Strategy pattern
    GeneratorFunction generator = new SinGenerator();

    // Todo: something wrong in here. Calling toDouble on a null value
    // Ensure bytes returned are equal to the expected length
    int sampleMax = totalSamples;
    double theta = notes[0].frequency * (2 * pi) / format.sampleRate;
    var amplify = (max + 1) / 2;
    for (int step = 0; step < sampleMax; step++) {
      var y = generator.generate(theta * step);
      double volume = (amplify * notes[0].volume);
      double sample = (volume * y) + volume;
      int intSampleVal = sample.toInt();
      int sampleByte = clamp(intSampleVal);
      yield sampleByte;
    }

    // Todo: Caveat - if the number of bytes is not word-aligned, ie. number of bytes is odd, we need to pad with additional zero bytes.
    // These zero bytes should not appear in the data chunk length header
    // but probably do get included for the length bytes in the file header
    if (length % 2 != 0)
      yield 0x00;
  }

  @override
  int get length {
    return totalSamples * format.blockAlign;
  }

  int get totalSamples {
    double secondsDuration = (notes.map((note) => note.msDuration).reduce((a, b) => a+b) / 1000);
    return (format.sampleRate * secondsDuration).toInt();
  }

  @override
  String get sGroupId => _sGroupId;

  @override
  // TODO: implement bytesPadding
  int get bytesPadding => length % 2 == 0 ? 0 : 1;
}

