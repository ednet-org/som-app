String normalizeName(String value) {
  final cleaned = value
      .toLowerCase()
      .replaceAll(RegExp(r'[,_]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return cleaned;
}
