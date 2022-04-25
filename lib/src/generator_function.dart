import 'dart:math';

import '../wave_generator.dart';

abstract class GeneratorFunction {
  double generate(double theta);

  static GeneratorFunction create(Waveform type) {
    switch (type) {
      case Waveform.sine:
        return SinGenerator();
      case Waveform.triangle:
        return TriangleGenerator();
      case Waveform.square:
        return SquareGenerator();
    }
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
