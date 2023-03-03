 
part of som_manager; 
 
// lib/som/manager/model.dart 
 
class ManagerModel extends ManagerEntries { 
 
  ManagerModel(Model model) : super(model); 
 
  void fromJsonToInquiryEntry() { 
    fromJsonToEntry(somManagerInquiryEntry); 
  } 
 
  void fromJsonToOfferEntry() { 
    fromJsonToEntry(somManagerOfferEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(somManagerModel); 
  } 
 
  void init() { 
    initInquiries(); 
    initOffers(); 
  } 
 
  void initInquiries() { 
    var inquiry1 = Inquiry(inquiries.concept); 
    inquiry1.id = 'time'; 
    inquiry1.title = 'hell'; 
    inquiry1.description = 'fish'; 
    inquiry1.category = 'theme'; 
    inquiry1.branch = 'call'; 
    inquiry1.publishingDate = new DateTime.now(); 
    inquiry1.expirationDate = new DateTime.now(); 
    inquiry1.buyer = 'distance'; 
    inquiry1.deliveryLocation = 'boat'; 
    inquiry1.providerCriteria = 'plate'; 
    inquiry1.attachments = 'month'; 
    inquiry1.offers = 'water'; 
    inquiry1.status = 'beach'; 
    var inquiry1Buyer = users.random(); 
    inquiry1.buyer = inquiry1Buyer; 
    inquiries.add(inquiry1); 
    inquiry1Buyer.inquiries.add(inquiry1); 
 
    var inquiry2 = Inquiry(inquiries.concept); 
    inquiry2.id = 'present'; 
    inquiry2.title = 'cinema'; 
    inquiry2.description = 'college'; 
    inquiry2.category = 'month'; 
    inquiry2.branch = 'drink'; 
    inquiry2.publishingDate = new DateTime.now(); 
    inquiry2.expirationDate = new DateTime.now(); 
    inquiry2.buyer = 'organization'; 
    inquiry2.deliveryLocation = 'tape'; 
    inquiry2.providerCriteria = 'future'; 
    inquiry2.attachments = 'deep'; 
    inquiry2.offers = 'city'; 
    inquiry2.status = 'team'; 
    var inquiry2Buyer = users.random(); 
    inquiry2.buyer = inquiry2Buyer; 
    inquiries.add(inquiry2); 
    inquiry2Buyer.inquiries.add(inquiry2); 
 
    var inquiry3 = Inquiry(inquiries.concept); 
    inquiry3.id = 'entrance'; 
    inquiry3.title = 'school'; 
    inquiry3.description = 'house'; 
    inquiry3.category = 'money'; 
    inquiry3.branch = 'feeling'; 
    inquiry3.publishingDate = new DateTime.now(); 
    inquiry3.expirationDate = new DateTime.now(); 
    inquiry3.buyer = 'economy'; 
    inquiry3.deliveryLocation = 'dog'; 
    inquiry3.providerCriteria = 'kids'; 
    inquiry3.attachments = 'element'; 
    inquiry3.offers = 'saving'; 
    inquiry3.status = 'question'; 
    var inquiry3Buyer = users.random(); 
    inquiry3.buyer = inquiry3Buyer; 
    inquiries.add(inquiry3); 
    inquiry3Buyer.inquiries.add(inquiry3); 
 
  } 
 
  void initOffers() { 
    var offer1 = Offer(offers.concept); 
    offer1.id = 'chemist'; 
    offer1.inquiry = 'training'; 
    offer1.provider = 'boat'; 
    offer1.description = 'void'; 
    offer1.deliveryTime = 'price'; 
    offer1.attachments = 'beans'; 
    offer1.status = 'output'; 
    offer1.expirationDate = new DateTime.now(); 
    offer1.price = 29.309964291451074; 
    var offer1Inquiry = inquiries.random(); 
    offer1.inquiry = offer1Inquiry; 
    var offer1Provider = providerCriterias.random(); 
    offer1.provider = offer1Provider; 
    offers.add(offer1); 
    offer1Inquiry.offers.add(offer1); 
    offer1Provider.offers.add(offer1); 
 
    var offer2 = Offer(offers.concept); 
    offer2.id = 'right'; 
    offer2.inquiry = 'present'; 
    offer2.provider = 'park'; 
    offer2.description = 'grading'; 
    offer2.deliveryTime = 'wave'; 
    offer2.attachments = 'corner'; 
    offer2.status = 'train'; 
    offer2.expirationDate = new DateTime.now(); 
    offer2.price = 62.19406239439935; 
    var offer2Inquiry = inquiries.random(); 
    offer2.inquiry = offer2Inquiry; 
    var offer2Provider = providerCriterias.random(); 
    offer2.provider = offer2Provider; 
    offers.add(offer2); 
    offer2Inquiry.offers.add(offer2); 
    offer2Provider.offers.add(offer2); 
 
    var offer3 = Offer(offers.concept); 
    offer3.id = 'mind'; 
    offer3.inquiry = 'done'; 
    offer3.provider = 'candy'; 
    offer3.description = 'word'; 
    offer3.deliveryTime = 'call'; 
    offer3.attachments = 'baby'; 
    offer3.status = 'course'; 
    offer3.expirationDate = new DateTime.now(); 
    offer3.price = 57.95355907571364; 
    var offer3Inquiry = inquiries.random(); 
    offer3.inquiry = offer3Inquiry; 
    var offer3Provider = providerCriterias.random(); 
    offer3.provider = offer3Provider; 
    offers.add(offer3); 
    offer3Inquiry.offers.add(offer3); 
    offer3Provider.offers.add(offer3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
