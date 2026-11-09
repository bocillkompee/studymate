const _monthNames = <String>[
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const _shortMonthNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

const _dayNames = <String>[
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

String formatDate(DateTime date) {
  return '${date.day} ${_shortMonthNames[date.month - 1]} ${date.year}';
}

String formatFullDate(DateTime date) {
  final dayName = _dayNames[date.weekday - 1];
  return '$dayName, ${date.day} ${_monthNames[date.month - 1]} ${date.year}';
}

String greetingFor(DateTime time) {
  final hour = time.hour;
  if (hour < 11) {
    return 'Selamat pagi';
  }
  if (hour < 15) {
    return 'Selamat siang';
  }
  if (hour < 18) {
    return 'Selamat sore';
  }
  return 'Selamat malam';
}

String relativeDeadline(DateTime deadline, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());
  final dueDate = _dateOnly(deadline);
  final difference = dueDate.difference(today).inDays;

  if (difference < 0) {
    return 'Terlambat ${difference.abs()} hari';
  }
  if (difference == 0) {
    return 'Hari ini';
  }
  if (difference == 1) {
    return 'Besok';
  }
  return '$difference hari lagi';
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
