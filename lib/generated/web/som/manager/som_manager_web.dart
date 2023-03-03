 
// web/som/manager/som_manager_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void initData(CoreRepository repository) { 
   SomDomain? somDomain = repository.getDomainModels("Som") as SomDomain?; 
   ManagerModel? managerModel = somDomain?.getModelEntries("Manager") as ManagerModel?; 
   managerModel?.init(); 
   managerModel?.display(); 
} 
 
void showData(CoreRepository repository) { 
   // var mainView = View(document, "main"); 
   // mainView.repo = repository; 
   // new RepoMainSection(mainView); 
   print("not implemented"); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  initData(repository); 
  showData(repository); 
} 
 
