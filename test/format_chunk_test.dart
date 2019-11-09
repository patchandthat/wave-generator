import 'package:test/test.dart';
import 'package:wave_generator/src/format_chunk.dart';
import 'package:wave_generator/wave_generator.dart';

void main() {
  group('format chunk', () {
    test('sGroupId should be "fmt "', () {
      var sut = CreateSut();

      expect(sut.sGroupId, 'fmt ');
    });

    test('first bytes should be "fmt " big endian', () async {
      var sut = CreateSut();

      int count = 0;
      var expectedFirstBytes = [0x66, 0x6D, 0x74, 0x20];
      await for (int byte in sut.bytes()) {
        expect(byte, expectedFirstBytes[count],
            reason:
                "byte ${count} should be ${expectedFirstBytes[count]} but was ${byte}");
        count += 1;
        if (count > 3) break;
      }
    });

    test('PCM data length should be 16 bytes', () {
      var sut = CreateSut();

      expect(sut.length, 16);
    });

    test('PCM data length bytes should be 16 little endian', () async {
      var sut = CreateSut();

      int count = -1;
      var expectedBytes = [0x10, 0x00, 0x00, 0x00]; // 16
      await for (int byte in sut.bytes()) {
        count++;
        if (count < 4) continue;
        if (count >= 8) break;

        expect(byte, expectedBytes[count - 4],
            reason:
                "byte ${count} should be ${expectedBytes[count - 4]} but was ${byte}");
      }
      expect(count, greaterThanOrEqualTo(7),
          reason: "Not enough bytes returned");
    });

    test('Audio format bytes should be 1 (PCM)', () async {
      var sut = CreateSut();

      int expectMinimumBytes = 10;
      // array of [index, byteValue]
      var expectedBytes = [
        [8, 0x01],
        [9, 0x00]
      ];

      int currentByte = 0;

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

    test('Num channels bytes should be 1', () async {
      var sut = CreateSut();

      int expectMinimumBytes = 12;
      // array of [index, byteValue]
      var expectedBytes = [
        [10, 0x01],
        [11, 0x00]
      ];

      int currentByte = 0;

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

    test('Num channels bytes should be correct', () async {
      var sut = CreateSut(channels: 300);

      int expectMinimumBytes = 12;
      // array of [index, byteValue]
      var expectedBytes = [
        [10, 0x2C],
        [11, 0x01]
      ];

      int currentByte = 0;

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

    test('default sample rate should be 44100', () async {
      var sut = CreateSut();

      int expectMinimumBytes = 16;
      // array of [index, byteValue]
      var expectedBytes = [
        [12, 0x44],
        [13, 0xAC],
        [14, 0x00],
        [15, 0x00]
      ];

      int currentByte = 0;

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

    test('when sample rate is not default, sample rate bytes should be correct',
        () async {
      var sut = CreateSut(sampleRate: 196000);

      int expectMinimumBytes = 16;
      // array of [index, byteValue]
      var expectedBytes = [
        [12, 0xA0],
        [13, 0xFD],
        [14, 0x02],
        [15, 0x00]
      ];

      int currentByte = 0;

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
        'byte rate should be 4 byte little endian equal to sample rate * channels * bytes per sample',
        () async {
      var sut = CreateSut(
          sampleRate: 44100,
          channels: 2,
          depth: BitDepth.Depth8bit); //BitDepth.Depth16bit

      int expectedValue = (44100 * 2 * (16 / 8)).toInt();

      int expectMinimumBytes = 20;
      // array of [index, byteValue]
      var expectedBytes = [
        [16, 0x10],
        [17, 0xB1],
        [18, 0x02],
        [19, 0x00]
      ];

      int currentByte = 0;

      expect(sut.bytesPerSecond, expectedValue,
          reason: 'Byte rate is incorrect');

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
        'Block align should be 2 bytes little endian equal to channels * bytes per sample, ie. frame size',
        () async {
      var sut =
          CreateSut(sampleRate: 44100, channels: 5, depth: BitDepth.Depth8bit);

      int expectedValue = (5 * (8 / 8)).toInt();

      int expectMinimumBytes = 22;
      // array of [index, byteValue]
      var expectedBytes = [
        [20, 0x05],
        [21, 0x00]
      ];

      int currentByte = 0;

      expect(sut.blockAlign, expectedValue, reason: 'Block align is incorrect');

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

    test('bits per sample should be set correctly', () async {
      var sut = CreateSut(
          sampleRate: 44100,
          channels: 2,
          depth: BitDepth.Depth8bit); //BitDepth.Depth16bit

      int expectedValue = 16;

      int expectMinimumBytes = 24;
      // array of [index, byteValue]
      var expectedBytes = [
        [22, 0x10],
        [23, 0x00]
      ];

      int currentByte = 0;

      expect(sut.bitDepth, expectedValue,
          reason: 'Bits per sample is incorrect');

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
  });
}

FormatChunk CreateSut(
    {int channels = 1,
    int sampleRate = 44100,
    BitDepth depth = BitDepth.Depth8bit}) //BitDepth.Depth16bit
{
  return FormatChunk(channels, sampleRate, depth);
}
