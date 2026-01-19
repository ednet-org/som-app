/// Taxonomy name normalization shared across ETL scripts.
library;

String normalizeTaxonomyName(String value) {
  var normalized = value.toLowerCase().trim();
  normalized = _foldDiacritics(normalized);
  normalized = normalized
      .replaceAll('&', ' and ')
      .replaceAll(RegExp(r'\bund\b'), ' and ')
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return normalized;
}

String normalizeTaxonomyNameLoose(String value) {
  var normalized = normalizeTaxonomyName(value);
  normalized = normalized
      .replaceAll('ae', 'a')
      .replaceAll('oe', 'o')
      .replaceAll('ue', 'u');
  return normalized;
}

String _foldDiacritics(String value) {
  var folded = value;
  folded = folded
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .replaceAll('æ', 'ae')
      .replaceAll('œ', 'oe');
  folded = folded
      .replaceAll(RegExp(r'[áàâãåāăą]'), 'a')
      .replaceAll(RegExp(r'[çćč]'), 'c')
      .replaceAll(RegExp(r'[ďđ]'), 'd')
      .replaceAll(RegExp(r'[éèêëēĕėęě]'), 'e')
      .replaceAll(RegExp(r'[íìîïīĭįı]'), 'i')
      .replaceAll(RegExp(r'[ñńň]'), 'n')
      .replaceAll(RegExp(r'[óòôõøōŏő]'), 'o')
      .replaceAll(RegExp(r'[śšşș]'), 's')
      .replaceAll(RegExp(r'[ťț]'), 't')
      .replaceAll(RegExp(r'[úùûüūŭůűų]'), 'u')
      .replaceAll(RegExp(r'[ýÿŷ]'), 'y')
      .replaceAll(RegExp(r'[žźż]'), 'z');
  return folded;
}
