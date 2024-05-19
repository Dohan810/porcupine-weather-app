enum ForecastRange { daily, threeHourly }

String getForecastRangeName(ForecastRange range) {
  switch (range) {
    case ForecastRange.daily:
      return 'Daily';
    case ForecastRange.threeHourly:
      return '3 hourly';
    default:
      return '';
  }
}
