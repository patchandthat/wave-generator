import 'package:test/test.dart';
import 'package:wave_generator/src/chunk.dart';
import 'package:wave_generator/src/data_chunk8.dart';
import 'package:wave_generator/src/format_chunk.dart';

import 'package:wave_generator/wave_generator.dart';

void main() {
  group('8 bit data chunk', () {
    test('first bytes should be chunk Id "data" big endian', () async {
      var sut = createSut();

      var expectedValue = 'data';

      int expectMinimumBytes = 4;
      // array of [index, byteValue]
      var expectedBytes = [
        [00, 0x64],
        [01, 0x61],
        [02, 0x74],
        [03, 0x61]
      ];

      int currentByte = 0;

      expect(sut.sGroupId, expectedValue, reason: 'block id is incorrect');

      await for (int byte in sut.bytes()) {
        for (List<int> expectedByte in expectedBytes) {
          if (currentByte == expectedByte[0]) {
            expect(byte, expectedByte[1],
                reason:
                    'Byte at index ${currentByte} incorrect. ${byte} instead of ${expectedByte[1]}');
          }
        }

        currentByte++;
      }

      expect(currentByte, greaterThanOrEqualTo(expectMinimumBytes),
          reason: 'Not enough bytes returned');
    });

    test(
        'data length bytes should be inferred from format and combined note durations',
        () async {
      int sampleRate = 44100;
      int bytesPerSample = 1;
      int channels = 1;
      int millisecondsDuration = 100;

      // = total samples * bytes per sample
      // = duration * samples per sec * bytes per sample
      int expectedDataLengthBytes =
          (sampleRate * (millisecondsDuration / 1000)).toInt() *
              channels *
              bytesPerSample;

      var format = FormatChunk(channels, sampleRate, BitDepth.Depth8bit);
      var notes = [Note.a4(millisecondsDuration, 1)];
      var sut = createSut(format: format, notes: notes);

      var expectedValue = expectedDataLengthBytes;

      int expectMinimumBytes = 8;
      // array of [index, byteValue]
      var expectedBytes = [
        [04, 0x3A],
        [05, 0x11],
        [06, 0x00],
        [07, 0x00]
      ];

      int currentByte = 0;

      expect(sut.length, expectedValue, reason: 'block id is incorrect');

      await for (int byte in sut.bytes()) {
        for (List<int> expectedByte in expectedBytes) {
          if (currentByte == expectedByte[0]) {
            expect(byte, expectedByte[1],
                reason:
                    'Byte at index ${currentByte} incorrect. ${byte} instead of ${expectedByte[1]}');
          }
        }

        currentByte++;
      }

      expect(currentByte, greaterThanOrEqualTo(expectMinimumBytes),
          reason: 'Not enough bytes returned');
    });

    // test('todo', () async {
    //   fail('test for simple waveform data');
    // });
  });
}

DataChunk createSut({
  FormatChunk? format,
  List<Note>? notes,
}) {
  return DataChunk8(
    format ??= FormatChunk(1, 44100, BitDepth.Depth8bit),
    notes ??= [Note.a4(100, 1)],
  );
}
