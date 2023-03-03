part of som_manager; 
 
// lib/repository.dart 
 
class Repository extends CoreRepository { 
 
  static const REPOSITORY = "Repository"; 
 
  Repository([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Som"); 
    domains.add(domain); 
    add(SomDomain(domain)); 
 
  } 
 
} 
 
