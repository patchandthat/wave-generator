library wave_generator;

import 'dart:typed_data';

import 'package:wave_generator/note.dart';
import 'package:wave_generator/src/chunk.dart';
import 'package:wave_generator/src/data_chunk8.dart';
import 'package:wave_generator/src/format_chunk.dart';
import 'package:wave_generator/src/wave_header.dart';

// See https://stackoverflow.com/a/19772815/2000111

enum BitDepth {
  Depth8bit,
  Depth16bit,
  Depth32bit
}

class WaveGenerator
{
  final int sampleRate;
  final BitDepth bitDepth;

  factory WaveGenerator.simple() {
    return WaveGenerator(44100, BitDepth.Depth8bit);
  }

  WaveGenerator(this.sampleRate, this.bitDepth);

  Stream<int> generate(Note note) async* {

    var formatHeader = FormatChunk(1, sampleRate, bitDepth);
    
    var dataChunk = _getDataChunk(formatHeader, [note] );

    var fileHeader = WaveHeader(formatHeader, dataChunk);

    // Option A
//    yield* fileHeader.bytes();
//    yield* formatHeader.bytes();
//    yield* dataChunk.bytes();

    // Option B
    await for (int data in fileHeader.bytes()) {
      yield data;
    }

    await for (int data in formatHeader.bytes()) {
      yield data;
    }

    await for (int data in dataChunk.bytes()) {
      yield data;
    }
  }

  Stream<Uint8List> generateSequence(List<Note> notes) async* {
    yield null;
  }

  DataChunk _getDataChunk(FormatChunk format, List<Note> notes) {
    switch (this.bitDepth) {
      case BitDepth.Depth8bit:
        return DataChunk8(format, notes);
      default:
        throw UnimplementedError("todo");
    }
  }
}