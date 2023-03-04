 
// test/som/manager/som_manager_provider_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerProviders( 
    SomDomain somDomain, ManagerModel managerModel, Providers providers) { 
  DomainSession session; 
  group("Testing Som.Manager.Provider", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(providers.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(providers.isEmpty, isTrue); 
      expect(providers.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = managerModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = managerModel.toJson(); 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      managerModel.fromJson(json); 
      expect(managerModel.isEmpty, isFalse); 
 
      managerModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = managerModel.fromEntryToJson("Provider"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("Provider"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("Provider"); 
      providers.clear(); 
      expect(providers.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(providers.isEmpty, isFalse); 
 
      providers.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add provider required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add provider unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found provider by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var provider = providers.singleWhereOid(ednetOid); 
      expect(provider, isNull); 
    }); 
 
    test("Find provider by oid", () { 
      var randomProvider = providers.random(); 
      var provider = providers.singleWhereOid(randomProvider.oid); 
      expect(provider, isNotNull); 
      expect(provider, equals(randomProvider)); 
    }); 
 
    test("Find provider by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find provider by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find provider by attribute", () { 
      var randomProvider = providers.random(); 
      var provider = 
          providers.firstWhereAttribute("company", randomProvider.company); 
      expect(provider, isNotNull); 
      expect(provider.company, equals(randomProvider.company)); 
    }); 
 
    test("Select providers by attribute", () { 
      var randomProvider = providers.random(); 
      var selectedProviders = 
          providers.selectWhereAttribute("company", randomProvider.company); 
      expect(selectedProviders.isEmpty, isFalse); 
      selectedProviders.forEach((se) => 
          expect(se.company, equals(randomProvider.company))); 
 
      //selectedProviders.display(title: "Select providers by company"); 
    }); 
 
    test("Select providers by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select providers by attribute, then add", () { 
      var randomProvider = providers.random(); 
      var selectedProviders = 
          providers.selectWhereAttribute("company", randomProvider.company); 
      expect(selectedProviders.isEmpty, isFalse); 
      expect(selectedProviders.source?.isEmpty, isFalse); 
      var providersCount = providers.length; 
 
      var provider = Provider(providers.concept!);
      provider.company = 'hall'; 
      var added = selectedProviders.add(provider); 
      expect(added, isTrue); 
      expect(providers.length, equals(++providersCount)); 
 
      //selectedProviders.display(title: 
      //  "Select providers by attribute, then add"); 
      //providers.display(title: "All providers"); 
    }); 
 
    test("Select providers by attribute, then remove", () { 
      var randomProvider = providers.random(); 
      var selectedProviders = 
          providers.selectWhereAttribute("company", randomProvider.company); 
      expect(selectedProviders.isEmpty, isFalse); 
      expect(selectedProviders.source?.isEmpty, isFalse); 
      var providersCount = providers.length; 
 
      var removed = selectedProviders.remove(randomProvider); 
      expect(removed, isTrue); 
      expect(providers.length, equals(--providersCount)); 
 
      randomProvider.display(prefix: "removed"); 
      //selectedProviders.display(title: 
      //  "Select providers by attribute, then remove"); 
      //providers.display(title: "All providers"); 
    }); 
 
    test("Sort providers", () { 
      // no id attribute 
      // add compareTo method in the specific Provider class 
      /* 
      providers.sort(); 
 
      //providers.display(title: "Sort providers"); 
      */ 
    }); 
 
    test("Order providers", () { 
      // no id attribute 
      // add compareTo method in the specific Provider class 
      /* 
      var orderedProviders = providers.order(); 
      expect(orderedProviders.isEmpty, isFalse); 
      expect(orderedProviders.length, equals(providers.length)); 
      expect(orderedProviders.source?.isEmpty, isFalse); 
      expect(orderedProviders.source?.length, equals(providers.length)); 
      expect(orderedProviders, isNot(same(providers))); 
 
      //orderedProviders.display(title: "Order providers"); 
      */ 
    }); 
 
    test("Copy providers", () { 
      var copiedProviders = providers.copy(); 
      expect(copiedProviders.isEmpty, isFalse); 
      expect(copiedProviders.length, equals(providers.length)); 
      expect(copiedProviders, isNot(same(providers))); 
      copiedProviders.forEach((e) => 
        expect(e, equals(providers.singleWhereOid(e.oid)))); 
 
      //copiedProviders.display(title: "Copy providers"); 
    }); 
 
    test("True for every provider", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random provider", () { 
      var provider1 = providers.random(); 
      expect(provider1, isNotNull); 
      var provider2 = providers.random(); 
      expect(provider2, isNotNull); 
 
      //provider1.display(prefix: "random1"); 
      //provider2.display(prefix: "random2"); 
    }); 
 
    test("Update provider id with try", () { 
      // no id attribute 
    }); 
 
    test("Update provider id without try", () { 
      // no id attribute 
    }); 
 
    test("Update provider id with success", () { 
      // no id attribute 
    }); 
 
    test("Update provider non id attribute with failure", () { 
      var randomProvider = providers.random(); 
      var afterUpdateEntity = randomProvider.copy(); 
      afterUpdateEntity.company = 'cabinet'; 
      expect(afterUpdateEntity.company, equals('cabinet')); 
      // providers.update can only be used if oid, code or id is set. 
      expect(() => providers.update(randomProvider, afterUpdateEntity), throws); 
    }); 
 
    test("Copy Equality", () { 
      var randomProvider = providers.random(); 
      randomProvider.display(prefix:"before copy: "); 
      var randomProviderCopy = randomProvider.copy(); 
      randomProviderCopy.display(prefix:"after copy: "); 
      expect(randomProvider, equals(randomProviderCopy)); 
      expect(randomProvider.oid, equals(randomProviderCopy.oid)); 
      expect(randomProvider.code, equals(randomProviderCopy.code)); 
      expect(randomProvider.company, equals(randomProviderCopy.company)); 
 
    }); 
 
    test("provider action undo and redo", () { 
      var providerCount = providers.length; 
      var provider = Provider(providers.concept!);
        provider.company = 'redo'; 
      providers.add(provider); 
      expect(providers.length, equals(++providerCount)); 
      providers.remove(provider); 
      expect(providers.length, equals(--providerCount)); 
 
      var action = AddCommand(session, providers, provider); 
      action.doIt(); 
      expect(providers.length, equals(++providerCount)); 
 
      action.undo(); 
      expect(providers.length, equals(--providerCount)); 
 
      action.redo(); 
      expect(providers.length, equals(++providerCount)); 
    }); 
 
    test("provider session undo and redo", () { 
      var providerCount = providers.length; 
      var provider = Provider(providers.concept!);
        provider.company = 'accomodation'; 
      providers.add(provider); 
      expect(providers.length, equals(++providerCount)); 
      providers.remove(provider); 
      expect(providers.length, equals(--providerCount)); 
 
      var action = AddCommand(session, providers, provider); 
      action.doIt(); 
      expect(providers.length, equals(++providerCount)); 
 
      session.past.undo(); 
      expect(providers.length, equals(--providerCount)); 
 
      session.past.redo(); 
      expect(providers.length, equals(++providerCount)); 
    }); 
 
    test("Provider update undo and redo", () { 
      var provider = providers.random(); 
      var action = SetAttributeCommand(session, provider, "company", 'smog'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(provider.company, equals(action.before)); 
 
      session.past.redo(); 
      expect(provider.company, equals(action.after)); 
    }); 
 
    test("Provider action with multiple undos and redos", () { 
      var providerCount = providers.length; 
      var provider1 = providers.random(); 
 
      var action1 = RemoveCommand(session, providers, provider1); 
      action1.doIt(); 
      expect(providers.length, equals(--providerCount)); 
 
      var provider2 = providers.random(); 
 
      var action2 = RemoveCommand(session, providers, provider2); 
      action2.doIt(); 
      expect(providers.length, equals(--providerCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(providers.length, equals(++providerCount)); 
 
      session.past.undo(); 
      expect(providers.length, equals(++providerCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(providers.length, equals(--providerCount)); 
 
      session.past.redo(); 
      expect(providers.length, equals(--providerCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var providerCount = providers.length; 
      var provider1 = providers.random(); 
      var provider2 = providers.random(); 
      while (provider1 == provider2) { 
        provider2 = providers.random();  
      } 
      var action1 = RemoveCommand(session, providers, provider1); 
      var action2 = RemoveCommand(session, providers, provider2); 
 
      var transaction = new Transaction("two removes on providers", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      providerCount = providerCount - 2; 
      expect(providers.length, equals(providerCount)); 
 
      providers.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      providerCount = providerCount + 2; 
      expect(providers.length, equals(providerCount)); 
 
      providers.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      providerCount = providerCount - 2; 
      expect(providers.length, equals(providerCount)); 
 
      providers.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var providerCount = providers.length; 
      var provider1 = providers.random(); 
      var provider2 = provider1; 
      var action1 = RemoveCommand(session, providers, provider1); 
      var action2 = RemoveCommand(session, providers, provider2); 
 
      var transaction = Transaction( 
        "two removes on providers, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(providers.length, equals(providerCount)); 
 
      //providers.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to provider actions", () { 
      var providerCount = providers.length; 
 
      var reaction = ProviderReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var provider = Provider(providers.concept!);
        provider.company = 'course'; 
      providers.add(provider); 
      expect(providers.length, equals(++providerCount)); 
      providers.remove(provider); 
      expect(providers.length, equals(--providerCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, providers, provider); 
      addCommand.doIt(); 
      expect(providers.length, equals(++providerCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, provider, "company", 'productivity'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ProviderReaction implements ICommandReaction { 
  bool reactedOnAdd    = false; 
  bool reactedOnUpdate = false; 
 
  void react(ICommand action) { 
    if (action is IEntitiesCommand) { 
      reactedOnAdd = true; 
    } else if (action is IEntityCommand) { 
      reactedOnUpdate = true; 
    } 
  } 
} 
 
void main() { 
  var repository = Repository(); 
  SomDomain somDomain = repository.getDomainModels("Som") as SomDomain;   
  assert(somDomain != null); 
  ManagerModel managerModel = somDomain.getModelEntries("Manager") as ManagerModel;  
  assert(managerModel != null); 
  var providers = managerModel.providers; 
  testSomManagerProviders(somDomain, managerModel, providers); 
} 
 
