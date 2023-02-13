Duration? getDurationFromSeconds(double? seconds) {
  if (seconds != null) {
    int hours = (seconds / 3600).floor();
    seconds %= 3600;

    int minutes = (seconds / 60).floor();
    seconds %= 60;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds.floor(),
    );
  }

  return null;
}
