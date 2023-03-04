// test/som/manager/som_manager_inquiry_test.dart

import "package:test/test.dart";
import "package:ednet_core/ednet_core.dart";
import "package:som_manager/som_manager.dart";

void testSomManagerInquiries(SomDomain somDomain, ManagerModel managerModel,
    Inquiries inquiries, Users users) {
  DomainSession session;
  group("Testing Som.Manager.Inquiry", () {
    session = somDomain.newSession();
    setUp(() {
      managerModel.init();
    });
    tearDown(() {
      managerModel.clear();
    });

    test("Not empty model", () {
      expect(managerModel.isEmpty, isFalse);
      expect(inquiries.isEmpty, isFalse);
    });

    test("Empty model", () {
      managerModel.clear();
      expect(managerModel.isEmpty, isTrue);
      expect(inquiries.isEmpty, isTrue);
      expect(inquiries.exceptions.isEmpty, isTrue);
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
      var json = managerModel.fromEntryToJson("Inquiry");
      expect(json, isNotNull);

      print(json);
      //managerModel.displayEntryJson("Inquiry");
      //managerModel.displayJson();
      //managerModel.display();
    });

    test("From JSON to model entry", () {
      var json = managerModel.fromEntryToJson("Inquiry");
      inquiries.clear();
      expect(inquiries.isEmpty, isTrue);
      managerModel.fromJsonToEntry(json);
      expect(inquiries.isEmpty, isFalse);

      inquiries.display(title: "From JSON to model entry");
    });

    test("Add inquiry required error", () {
      // no required attribute that is not id
    });

    test("Add inquiry unique error", () {
      // no id attribute
    });

    test("Not found inquiry by oid", () {
      var ednetOid = Oid.ts(1345648254063);
      var inquiry = inquiries.singleWhereOid(ednetOid);
      expect(inquiry, isNull);
    });

    test("Find inquiry by oid", () {
      var randomInquiry = inquiries.random();
      var inquiry = inquiries.singleWhereOid(randomInquiry.oid);
      expect(inquiry, isNotNull);
      expect(inquiry, equals(randomInquiry));
    });

    test("Find inquiry by attribute id", () {
      // no id attribute
    });

    test("Find inquiry by required attribute", () {
      // no required attribute that is not id
    });

    test("Find inquiry by attribute", () {
      var randomInquiry = inquiries.random();
      var inquiry = inquiries.firstWhereAttribute("title", randomInquiry.title);
      expect(inquiry, isNotNull);
      expect(inquiry.title, equals(randomInquiry.title));
    });

    test("Select inquiries by attribute", () {
      var randomInquiry = inquiries.random();
      var selectedInquiries =
          inquiries.selectWhereAttribute("title", randomInquiry.title);
      expect(selectedInquiries.isEmpty, isFalse);
      selectedInquiries
          .forEach((se) => expect(se.title, equals(randomInquiry.title)));

      //selectedInquiries.display(title: "Select inquiries by title");
    });

    test("Select inquiries by required attribute", () {
      // no required attribute that is not id
    });

    test("Select inquiries by attribute, then add", () {
      var randomInquiry = inquiries.random();
      var selectedInquiries =
          inquiries.selectWhereAttribute("title", randomInquiry.title);
      expect(selectedInquiries.isEmpty, isFalse);
      expect(selectedInquiries.source?.isEmpty, isFalse);
      var inquiriesCount = inquiries.length;

      var inquiry = Inquiry(inquiries.concept!);
      inquiry.title = 'heaven';
      inquiry.buyer = users.random();
      inquiry.description = 'circle';
      inquiry.category = 'taxi';
      inquiry.branch = 'yellow';
      inquiry.publishingDate = new DateTime.now();
      inquiry.expirationDate = new DateTime.now();
      inquiry.deliveryLocation = 'guest';
      inquiry.providerCriteria = 'concern';
      inquiry.status = 'body';
      var added = selectedInquiries.add(inquiry);
      expect(added, isTrue);
      expect(inquiries.length, equals(++inquiriesCount));

      //selectedInquiries.display(title:
      //  "Select inquiries by attribute, then add");
      //inquiries.display(title: "All inquiries");
    });

    test("Select inquiries by attribute, then remove", () {
      var randomInquiry = inquiries.random();
      var selectedInquiries =
          inquiries.selectWhereAttribute("title", randomInquiry.title);
      expect(selectedInquiries.isEmpty, isFalse);
      expect(selectedInquiries.source?.isEmpty, isFalse);
      var inquiriesCount = inquiries.length;

      var removed = selectedInquiries.remove(randomInquiry);
      expect(removed, isTrue);
      expect(inquiries.length, equals(--inquiriesCount));

      randomInquiry.display(prefix: "removed");
      //selectedInquiries.display(title:
      //  "Select inquiries by attribute, then remove");
      //inquiries.display(title: "All inquiries");
    });

    test("Sort inquiries", () {
      // no id attribute
      // add compareTo method in the specific Inquiry class
      /*
      inquiries.sort();

      //inquiries.display(title: "Sort inquiries");
      */
    });

    test("Order inquiries", () {
      // no id attribute
      // add compareTo method in the specific Inquiry class
      /*
      var orderedInquiries = inquiries.order();
      expect(orderedInquiries.isEmpty, isFalse);
      expect(orderedInquiries.length, equals(inquiries.length));
      expect(orderedInquiries.source?.isEmpty, isFalse);
      expect(orderedInquiries.source?.length, equals(inquiries.length));
      expect(orderedInquiries, isNot(same(inquiries)));

      //orderedInquiries.display(title: "Order inquiries");
      */
    });

    test("Copy inquiries", () {
      var copiedInquiries = inquiries.copy();
      expect(copiedInquiries.isEmpty, isFalse);
      expect(copiedInquiries.length, equals(inquiries.length));
      expect(copiedInquiries, isNot(same(inquiries)));
      copiedInquiries
          .forEach((e) => expect(e, equals(inquiries.singleWhereOid(e.oid))));

      //copiedInquiries.display(title: "Copy inquiries");
    });

    test("True for every inquiry", () {
      // no required attribute that is not id
    });

    test("Random inquiry", () {
      var inquiry1 = inquiries.random();
      expect(inquiry1, isNotNull);
      var inquiry2 = inquiries.random();
      expect(inquiry2, isNotNull);

      //inquiry1.display(prefix: "random1");
      //inquiry2.display(prefix: "random2");
    });

    test("Update inquiry id with try", () {
      // no id attribute
    });

    test("Update inquiry id without try", () {
      // no id attribute
    });

    test("Update inquiry id with success", () {
      // no id attribute
    });

    test("Update inquiry non id attribute with failure", () {
      var randomInquiry = inquiries.random();
      var afterUpdateEntity = randomInquiry.copy();
      afterUpdateEntity.title = 'small';
      expect(afterUpdateEntity.title, equals('small'));
      // inquiries.update can only be used if oid, code or id is set.
      expect(() => inquiries.update(randomInquiry, afterUpdateEntity), throws);
    });

    test("Copy Equality", () {
      var randomInquiry = inquiries.random();
      randomInquiry.display(prefix: "before copy: ");
      var randomInquiryCopy = randomInquiry.copy();
      randomInquiryCopy.display(prefix: "after copy: ");
      expect(randomInquiry, equals(randomInquiryCopy));
      expect(randomInquiry.oid, equals(randomInquiryCopy.oid));
      expect(randomInquiry.code, equals(randomInquiryCopy.code));
      expect(randomInquiry.title, equals(randomInquiryCopy.title));
      expect(randomInquiry.description, equals(randomInquiryCopy.description));
      expect(randomInquiry.category, equals(randomInquiryCopy.category));
      expect(randomInquiry.branch, equals(randomInquiryCopy.branch));
      expect(randomInquiry.publishingDate,
          equals(randomInquiryCopy.publishingDate));
      expect(randomInquiry.expirationDate,
          equals(randomInquiryCopy.expirationDate));
      expect(randomInquiry.deliveryLocation,
          equals(randomInquiryCopy.deliveryLocation));
      expect(randomInquiry.providerCriteria,
          equals(randomInquiryCopy.providerCriteria));
      expect(randomInquiry.status, equals(randomInquiryCopy.status));
    });

    test("inquiry action undo and redo", () {
      var inquiryCount = inquiries.length;
      var inquiry = Inquiry(inquiries.concept!);
      inquiry.title = 'school';
      inquiry.description = 'college';
      inquiry.category = 'economy';
      inquiry.branch = 'word';
      inquiry.publishingDate = new DateTime.now();
      inquiry.expirationDate = new DateTime.now();
      inquiry.deliveryLocation = 'family';
      inquiry.providerCriteria = 'winter';
      inquiry.status = 'yellow';
      var inquiryBuyer = users.random();
      inquiry.buyer = inquiryBuyer;
      inquiries.add(inquiry);
      inquiryBuyer.inquiries.add(inquiry);
      expect(inquiries.length, equals(++inquiryCount));
      inquiries.remove(inquiry);
      expect(inquiries.length, equals(--inquiryCount));

      var action = AddCommand(session, inquiries, inquiry);
      action.doIt();
      expect(inquiries.length, equals(++inquiryCount));

      action.undo();
      expect(inquiries.length, equals(--inquiryCount));

      action.redo();
      expect(inquiries.length, equals(++inquiryCount));
    });

    test("inquiry session undo and redo", () {
      var inquiryCount = inquiries.length;
      var inquiry = Inquiry(inquiries.concept!);
      inquiry.title = 'answer';
      inquiry.description = 'slate';
      inquiry.category = 'celebration';
      inquiry.branch = 'tax';
      inquiry.publishingDate = new DateTime.now();
      inquiry.expirationDate = new DateTime.now();
      inquiry.deliveryLocation = 'job';
      inquiry.providerCriteria = 'pub';
      inquiry.status = 'architecture';
      var inquiryBuyer = users.random();
      inquiry.buyer = inquiryBuyer;
      inquiries.add(inquiry);
      inquiryBuyer.inquiries.add(inquiry);
      expect(inquiries.length, equals(++inquiryCount));
      inquiries.remove(inquiry);
      expect(inquiries.length, equals(--inquiryCount));

      var action = AddCommand(session, inquiries, inquiry);
      action.doIt();
      expect(inquiries.length, equals(++inquiryCount));

      session.past.undo();
      expect(inquiries.length, equals(--inquiryCount));

      session.past.redo();
      expect(inquiries.length, equals(++inquiryCount));
    });

    test("Inquiry update undo and redo", () {
      var inquiry = inquiries.random();
      var action = SetAttributeCommand(session, inquiry, "title", 'accident');
      action.doIt();

      session.past.undo();
      expect(inquiry.title, equals(action.before));

      session.past.redo();
      expect(inquiry.title, equals(action.after));
    });

    test("Inquiry action with multiple undos and redos", () {
      var inquiryCount = inquiries.length;
      var inquiry1 = inquiries.random();

      var action1 = RemoveCommand(session, inquiries, inquiry1);
      action1.doIt();
      expect(inquiries.length, equals(--inquiryCount));

      var inquiry2 = inquiries.random();

      var action2 = RemoveCommand(session, inquiries, inquiry2);
      action2.doIt();
      expect(inquiries.length, equals(--inquiryCount));

      //session.past.display();

      session.past.undo();
      expect(inquiries.length, equals(++inquiryCount));

      session.past.undo();
      expect(inquiries.length, equals(++inquiryCount));

      //session.past.display();

      session.past.redo();
      expect(inquiries.length, equals(--inquiryCount));

      session.past.redo();
      expect(inquiries.length, equals(--inquiryCount));

      //session.past.display();
    });

    test("Transaction undo and redo", () {
      var inquiryCount = inquiries.length;
      var inquiry1 = inquiries.random();
      var inquiry2 = inquiries.random();
      while (inquiry1 == inquiry2) {
        inquiry2 = inquiries.random();
      }
      var action1 = RemoveCommand(session, inquiries, inquiry1);
      var action2 = RemoveCommand(session, inquiries, inquiry2);

      var transaction = new Transaction("two removes on inquiries", session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      inquiryCount = inquiryCount - 2;
      expect(inquiries.length, equals(inquiryCount));

      inquiries.display(title: "Transaction Done");

      session.past.undo();
      inquiryCount = inquiryCount + 2;
      expect(inquiries.length, equals(inquiryCount));

      inquiries.display(title: "Transaction Undone");

      session.past.redo();
      inquiryCount = inquiryCount - 2;
      expect(inquiries.length, equals(inquiryCount));

      inquiries.display(title: "Transaction Redone");
    });

    test("Transaction with one action error", () {
      var inquiryCount = inquiries.length;
      var inquiry1 = inquiries.random();
      var inquiry2 = inquiry1;
      var action1 = RemoveCommand(session, inquiries, inquiry1);
      var action2 = RemoveCommand(session, inquiries, inquiry2);

      var transaction = Transaction(
          "two removes on inquiries, with an error on the second", session);
      transaction.add(action1);
      transaction.add(action2);
      var done = transaction.doIt();
      expect(done, isFalse);
      expect(inquiries.length, equals(inquiryCount));

      //inquiries.display(title:"Transaction with an error");
    });

    test("Reactions to inquiry actions", () {
      var inquiryCount = inquiries.length;

      var reaction = InquiryReaction();
      expect(reaction, isNotNull);

      somDomain.startCommandReaction(reaction);
      var inquiry = Inquiry(inquiries.concept!);
      inquiry.title = 'brave';
      inquiry.description = 'ocean';
      inquiry.category = 'tag';
      inquiry.branch = 'hat';
      inquiry.publishingDate = new DateTime.now();
      inquiry.expirationDate = new DateTime.now();
      inquiry.deliveryLocation = 'picture';
      inquiry.providerCriteria = 'notch';
      inquiry.status = 'season';
      var inquiryBuyer = users.random();
      inquiry.buyer = inquiryBuyer;
      inquiries.add(inquiry);
      inquiryBuyer.inquiries.add(inquiry);
      expect(inquiries.length, equals(++inquiryCount));
      inquiries.remove(inquiry);
      expect(inquiries.length, equals(--inquiryCount));

      var session = somDomain.newSession();
      var addCommand = AddCommand(session, inquiries, inquiry);
      addCommand.doIt();
      expect(inquiries.length, equals(++inquiryCount));
      expect(reaction.reactedOnAdd, isTrue);

      var setAttributeCommand =
          SetAttributeCommand(session, inquiry, "title", 'river');
      setAttributeCommand.doIt();
      expect(reaction.reactedOnUpdate, isTrue);
      somDomain.cancelCommandReaction(reaction);
    });
  });
}

class InquiryReaction implements ICommandReaction {
  bool reactedOnAdd = false;
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
  ManagerModel managerModel =
      somDomain.getModelEntries("Manager") as ManagerModel;
  assert(managerModel != null);
  var inquiries = managerModel.inquiries;
  var users = managerModel.users;
  testSomManagerInquiries(somDomain, managerModel, inquiries, users);
}
