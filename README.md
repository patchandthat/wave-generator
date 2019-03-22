# wave_generator

A dart package to generate audio wave data on the fly.

## Usage

To use this plugin, add `wave_generator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
import 'package:wave_generator/wave_generator.dart';

() async {

    var generator = WaveGenerator(/* sample rate */ 44100, BitDepth.Depth8bit);

    var note = Note(/* frequency */ 220, /* msDuration */ 3000, /* waveform */ Waveform.Triangle, /* volume */ 0.5);

    var file = new File('test_out.wav');

    List<int> bytes = List<int>();
    await for (int byte in generator.generate(note)) {
      bytes.add(byte);
    }

    file.writeAsBytes(bytes, mode: FileMode.append);
  });
```

Or string together a sequence of tones

``` dart

 await for (int byte in generator.generateSequence([note1, note2, note3 /* etc */])) {
   bytes.add(byte);
 }

```

### Features

* Sin, Square, Triangle waves
* 8 Bit depth