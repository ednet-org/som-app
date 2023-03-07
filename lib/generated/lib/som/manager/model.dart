 
part of som_manager; 
 
// lib/som/manager/model.dart 
 
class ManagerModel extends ManagerEntries { 
 
  ManagerModel(Model model) : super(model); 
 
  void fromJsonToOfferProviderEntry() { 
    fromJsonToEntry(somManagerOfferProviderEntry); 
  } 
 
  void fromJsonToConsultantEntry() { 
    fromJsonToEntry(somManagerConsultantEntry); 
  } 
 
  void fromJsonToBuyerEntry() { 
    fromJsonToEntry(somManagerBuyerEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(somManagerModel); 
  } 
 
  void init() { 
    initOfferProviders(); 
    initBuyers(); 
    initConsultants(); 
  } 
 
  void initOfferProviders() { 
    var offerProvider1 = OfferProvider(offerProviders.concept); 
    offerProvider1.company = 'candy'; 
    offerProvider1.user = 'season'; 
    offerProviders.add(offerProvider1); 
 
    var offerProvider2 = OfferProvider(offerProviders.concept); 
    offerProvider2.company = 'output'; 
    offerProvider2.user = 'vessel'; 
    offerProviders.add(offerProvider2); 
 
    var offerProvider3 = OfferProvider(offerProviders.concept); 
    offerProvider3.company = 'thing'; 
    offerProvider3.user = 'restaurant'; 
    offerProviders.add(offerProvider3); 
 
  } 
 
  void initConsultants() { 
    var consultant1 = Consultant(consultants.concept); 
    consultant1.user = 'paper'; 
    consultants.add(consultant1); 
 
    var consultant2 = Consultant(consultants.concept); 
    consultant2.user = 'thing'; 
    consultants.add(consultant2); 
 
    var consultant3 = Consultant(consultants.concept); 
    consultant3.user = 'craving'; 
    consultants.add(consultant3); 
 
  } 
 
  void initBuyers() { 
    var buyer1 = Buyer(buyers.concept); 
    buyer1.user = 'wife'; 
    buyers.add(buyer1); 
 
    var buyer2 = Buyer(buyers.concept); 
    buyer2.user = 'cash'; 
    buyers.add(buyer2); 
 
    var buyer3 = Buyer(buyers.concept); 
    buyer3.user = 'beer'; 
    buyers.add(buyer3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
