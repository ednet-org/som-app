part of som_manager; 
 
// lib/gen/som/i_domain_models.dart 
 
class SomModels extends DomainModels { 
 
  SomModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel(somManagerModelJson, domain, "Manager"); 
    ManagerModel managerModel = ManagerModel(model); 
    add(managerModel); 
 
  } 
 
} 
 
