import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  double p = 0.017453292519943295;
  double Function(num radians) c = cos;
  double a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
