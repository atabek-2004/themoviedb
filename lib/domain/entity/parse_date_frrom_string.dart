DateTime? parseDateFrromString(String? rawdate) {
    if (rawdate == null || rawdate.isEmpty) return null;
    return DateTime.tryParse(rawdate);
  }