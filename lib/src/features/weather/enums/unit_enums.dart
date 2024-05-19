enum Unit { metric, imperial }

String getUnitName(Unit unit) {
  switch (unit) {
    case Unit.metric:
      return 'Metric';
    case Unit.imperial:
      return 'Imperial';
    default:
      return '';
  }
}

String getTemperatureUnitSymbol(Unit unit) {
  switch (unit) {
    case Unit.metric:
      return 'C';
    case Unit.imperial:
      return 'F';
    default:
      return '';
  }
}
