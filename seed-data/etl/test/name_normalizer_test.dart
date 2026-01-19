import 'package:etl/utils/name_normalizer.dart';
import 'package:test/test.dart';

void main() {
  test('normalizeTaxonomyName folds diacritics and symbols', () {
    expect(
      normalizeTaxonomyName('Bäckerei & Konditorei'),
      'baeckerei and konditorei',
    );
    expect(
      normalizeTaxonomyName('Bäckerei und Konditorei'),
      'baeckerei and konditorei',
    );
    expect(
      normalizeTaxonomyName('Müller, GmbH'),
      'mueller gmbh',
    );
    expect(
      normalizeTaxonomyName('ÄÖÜ ß'),
      'aeoeue ss',
    );
  });

  test('normalizeTaxonomyNameLoose collapses ae/oe/ue variants', () {
    expect(
      normalizeTaxonomyNameLoose('Baeckerei'),
      'backerei',
    );
    expect(
      normalizeTaxonomyNameLoose('Bäckerei'),
      'backerei',
    );
  });
}
