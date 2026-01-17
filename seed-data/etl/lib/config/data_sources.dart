/// Configuration for data sources used in the ETL pipeline.
library;

/// Data source configuration for OSM.
class OsmDataSource {
  static const String id = 'osm-geofabrik-austria';
  static const String name = 'OpenStreetMap Austria (Geofabrik)';
  static const String url =
      'https://download.geofabrik.de/europe/austria-latest.osm.pbf';
  static const String license = 'ODbL-1.0';
  static const String licenseUrl =
      'https://opendatacommons.org/licenses/odbl/1-0/';
  static const String attribution =
      '© OpenStreetMap contributors, licensed under ODbL';
}

/// Data source configuration for Firmenbuch.
class FirmenbuchDataSource {
  static const String id = 'firmenbuch-hvd-austria';
  static const String name = 'Austrian Firmenbuch High Value Dataset';
  static const String url =
      'https://data.gv.at/katalog/dataset/justiz-gv-at-firmenbuch';
  static const String license = 'CC-BY-4.0';
  static const String licenseUrl =
      'https://creativecommons.org/licenses/by/4.0/';
  static const String attribution =
      'Datenquelle: data.gv.at, Bundesministerium für Justiz';
}

/// Data source configuration for WKO Firmen A-Z.
class WkoDataSource {
  static const String id = 'wko-firmen-az-austria';
  static const String name = 'WKO Firmen A-Z Austria';
  static const String url = 'https://firmen.wko.at';
  static const String license = 'Public';
  static const String licenseUrl = 'https://firmen.wko.at/impressum';
  static const String attribution =
      'Wirtschaftskammer Österreich - Firmen A-Z Verzeichnis';
}

/// Common paths used in the ETL pipeline.
class EtlPaths {
  static const String outputDir = 'out';
  static const String rawDir = 'raw';
  static const String mappingsDir = 'mappings';
  static const String manifestFile = 'manifest.json';
  static const String reportFile = 'report.md';
}

/// Quality gates and limits.
class QualityLimits {
  /// Austrian latitude bounds.
  static const double minLat = 46.3;
  static const double maxLat = 49.0;

  /// Austrian longitude bounds.
  static const double minLon = 9.5;
  static const double maxLon = 17.2;

  /// Austrian postcode pattern (4 digits).
  static final RegExp postcodePattern = RegExp(r'^[0-9]{4}$');

  /// Firmenbuchnummer pattern.
  static final RegExp firmenbuchPattern = RegExp(r'^FN [0-9]+[a-z]$');

  /// UID number pattern.
  static final RegExp uidPattern = RegExp(r'^ATU[0-9]{8}$');

  /// Fuzzy match threshold for name similarity (Levenshtein).
  static const int maxLevenshteinDistance = 3;

  /// Token overlap threshold for fuzzy matching.
  static const double minTokenOverlap = 0.7;

  /// Geo proximity threshold in meters.
  static const double geoProximityMeters = 50.0;
}

/// OSM tags to filter for business POIs.
class OsmBusinessTags {
  static const List<String> tagKeys = [
    'shop',
    'amenity',
    'office',
    'craft',
    'tourism',
    'industrial',
  ];

  static const Map<String, List<String>> specificTags = {
    'man_made': ['works'],
  };
}
