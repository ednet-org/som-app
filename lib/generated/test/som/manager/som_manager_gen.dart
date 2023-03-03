 
// test/som/manager/som_manager_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("som_manager"); 
} 
 
void initData(CoreRepository repository) { 
   var somDomain = repository.getDomainModels("Som"); 
   ManagerModel? managerModel = somDomain?.getModelEntries("Manager") as ManagerModel?; 
   managerModel?.init(); 
   //managerModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
