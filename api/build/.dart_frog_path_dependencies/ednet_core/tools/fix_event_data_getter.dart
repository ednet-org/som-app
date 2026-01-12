import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

class EventDataGetterFixer extends RecursiveAstVisitor<void> {
  final List<ClassDeclaration> classesToFix = [];
  final String filePath;

  EventDataGetterFixer(this.filePath);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Check if class implements IDomainEvent
    if (node.implementsClause != null) {
      for (final type in node.implementsClause!.interfaces) {
        if (type.name2.lexeme == 'IDomainEvent') {
          // Check if eventData getter already exists
          bool hasEventDataGetter = false;
          for (final member in node.members) {
            if (member is MethodDeclaration &&
                member.isGetter &&
                member.name.lexeme == 'eventData') {
              hasEventDataGetter = true;
              break;
            }
          }

          if (!hasEventDataGetter) {
            classesToFix.add(node);
            print(
              'Found class ${node.name.lexeme} in $filePath missing eventData getter',
            );
          }
          break;
        }
      }
    }
    super.visitClassDeclaration(node);
  }
}

Future<void> fixFile(String filePath) async {
  final file = File(filePath);
  if (!file.existsSync()) return;

  final content = await file.readAsString();
  final collection = AnalysisContextCollection(
    includedPaths: [filePath],
    resourceProvider: PhysicalFileSystemProvider.INSTANCE,
  );

  final context = collection.contextFor(filePath);
  final result = await context.currentSession.getResolvedUnit(filePath);

  if (result is ResolvedUnitResult) {
    final visitor = EventDataGetterFixer(filePath);
    result.unit.accept(visitor);

    if (visitor.classesToFix.isNotEmpty) {
      String modifiedContent = content;

      // Add eventData getter to each class that needs it
      for (final classNode in visitor.classesToFix.reversed) {
        final className = classNode.name.lexeme;

        // Find the end of the class body (before the closing brace)
        final classEnd = classNode.rightBracket.offset;

        // Generate the eventData getter
        final eventDataGetter = '''

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);
    
    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');
    
    return data;
  }''';

        // Insert the getter before the closing brace
        modifiedContent =
            modifiedContent.substring(0, classEnd) +
            eventDataGetter +
            modifiedContent.substring(classEnd);
      }

      await file.writeAsString(modifiedContent);
      print('Fixed ${visitor.classesToFix.length} classes in $filePath');
    }
  }
}

Future<void> main() async {
  final testFiles = [
    '/Users/slavisam/projects/cms/packages/core/test/event_bus/event_bus_test.dart',
    '/Users/slavisam/projects/cms/packages/core/test/integration/event_sourcing_integration_test.dart',
    '/Users/slavisam/projects/cms/packages/core/test/integration/event_storming_complete_cycle_test.dart',
    '/Users/slavisam/projects/cms/packages/core/test/integration/role_based_policy_meta_modeling_test.dart',
    '/Users/slavisam/projects/cms/packages/core/test/process_manager/process_manager_test.dart',
    '/Users/slavisam/projects/cms/packages/core/test/cqrs/projections/projection_test.dart',
  ];

  print('Starting to fix eventData getter in test files...');

  for (final filePath in testFiles) {
    await fixFile(filePath);
  }

  print('Completed fixing eventData getters!');
}
