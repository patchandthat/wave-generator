import 'dart:math';

abstract class GeneratorFunction {
 double generate(double theta);
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
    // TODO: implement generate
    return null;
  }
}

class TriangleGenerator implements GeneratorFunction {
  @override
  double generate(double theta) {
    // TODO: implement generate
    return null;
  }
}

class SawtoothGenerator implements GeneratorFunction {
  @override
  double generate(double theta) {
    // TODO: implement generate
    return null;
  }
}