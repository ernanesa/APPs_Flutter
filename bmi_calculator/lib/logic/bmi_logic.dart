class BmiLogic {
  static double calculateBmi(double weight, double heightInput) {
    if (heightInput <= 0) return 0;
    // Heuristic: If height is less than 3.0, it's likely in meters.
    // Otherwise treat as centimeters.
    double heightM = heightInput < 3.0 ? heightInput : heightInput / 100;
    return weight / (heightM * heightM);
  }

  static String getCategoryKey(double bmi) {
    if (bmi < 18.5) return 'underweight';
    if (bmi < 25) return 'normal';
    if (bmi < 30) return 'overweight';
    if (bmi < 35) return 'obesity1';
    if (bmi < 40) return 'obesity2';
    return 'obesity3';
  }
}
