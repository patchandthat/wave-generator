library wave_generator;

import 'src/chunk.dart';
import 'src/data_chunk8.dart';
import 'src/format_chunk.dart';
import 'src/wave_header.dart';

/// Bit-depth per sample.
enum BitDepth {
  Depth8bit,
//  Depth16bit,
//  Depth32bit
}

/// Waveform for a tone.
enum Waveform {
  Sine,
  Square,
  Triangle,
}

/// Represents a single tone.
class Note {

  /// Frequency in Hz.
  final double frequency;

  /// Duration in milliseconds.
  final int msDuration;

  /// Waveform of the tone.
  final Waveform waveform;

  /// Volume in the range 0.0 - 1.0.
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

// Etc, do more
// http://pages.mtu.edu/~suits/notefreqs.html
}

/// Generates simple waveforms as uncompressed PCM audio data.
class WaveGenerator
{
  /// Samples generated per second.
  final int sampleRate;

  /// Bit-depth of each audio sample.
  final BitDepth bitDepth;

  factory WaveGenerator.simple() {
    return WaveGenerator(44100, BitDepth.Depth8bit);
  }

  WaveGenerator(this.sampleRate, this.bitDepth);

  /// Generate a byte stream equivalent to a wav file of the Note argument
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

  /// Generate a byte stream equivalent to a wav file of the Note list argument, played sequentially
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
