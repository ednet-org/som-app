 
// test/som/manager/som_manager_offer_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerOffers( 
    SomDomain somDomain, ManagerModel managerModel, Offers offers) { 
  DomainSession session; 
  group("Testing Som.Manager.Offer", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(offers.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(offers.isEmpty, isTrue); 
      expect(offers.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("Offer"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("Offer"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("Offer"); 
      offers.clear(); 
      expect(offers.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(offers.isEmpty, isFalse); 
 
      offers.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add offer required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add offer unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found offer by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var offer = offers.singleWhereOid(ednetOid); 
      expect(offer, isNull); 
    }); 
 
    test("Find offer by oid", () { 
      var randomOffer = offers.random(); 
      var offer = offers.singleWhereOid(randomOffer.oid); 
      expect(offer, isNotNull); 
      expect(offer, equals(randomOffer)); 
    }); 
 
    test("Find offer by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find offer by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find offer by attribute", () { 
      var randomOffer = offers.random(); 
      var offer = 
          offers.firstWhereAttribute("description", randomOffer.description); 
      expect(offer, isNotNull); 
      expect(offer.description, equals(randomOffer.description)); 
    }); 
 
    test("Select offers by attribute", () { 
      var randomOffer = offers.random(); 
      var selectedOffers = 
          offers.selectWhereAttribute("description", randomOffer.description); 
      expect(selectedOffers.isEmpty, isFalse); 
      selectedOffers.forEach((se) => 
          expect(se.description, equals(randomOffer.description))); 
 
      //selectedOffers.display(title: "Select offers by description"); 
    }); 
 
    test("Select offers by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select offers by attribute, then add", () { 
      var randomOffer = offers.random(); 
      var selectedOffers = 
          offers.selectWhereAttribute("description", randomOffer.description); 
      expect(selectedOffers.isEmpty, isFalse); 
      expect(selectedOffers.source?.isEmpty, isFalse); 
      var offersCount = offers.length; 
 
      var offer = Offer(offers.concept); 
      offer.description = 'nothingness'; 
      offer.deliveryTime = 'ocean'; 
      offer.status = 'teacher'; 
      offer.expirationDate = new DateTime.now(); 
      offer.price = 13.074096469723862; 
      var added = selectedOffers.add(offer); 
      expect(added, isTrue); 
      expect(offers.length, equals(++offersCount)); 
 
      //selectedOffers.display(title: 
      //  "Select offers by attribute, then add"); 
      //offers.display(title: "All offers"); 
    }); 
 
    test("Select offers by attribute, then remove", () { 
      var randomOffer = offers.random(); 
      var selectedOffers = 
          offers.selectWhereAttribute("description", randomOffer.description); 
      expect(selectedOffers.isEmpty, isFalse); 
      expect(selectedOffers.source?.isEmpty, isFalse); 
      var offersCount = offers.length; 
 
      var removed = selectedOffers.remove(randomOffer); 
      expect(removed, isTrue); 
      expect(offers.length, equals(--offersCount)); 
 
      randomOffer.display(prefix: "removed"); 
      //selectedOffers.display(title: 
      //  "Select offers by attribute, then remove"); 
      //offers.display(title: "All offers"); 
    }); 
 
    test("Sort offers", () { 
      // no id attribute 
      // add compareTo method in the specific Offer class 
      /* 
      offers.sort(); 
 
      //offers.display(title: "Sort offers"); 
      */ 
    }); 
 
    test("Order offers", () { 
      // no id attribute 
      // add compareTo method in the specific Offer class 
      /* 
      var orderedOffers = offers.order(); 
      expect(orderedOffers.isEmpty, isFalse); 
      expect(orderedOffers.length, equals(offers.length)); 
      expect(orderedOffers.source?.isEmpty, isFalse); 
      expect(orderedOffers.source?.length, equals(offers.length)); 
      expect(orderedOffers, isNot(same(offers))); 
 
      //orderedOffers.display(title: "Order offers"); 
      */ 
    }); 
 
    test("Copy offers", () { 
      var copiedOffers = offers.copy(); 
      expect(copiedOffers.isEmpty, isFalse); 
      expect(copiedOffers.length, equals(offers.length)); 
      expect(copiedOffers, isNot(same(offers))); 
      copiedOffers.forEach((e) => 
        expect(e, equals(offers.singleWhereOid(e.oid)))); 
      copiedOffers.forEach((e) => 
        expect(e, isNot(same(offers.singleWhereId(e.id!))))); 
 
      //copiedOffers.display(title: "Copy offers"); 
    }); 
 
    test("True for every offer", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random offer", () { 
      var offer1 = offers.random(); 
      expect(offer1, isNotNull); 
      var offer2 = offers.random(); 
      expect(offer2, isNotNull); 
 
      //offer1.display(prefix: "random1"); 
      //offer2.display(prefix: "random2"); 
    }); 
 
    test("Update offer id with try", () { 
      // no id attribute 
    }); 
 
    test("Update offer id without try", () { 
      // no id attribute 
    }); 
 
    test("Update offer id with success", () { 
      // no id attribute 
    }); 
 
    test("Update offer non id attribute with failure", () { 
      var randomOffer = offers.random(); 
      var afterUpdateEntity = randomOffer.copy(); 
      afterUpdateEntity.description = 'software'; 
      expect(afterUpdateEntity.description, equals('software')); 
      // offers.update can only be used if oid, code or id is set. 
      expect(() => offers.update(randomOffer, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomOffer = offers.random(); 
      randomOffer.display(prefix:"before copy: "); 
      var randomOfferCopy = randomOffer.copy(); 
      randomOfferCopy.display(prefix:"after copy: "); 
      expect(randomOffer, equals(randomOfferCopy)); 
      expect(randomOffer.oid, equals(randomOfferCopy.oid)); 
      expect(randomOffer.code, equals(randomOfferCopy.code)); 
      expect(randomOffer.description, equals(randomOfferCopy.description)); 
      expect(randomOffer.deliveryTime, equals(randomOfferCopy.deliveryTime)); 
      expect(randomOffer.status, equals(randomOfferCopy.status)); 
      expect(randomOffer.expirationDate, equals(randomOfferCopy.expirationDate)); 
      expect(randomOffer.price, equals(randomOfferCopy.price)); 
 
    }); 
 
    test("offer action undo and redo", () { 
      var offerCount = offers.length; 
      var offer = Offer(offers.concept); 
        offer.description = 'productivity'; 
      offer.deliveryTime = 'big'; 
      offer.status = 'oil'; 
      offer.expirationDate = new DateTime.now(); 
      offer.price = 32.82610189296762; 
    var offerProvider = offerProviders.random(); 
    offer.provider = offerProvider; 
    var offerInquiry = inquiries.random(); 
    offer.inquiry = offerInquiry; 
      offers.add(offer); 
    offerProvider.offers.add(offer); 
    offerInquiry.offers.add(offer); 
      expect(offers.length, equals(++offerCount)); 
      offers.remove(offer); 
      expect(offers.length, equals(--offerCount)); 
 
      var action = AddCommand(session, offers, offer); 
      action.doIt(); 
      expect(offers.length, equals(++offerCount)); 
 
      action.undo(); 
      expect(offers.length, equals(--offerCount)); 
 
      action.redo(); 
      expect(offers.length, equals(++offerCount)); 
    }); 
 
    test("offer session undo and redo", () { 
      var offerCount = offers.length; 
      var offer = Offer(offers.concept); 
        offer.description = 'teaching'; 
      offer.deliveryTime = 'selfie'; 
      offer.status = 'pencil'; 
      offer.expirationDate = new DateTime.now(); 
      offer.price = 96.98283436823006; 
    var offerProvider = offerProviders.random(); 
    offer.provider = offerProvider; 
    var offerInquiry = inquiries.random(); 
    offer.inquiry = offerInquiry; 
      offers.add(offer); 
    offerProvider.offers.add(offer); 
    offerInquiry.offers.add(offer); 
      expect(offers.length, equals(++offerCount)); 
      offers.remove(offer); 
      expect(offers.length, equals(--offerCount)); 
 
      var action = AddCommand(session, offers, offer); 
      action.doIt(); 
      expect(offers.length, equals(++offerCount)); 
 
      session.past.undo(); 
      expect(offers.length, equals(--offerCount)); 
 
      session.past.redo(); 
      expect(offers.length, equals(++offerCount)); 
    }); 
 
    test("Offer update undo and redo", () { 
      var offer = offers.random(); 
      var action = SetAttributeCommand(session, offer, "description", 'winter'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(offer.description, equals(action.before)); 
 
      session.past.redo(); 
      expect(offer.description, equals(action.after)); 
    }); 
 
    test("Offer action with multiple undos and redos", () { 
      var offerCount = offers.length; 
      var offer1 = offers.random(); 
 
      var action1 = RemoveCommand(session, offers, offer1); 
      action1.doIt(); 
      expect(offers.length, equals(--offerCount)); 
 
      var offer2 = offers.random(); 
 
      var action2 = RemoveCommand(session, offers, offer2); 
      action2.doIt(); 
      expect(offers.length, equals(--offerCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(offers.length, equals(++offerCount)); 
 
      session.past.undo(); 
      expect(offers.length, equals(++offerCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(offers.length, equals(--offerCount)); 
 
      session.past.redo(); 
      expect(offers.length, equals(--offerCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var offerCount = offers.length; 
      var offer1 = offers.random(); 
      var offer2 = offers.random(); 
      while (offer1 == offer2) { 
        offer2 = offers.random();  
      } 
      var action1 = RemoveCommand(session, offers, offer1); 
      var action2 = RemoveCommand(session, offers, offer2); 
 
      var transaction = new Transaction("two removes on offers", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      offerCount = offerCount - 2; 
      expect(offers.length, equals(offerCount)); 
 
      offers.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      offerCount = offerCount + 2; 
      expect(offers.length, equals(offerCount)); 
 
      offers.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      offerCount = offerCount - 2; 
      expect(offers.length, equals(offerCount)); 
 
      offers.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var offerCount = offers.length; 
      var offer1 = offers.random(); 
      var offer2 = offer1; 
      var action1 = RemoveCommand(session, offers, offer1); 
      var action2 = RemoveCommand(session, offers, offer2); 
 
      var transaction = Transaction( 
        "two removes on offers, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(offers.length, equals(offerCount)); 
 
      //offers.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to offer actions", () { 
      var offerCount = offers.length; 
 
      var reaction = OfferReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var offer = Offer(offers.concept); 
        offer.description = 'guest'; 
      offer.deliveryTime = 'highway'; 
      offer.status = 'accomodation'; 
      offer.expirationDate = new DateTime.now(); 
      offer.price = 96.043730749771; 
    var offerProvider = offerProviders.random(); 
    offer.provider = offerProvider; 
    var offerInquiry = inquiries.random(); 
    offer.inquiry = offerInquiry; 
      offers.add(offer); 
    offerProvider.offers.add(offer); 
    offerInquiry.offers.add(offer); 
      expect(offers.length, equals(++offerCount)); 
      offers.remove(offer); 
      expect(offers.length, equals(--offerCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, offers, offer); 
      addCommand.doIt(); 
      expect(offers.length, equals(++offerCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, offer, "description", 'thing'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class OfferReaction implements ICommandReaction { 
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
  var offers = managerModel.offers; 
  testSomManagerOffers(somDomain, managerModel, offers); 
} 
 
