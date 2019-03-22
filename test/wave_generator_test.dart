import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wave_generator/note.dart';

import 'package:wave_generator/wave_generator.dart';

void main() {
  test('single-tone', () async {

    var generator = WaveGenerator(44100, BitDepth.Depth8bit);

    var note = Note(220, 3000, Waveform.Triangle, 0.5);

    var file = new File('test_out.wav');

    List<int> bytes = List<int>();
    await for (int byte in generator.generate(note)) {
      bytes.add(byte);
    }

    file.writeAsBytes(bytes, mode: FileMode.append);
  });

  test('multi-tones', () async {

    var generator = WaveGenerator(44100, BitDepth.Depth8bit);

    int baseTime = 100;
    double freq = 440.0;

    int dotDuration = baseTime;
    int dashDuration = baseTime * 3;
    int symbolGap = baseTime;
    int letterGap = baseTime * 3;

    var interSymbolSilence = Note(freq, symbolGap, Waveform.Sine, 0.0);
    var interLetterSilence = Note(freq, letterGap, Waveform.Sine, 0.0);
    var dit = Note(freq, dotDuration, Waveform.Sine, 0.7);
    var dah = Note(freq, dashDuration, Waveform.Sine, 0.7);

    var notes = [
      dit,
      interSymbolSilence,
      dit,
      interSymbolSilence,
      dit,
      interLetterSilence,
      dah,
      interSymbolSilence,
      dah,
      interSymbolSilence,
      dah,
      interLetterSilence,
      dit,
      interSymbolSilence,
      dit,
      interSymbolSilence,
      dit,
      interLetterSilence,
    ];

    var file = new File('s-o-s.wav');

    List<int> bytes = List<int>();
    await for (int byte in generator.generateSequence(notes)) {
      bytes.add(byte);
    }

    file.writeAsBytes(bytes, mode: FileMode.append);
  });
}
