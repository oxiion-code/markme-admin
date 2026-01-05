extension MinuteFormatter on int {
  String formatTime() {
    final hour24 = this ~/ 60;
    final minute = this % 60;

    final period = hour24 < 12 ? 'AM' : 'PM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }
}
