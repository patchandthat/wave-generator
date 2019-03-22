library wave_generator;

import 'dart:typed_data';

import 'package:wave_generator/src/chunk.dart';
import 'package:wave_generator/src/data_chunk8.dart';
import 'package:wave_generator/src/format_chunk.dart';
import 'package:wave_generator/src/wave_header.dart';

enum BitDepth {
  Depth8bit,
//  Depth16bit,
//  Depth32bit
}

enum Waveform {
  Sine,
  Square,
  Triangle,
}

class Note {
  final double frequency;
  final int msDuration;
  final Waveform waveform;
  final double volume;

  Note(this.frequency, this.msDuration, this.waveform, this.volume){
    if (volume < 0.0 || volume > 1.0) throw ArgumentError("Volume should be between 0.0 and 1.0");
    if (frequency < 0.0) throw ArgumentError("Frequency cannot be less than zero");
    if (msDuration < 0.0) throw ArgumentError("Duration cannot be less than zero");
  }

  factory Note.silent(int duration) {
    return Note(1.0, duration, Waveform.Sine, 0.0);
  }

  factory Note.a4(int duration, double volume) {
    return Note(440.0, duration, Waveform.Sine, volume);
  }

// Etc
// http://pages.mtu.edu/~suits/notefreqs.html
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

  Stream<int> generateSequence(List<Note> notes) async* {
    var formatHeader = FormatChunk(1, sampleRate, bitDepth);

    var dataChunk = _getDataChunk(formatHeader, notes );

    var fileHeader = WaveHeader(formatHeader, dataChunk);

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

  DataChunk _getDataChunk(FormatChunk format, List<Note> notes) {
    switch (this.bitDepth) {
      case BitDepth.Depth8bit:
        return DataChunk8(format, notes);
      default:
        throw UnimplementedError("todo");
    }
  }
}