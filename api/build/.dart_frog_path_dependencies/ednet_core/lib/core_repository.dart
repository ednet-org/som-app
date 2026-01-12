part of ednet_core;

final Logger _coreRepositoryLogger = Logger('ednet_core.core_repository');

class CoreRepository {
  String code;

  final Domains _domains;

  final Map<String, DomainModels> _domainModelsMap;

  CoreRepository([this.code = 'EDNet'])
    : _domains = Domains(),
      _domainModelsMap = <String, DomainModels>{};

  CoreRepository.from(this._domains, [this.code = 'EDNet'])
    : _domainModelsMap = <String, DomainModels>{};

  void add(DomainModels domainModels) {
    var domainCode = domainModels.domain.code;
    var models = getDomainModels(domainCode);
    if (models == null) {
      _domainModelsMap[domainCode] = domainModels;
    } else {
      throw CodeException(
        '$domainCode domain code exists already in the repository.',
      );
    }
  }

  Domains get domains => _domains;

  DomainModels? getDomainModels(String domainCode) =>
      _domainModelsMap[domainCode];

  void gen(String library, [bool specific = true, StringSink? out]) {
    final sink = out ?? StringBuffer();

    title('lib folder', out: sink);
    subTitle('repository', out: sink);
    sink.writeln(genRepository(this, library));

    for (Domain domain in domains) {
      subTitle('libraries', out: sink);
      for (Model model in domain.models) {
        subTitle('${domain.code}.${model.code} model library', out: sink);
        sink.writeln(genEDNetLibrary(model));
        subTitle('${domain.code}.${model.code} model app library', out: sink);
        sink.writeln(genEDNetLibraryApp(model));
      }
    }

    title(
      'You should not change the generated code in the lib/gen folder.',
      out: sink,
    );
    for (Domain domain in domains) {
      subTitle('${domain.code} domain models', out: sink);
      sink.writeln(genModels(domain, library));
      for (Model model in domain.models) {
        subTitle('${domain.code}.${model.code} model entries', out: sink);
        sink.writeln(genEntries(model, library));
        for (Concept concept in model.concepts) {
          subTitle(
            '${domain.code}.${model.code}.${concept.code} concept',
            out: sink,
          );
          sink.writeln(genConceptGen(concept, library));
        }
      }
    }

    if (specific) {
      for (Domain domain in domains) {
        title(
          'You may change the generated code in the '
          'lib/${domain.codeFirstLetterLower} folder.',
          out: sink,
        );
        subTitle('${domain.code} domain', out: sink);
        sink.writeln(genDomain(domain, library));
        for (Model model in domain.models) {
          subTitle('${domain.code}.${model.code} model', out: sink);
          sink.writeln(genModel(model, library));
          for (Concept concept in model.concepts) {
            subTitle(
              '${domain.code}.${model.code}.${concept.code} concept',
              out: sink,
            );
            sink.writeln(genConcept(concept, library));
          }
          for (Concept entryConcept in model.entryConcepts) {
            subTitle(
              '${domain.code}.${model.code}.${entryConcept.code} model tests',
              out: sink,
            );
          }
        }
      }

      for (Domain domain in domains) {
        title('Specific gen and test code in the test folder.', out: sink);
        for (Model model in domain.models) {
          subTitle(
            'Code generation of the '
            '${domain.code}.${model.code} model',
            out: sink,
          );
        }
      }

      for (Domain domain in domains) {
        title('Specific code in the web folder.', out: sink);
        for (Model model in domain.models) {
          subTitle('${domain.code}.${model.code} model web page', out: sink);
          sink.writeln(genEDNetWeb(model));
        }
      }
    }

    if (out == null) {
      _coreRepositoryLogger.fine(sink.toString());
    }
  }

  void title(String title, {String title1 = '', StringSink? out}) {
    final sink = out ?? StringBuffer();
    sink
      ..writeln('')
      ..writeln(
        '==================================================================',
      )
      ..writeln(
        '$title                                                            ',
      )
      ..writeln(
        '$title1                                                            ',
      )
      ..writeln(
        '==================================================================',
      )
      ..writeln('');

    if (out == null) {
      _coreRepositoryLogger.fine(sink.toString());
    }
  }

  void subTitle(String subTitle, {StringSink? out}) {
    final sink = out ?? StringBuffer();
    sink
      ..writeln('')
      ..writeln('-----------------------------------------------------')
      ..writeln('$subTitle                                             ')
      ..writeln('-----------------------------------------------------')
      ..writeln('');

    if (out == null) {
      _coreRepositoryLogger.fine(sink.toString());
    }
  }
}
