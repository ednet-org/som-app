DateTime addBusinessDays(DateTime start, int days) {
  var date = DateTime.utc(start.year, start.month, start.day);
  var added = 0;
  while (added < days) {
    date = date.add(const Duration(days: 1));
    if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
      added++;
    }
  }
  return date;
}

bool isAtLeastBusinessDaysInFuture(DateTime target, int days) {
  final now = DateTime.now().toUtc();
  final minDate = addBusinessDays(now, days);
  return target.isAfter(minDate) || target.isAtSameMomentAs(minDate);
}
