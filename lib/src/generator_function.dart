import 'dart:math';

import 'package:wave_generator/note.dart';

abstract class GeneratorFunction {
 double generate(double theta);

 static GeneratorFunction create(Waveform type) {
   switch(type) {
     case Waveform.Sine:
       return SinGenerator();
     case Waveform.Triangle:
       return TriangleGenerator();
     case Waveform.Square:
       return SquareGenerator();
   }

   throw ArgumentError("Unknown waveform value");
 }
}

class SinGenerator implements GeneratorFunction {
  @override
  double generate(double theta) {
    return sin(theta);
  }
}

class SquareGenerator implements GeneratorFunction {
  @override
  double generate(double theta) {
    return sin(theta) > 0 ? 1.0 : -1.0;
  }
}

class TriangleGenerator implements GeneratorFunction {
  @override
  double generate(double theta) {
    return theta % (2 * pi);
  }
}