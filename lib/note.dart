
import 'package:wave_generator/waveform.dart';

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