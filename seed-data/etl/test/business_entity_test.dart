import 'package:test/test.dart';

import 'package:etl/models/business_entity.dart';
import 'package:etl/transformers/phone_normalizer.dart';
import 'package:etl/transformers/address_parser.dart';
import 'package:etl/transformers/pii_filter.dart';

void main() {
  group('BusinessEntity', () {
    test('generates deterministic ID', () {
      final entity1 = BusinessEntity(
        name: 'Test GmbH',
        addresses: [
          Address(postcode: '1010', street: 'Testgasse', houseNumber: '1'),
        ],
        provenance: [
          Provenance(sourceId: 'test'),
        ],
      );

      final entity2 = BusinessEntity(
        name: 'Test GmbH',
        addresses: [
          Address(postcode: '1010', street: 'Testgasse', houseNumber: '1'),
        ],
        provenance: [
          Provenance(sourceId: 'test'),
        ],
      );

      expect(entity1.id, equals(entity2.id));
      expect(entity1.id, startsWith('AT-'));
    });

    test('serializes to JSON', () {
      final entity = BusinessEntity(
        name: 'Test GmbH',
        providerType: ProviderType.haendler,
        addresses: [
          Address(
            postcode: '1010',
            city: 'Wien',
            street: 'Testgasse',
            houseNumber: '1',
          ),
        ],
        provenance: [
          Provenance(
            sourceId: 'test',
            sourceName: 'Test Source',
          ),
        ],
      );

      final json = entity.toJson();

      expect(json['name'], equals('Test GmbH'));
      expect(json['country'], equals('AT'));
      expect(json['providerType'], equals('HAENDLER'));
      expect(json['addresses'], isA<List>());
      expect(json['provenance'], isA<List>());
    });

    test('deserializes from JSON', () {
      final json = {
        'id': 'AT-abc123',
        'name': 'Test GmbH',
        'country': 'AT',
        'providerType': 'HAENDLER',
        'companySize': 'E0_10',
        'addresses': [
          {
            'country': 'AT',
            'postcode': '1010',
            'city': 'Wien',
          }
        ],
        'provenance': [
          {'sourceId': 'test'}
        ],
      };

      final entity = BusinessEntity.fromJson(json);

      expect(entity.name, equals('Test GmbH'));
      expect(entity.providerType, equals(ProviderType.haendler));
      expect(entity.companySize, equals(CompanySize.e0_10));
    });

    test('merges entities preserving provenance', () {
      final entity1 = BusinessEntity(
        name: 'Test GmbH',
        providerType: ProviderType.haendler,
        addresses: [Address(postcode: '1010')],
        provenance: [Provenance(sourceId: 'osm')],
      );

      final entity2 = BusinessEntity(
        name: 'Test GmbH',
        legalForm: 'GmbH',
        addresses: [Address(postcode: '1010')],
        provenance: [Provenance(sourceId: 'firmenbuch')],
        externalIds: ExternalIds(firmenbuchNr: 'FN 123456a'),
      );

      final merged = entity1.merge(entity2);

      expect(merged.legalForm, equals('GmbH'));
      expect(merged.provenance.length, equals(2));
      expect(merged.externalIds.firmenbuchNr, equals('FN 123456a'));
    });
  });

  group('PhoneNormalizer', () {
    test('normalizes Austrian phone numbers', () {
      expect(PhoneNormalizer.normalize('+43 1 234 567'), equals('+431234567'));
      expect(PhoneNormalizer.normalize('0043 1 234 567'), equals('+431234567'));
      expect(PhoneNormalizer.normalize('01 234 567'), equals('+431234567'));
      expect(PhoneNormalizer.normalize('0664 123 45 67'), equals('+436641234567'));
    });

    test('detects mobile numbers', () {
      expect(PhoneNormalizer.isMobile('+436641234567'), isTrue);
      expect(PhoneNormalizer.isMobile('+4312345678'), isFalse);
    });

    test('rejects invalid numbers', () {
      expect(PhoneNormalizer.normalize('123'), isNull);
      expect(PhoneNormalizer.normalize(''), isNull);
      expect(PhoneNormalizer.normalize(null), isNull);
    });
  });

  group('AddressParser', () {
    test('parses OSM address tags', () {
      final tags = {
        'addr:street': 'Testgasse',
        'addr:housenumber': '1a',
        'addr:postcode': '1010',
        'addr:city': 'Wien',
      };

      final address = AddressParser.fromOsmTags(tags);

      expect(address.street, equals('Testgasse'));
      expect(address.houseNumber, equals('1a'));
      expect(address.postcode, equals('1010'));
      expect(address.city, equals('Wien'));
      expect(address.bundesland, equals(Bundesland.wien));
    });

    test('validates Austrian coordinates', () {
      expect(AddressParser.isInAustria(48.2082, 16.3738), isTrue); // Vienna
      expect(AddressParser.isInAustria(47.0707, 15.4395), isTrue); // Graz
      expect(AddressParser.isInAustria(52.52, 13.405), isFalse); // Berlin
      expect(AddressParser.isInAustria(45.0, 10.0), isFalse); // Outside
    });

    test('validates postcodes', () {
      expect(AddressParser.isValidPostcode('1010'), isTrue);
      expect(AddressParser.isValidPostcode('9999'), isTrue);
      expect(AddressParser.isValidPostcode('0123'), isFalse); // Leading zero
      expect(AddressParser.isValidPostcode('123'), isFalse); // Too short
      expect(AddressParser.isValidPostcode('12345'), isFalse); // Too long
    });
  });

  group('PiiFilter', () {
    test('allows generic business emails', () {
      expect(PiiFilter.filterEmail('info@example.at').allowed, isTrue);
      expect(PiiFilter.filterEmail('office@example.at').allowed, isTrue);
      expect(PiiFilter.filterEmail('kontakt@example.at').allowed, isTrue);
      expect(PiiFilter.filterEmail('sales@example.at').allowed, isTrue);
    });

    test('filters personal emails', () {
      expect(PiiFilter.filterEmail('max.mustermann@example.at').allowed, isFalse);
      expect(PiiFilter.filterEmail('m.mustermann@example.at').allowed, isFalse);
    });

    test('filters no-reply emails', () {
      expect(PiiFilter.filterEmail('noreply@example.at').allowed, isFalse);
      expect(PiiFilter.filterEmail('no-reply@example.at').allowed, isFalse);
    });
  });

  group('Bundesland', () {
    test('infers from postcode', () {
      expect(Bundesland.fromPostcode('1010'), equals(Bundesland.wien));
      expect(Bundesland.fromPostcode('2000'), equals(Bundesland.niederoesterreich));
      expect(Bundesland.fromPostcode('4020'), equals(Bundesland.oberoesterreich));
      expect(Bundesland.fromPostcode('5020'), equals(Bundesland.salzburg));
      expect(Bundesland.fromPostcode('6020'), equals(Bundesland.tirol));
      expect(Bundesland.fromPostcode('7000'), equals(Bundesland.burgenland));
      expect(Bundesland.fromPostcode('8010'), equals(Bundesland.steiermark));
      expect(Bundesland.fromPostcode('9020'), equals(Bundesland.kaernten));
    });
  });
}
