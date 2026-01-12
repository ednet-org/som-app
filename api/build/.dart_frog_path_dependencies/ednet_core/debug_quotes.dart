import 'lib/ednet_core.dart';

void main() {
  print('wordList.length: ${wordList.length}');
  print('uriList.length: ${uriList.length}');
  print('emailList.length: ${emailList.length}');
  print('quotes.length: ${quotes.length}');

  if (quotes.isNotEmpty) {
    print('First quote: ${quotes[0]}');
    print('First quote type: ${quotes[0].runtimeType}');
  }
}
