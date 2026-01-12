#!/usr/bin/env dart
// Core Package Cleanup Script
// Systematically removes unused variables and elements

void main() async {
  print('🧹 Starting systematic cleanup of unused code in core package...');

  // List of unused local variables to fix
  final unusedVariables = [
    'lib/domain/model/aggregate_root/command_execution_strategies.dart:163:18:policy',
    'lib/domain/model/aggregate_root/command_execution_strategies.dart:191:15:postExecutionCommands',
    'lib/domain/model/entity/entity.dart:978:15:parentOid',
    'lib/domain/patterns/dead_letter_channel/dead_letter_channel.dart:889:13:channel',
    'lib/domain/patterns/message_expiration/message_expiration.dart:759:11:handler',
    'lib/domain/patterns/message_expiration/message_expiration.dart:802:16:channel',
    'lib/gen/ednet_concept_generic.dart:209:11:roles',
  ];

  // List of unused fields to comment out or remove
  final unusedFields = [
    'lib/domain/patterns/competing_consumers/competing_consumers.dart:149:13:_maxConcurrentConsumers',
    'lib/domain/patterns/dead_letter_channel/dead_letter_channel.dart:445:30:_originalChannels',
    'lib/domain/patterns/enricher/content_enricher.dart:156:28:_strategy',
    'lib/domain/patterns/wire_tap/wire_tap.dart:363:16:_compositeName',
  ];

  // List of unused elements to remove
  final unusedElements = [
    'lib/domain/patterns/common/ednet_messages.dart:143:16:_ExampleDomainMessage',
  ];

  print('📊 Found ${unusedVariables.length} unused variables to fix');
  print('📊 Found ${unusedFields.length} unused fields to comment out');
  print('📊 Found ${unusedElements.length} unused elements to remove');

  // For now, print the locations for manual cleanup
  print('\n🎯 Manual cleanup required for:');
  print('\nUnused Variables:');
  unusedVariables.forEach(print);
  print('\nUnused Fields:');
  unusedFields.forEach(print);
  print('\nUnused Elements:');
  unusedElements.forEach(print);

  print(
    '\n✅ Cleanup script complete. Please review and manually fix these locations.',
  );
}
