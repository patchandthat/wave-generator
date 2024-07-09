import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wave_generator/wave_generator.dart';

void main() {
  test('single-tone', () async {
    var generator = WaveGenerator(/* sample rate */ 44100, BitDepth.depth8Bit);

    var note = Note(/* frequency */ 220, /* msDuration */ 3000,
        /* waveform */ Waveform.triangle, /* volume */ 0.5);

    var file = File('test_out.wav');

    List<int> bytes = [];
    await for (int byte in generator.generate(note)) {
      bytes.add(byte);
    }

    file.writeAsBytes(bytes, mode: FileMode.append);
  });

  test('multi-tones', () async {
    var generator = WaveGenerator(44100, BitDepth.depth8Bit);

    int baseTime = 100;
    double freq = 440.0;

    int dotDuration = baseTime;
    int dashDuration = baseTime * 3;
    int symbolGap = baseTime;
    int letterGap = baseTime * 3;

    var interSymbolSilence = Note(freq, symbolGap, Waveform.sine, 0.0);
    var interLetterSilence = Note(freq, letterGap, Waveform.sine, 0.0);
    var dit = Note(freq, dotDuration, Waveform.sine, 0.7);
    var dah = Note(freq, dashDuration, Waveform.sine, 0.7);

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

    var file = File('s-o-s.wav');

    List<int> bytes = [];
    await for (int byte in generator.generateSequence(notes)) {
      bytes.add(byte);
    }

    file.writeAsBytes(bytes, mode: FileMode.append);
  });
}
