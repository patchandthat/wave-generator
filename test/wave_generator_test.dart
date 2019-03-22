import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wave_generator/note.dart';

import 'package:wave_generator/wave_generator.dart';
import 'package:wave_generator/waveform.dart';

void main() {
  test('todo', () async {

    var generator = WaveGenerator(44100, BitDepth.Depth8bit);

    var note = Note(220, 5000, Waveform.Sine, 0.5);

    var file = new File('test_out.wav');

    List<int> bytes = List<int>();
    await for (int byte in generator.generate(note)) {
      bytes.add(byte);
    }

    file.writeAsBytes(bytes, mode: FileMode.append);
  });
}
