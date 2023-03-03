part of som_manager;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/som/manager/json/model.dart

var somManagerModelJson = r'''
{
  "width": 1920,
  "height": 1080,
  "boxes": [
    {
      "name": "Offer",
      "entry": true,
      "x": 335,
      "y": 490,
      "width": 157,
      "height": 125,
      "items": [
        {
          "sequence": 4,
          "category": "attribute",
          "name": "description",
          "type": "String",
          "essential": false,
          "sensitive": false
        },
        {
          "sequence": 5,
          "category": "attribute",
          "name": "deliveryTime",
          "type": "String",
          "essential": false,
          "sensitive": false
        },
        {
          "sequence": 7,
          "category": "attribute",
          "name": "status",
          "type": "OfferStatus",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 8,
          "category": "attribute",
          "name": "expirationDate",
          "type": "DateTime",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 9,
          "category": "attribute",
          "name": "price",
          "type": "double",
          "essential": false,
          "sensitive": false
        }
      ]
    },
    {
      "name": "User",
      "entry": true,
      "x": 545,
      "y": 164,
      "width": 157,
      "height": 125,
      "items": [
        {
          "sequence": 2,
          "category": "attribute",
          "name": "username",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 4,
          "category": "attribute",
          "name": "roleAtSom",
          "type": "CompanyRoleAtSom",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 5,
          "category": "attribute",
          "name": "roleAtCompany",
          "type": "UserRoleAtCompany",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Buyer",
      "entry": true,
      "x": 0,
      "y": 0,
      "width": 100,
      "height": 100,
      "items": []
    },
    {
      "name": "UserRoleAtCompany",
      "entry": false,
      "x": 995,
      "y": 246,
      "width": 164,
      "height": 91,
      "items": [
        {
          "sequence": 2,
          "category": "attribute",
          "name": "role",
          "type": "UserRole",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Provider",
      "entry": true,
      "x": 335,
      "y": 490,
      "width": 157,
      "height": 125,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "company",
          "type": "Company",
          "essential": false,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Attachment",
      "entry": false,
      "x": 107,
      "y": 490,
      "width": 156,
      "height": 125,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "name",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 2,
          "category": "attribute",
          "name": "type",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 3,
          "category": "attribute",
          "name": "data",
          "type": "Uint8List",
          "essential": false,
          "sensitive": false
        },
        {
          "sequence": 4,
          "category": "relationship",
          "name": "belongsTo",
          "type": "Inquiry",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Category",
      "entry": false,
      "x": 107,
      "y": 175,
      "width": 222,
      "height": 258,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "title",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 2,
          "category": "attribute",
          "name": "description",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Tag",
      "entry": false,
      "x": 107,
      "y": 175,
      "width": 222,
      "height": 258,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "title",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 2,
          "category": "attribute",
          "name": "description",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "PhoneNumber",
      "entry": false,
      "x": 545,
      "y": 364,
      "width": 149,
      "height": 78,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "number",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Email",
      "entry": false,
      "x": 775,
      "y": 364,
      "width": 105,
      "height": 78,
      "items": []
    },
    {
      "name": "Registration",
      "entry": false,
      "x": 250,
      "y": 50,
      "width": 150,
      "height": 100,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "name",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Country",
      "entry": false,
      "x": 250,
      "y": 50,
      "width": 150,
      "height": 100,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "name",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Address",
      "entry": false,
      "x": 0,
      "y": 0,
      "width": 200,
      "height": 400,
      "items": [
        {
          "sequence": 2,
          "category": "attribute",
          "name": "city",
          "type": "String",
          "essential": false,
          "sensitive": false
        },
        {
          "sequence": 3,
          "category": "attribute",
          "name": "street",
          "type": "String",
          "essential": false,
          "sensitive": false
        },
        {
          "sequence": 4,
          "category": "attribute",
          "name": "number",
          "type": "String",
          "essential": false,
          "sensitive": false
        },
        {
          "sequence": 5,
          "category": "attribute",
          "name": "zip",
          "type": "String",
          "essential": false,
          "sensitive": false
        }
      ]
    },
    {
      "name": "StreetDetails",
      "entry": false,
      "x": 250,
      "y": 350,
      "width": 150,
      "height": 100,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "details",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Street",
      "entry": false,
      "x": 250,
      "y": 350,
      "width": 150,
      "height": 100,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "name",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "ZIP",
      "entry": false,
      "x": 250,
      "y": 200,
      "width": 150,
      "height": 100,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "code",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Inquiry",
      "entry": true,
      "x": 107,
      "y": 175,
      "width": 222,
      "height": 258,
      "items": [
        {
          "sequence": 2,
          "category": "attribute",
          "name": "title",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 3,
          "category": "attribute",
          "name": "description",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 4,
          "category": "attribute",
          "name": "category",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 5,
          "category": "attribute",
          "name": "branch",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 6,
          "category": "attribute",
          "name": "publishingDate",
          "type": "DateTime",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 7,
          "category": "attribute",
          "name": "expirationDate",
          "type": "DateTime",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 9,
          "category": "attribute",
          "name": "deliveryLocation",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 10,
          "category": "relationship",
          "name": "providerCriteria",
          "type": "ProviderCriteria",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 13,
          "name": "status",
          "category": "attribute",
          "type": "InquiryStatus",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "InquiryStatus",
      "entry": false,
      "x": 107,
      "y": 677,
      "width": 222,
      "height": 91,
      "items": [
        {
          "sequence": 1,
          "category": "identifier",
          "name": "status",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "ProviderCriteria",
      "entry": false,
      "x": 107,
      "y": 677,
      "width": 222,
      "height": 91,
      "items": [
        {
          "sequence": 1,
          "category": "attribute",
          "name": "deliveryLocation",
          "type": "Address",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 1,
          "category": "attribute",
          "name": "radius",
          "type": "int",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 1,
          "category": "attribute",
          "name": "companyType",
          "type": "CompanyType",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 1,
          "category": "attribute",
          "name": "companySize",
          "type": "CompanySize",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "Company",
      "entry": true,
      "x": 775,
      "y": 79,
      "width": 133,
      "height": 91,
      "items": [
        {
          "sequence": 2,
          "category": "attribute",
          "name": "name",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 3,
          "category": "attribute",
          "name": "role",
          "type": "CompanyRoleAtSom",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 4,
          "category": "attribute",
          "name": "address",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 3,
          "category": "attribute",
          "name": "uidNumber",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 4,
          "category": "attribute",
          "name": "registrationNumber",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 5,
          "category": "attribute",
          "name": "numberOfEmployees",
          "type": "String",
          "essential": true,
          "sensitive": false
        },
        {
          "sequence": 6,
          "category": "attribute",
          "name": "websiteUrl",
          "type": "String",
          "essential": false,
          "sensitive": false
        }
      ]
    },
    {
      "name": "CompanyRoleAtSom",
      "entry": false,
      "x": 995,
      "y": 79,
      "width": 164,
      "height": 91,
      "items": []
    },
    {
      "name": "CompanyType",
      "entry": false,
      "x": 775,
      "y": 490,
      "width": 133,
      "height": 103,
      "items": [
        {
          "sequence": 1,
          "category": "identifier",
          "name": "type",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    },
    {
      "name": "CompanySize",
      "entry": false,
      "x": 995,
      "y": 490,
      "width": 164,
      "height": 103,
      "items": [
        {
          "sequence": 1,
          "category": "identifier",
          "name": "size",
          "type": "String",
          "essential": true,
          "sensitive": false
        }
      ]
    }
  ],
  "lines": [
    {
      "box1Name": "Offer",
      "box2Name": "Attachment",
      "box1box2Name": "attachments",
      "box1box2Min": "0",
      "box1box2Max": "N",
      "box2box1Name": "offer",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "relationship",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": true
    },
    {
      "box1Name": "User",
      "box2Name": "Company",
      "box1box2Name": "company",
      "box1box2Min": "1",
      "box1box2Max": "1",
      "box2box1Name": "employees",
      "box2box1Min": "0",
      "box2box1Max": "N",
      "category": "relationship",
      "internal": false,
      "box1box2Id": true,
      "box2box1Id": false
    },
    {
      "box1Name": "User",
      "box2Name": "PhoneNumber",
      "box1box2Name": "phoneNumber",
      "box1box2Min": "0",
      "box1box2Max": "1",
      "box2box1Name": "owner",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "relationship",
      "internal": false,
      "box1box2Id": true,
      "box2box1Id": false
    },
    {
      "box1Name": "User",
      "box2Name": "Email",
      "box1box2Name": "email",
      "box1box2Min": "1",
      "box1box2Max": "1",
      "box2box1Name": "owner",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "relationship",
      "internal": false,
      "box1box2Id": true,
      "box2box1Id": false
    },
    {
      "box1Name": "Offer",
      "box2Name": "Provider",
      "box1box2Name": "provider",
      "box1box2Min": "1",
      "box1box2Max": "1",
      "box2box1Name": "offers",
      "box2box1Min": "0",
      "box2box1Max": "N",
      "category": "relationship",
      "internal": false,
      "box1box2Id": true,
      "box2box1Id": false
    },
    {
      "box1Name": "Category",
      "box2Name": "Tag",
      "box1box2Name": "tag",
      "box1box2Min": "0",
      "box1box2Max": "N",
      "box2box1Name": "category",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "twin",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": false
    },
    {
      "box1Name": "Category",
      "box2Name": "Tag",
      "box1box2Name": "category",
      "box1box2Min": "0",
      "box1box2Max": "N",
      "box2box1Name": "tag",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "twin",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": false
    },
    {
      "box1Name": "Address",
      "box2Name": "Country",
      "box1box2Name": "country",
      "box1box2Min": "1",
      "box1box2Max": "1",
      "box2box1Name": "addresses",
      "box2box1Min": "0",
      "box2box1Max": "N",
      "category": "relationship",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": false
    },
    {
      "box1Name": "Inquiry",
      "box2Name": "User",
      "box1box2Name": "buyer",
      "box1box2Min": "1",
      "box1box2Max": "1",
      "box2box1Name": "inquiries",
      "box2box1Min": "0",
      "box2box1Max": "N",
      "category": "relationship",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": false
    },
    {
      "box1Name": "Inquiry",
      "box2Name": "ProviderCriteria",
      "box1box2Name": "inquiry",
      "box1box2Min": "0",
      "box1box2Max": "1",
      "box2box1Name": "provider",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "relationship",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": true
    },
    {
      "box1Name": "Inquiry",
      "box2Name": "Attachment",
      "box1box2Name": "attachments",
      "box1box2Min": "0",
      "box1box2Max": "N",
      "box2box1Name": "inquiry",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "relationship",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": true
    },
    {
      "box1Name": "Inquiry",
      "box2Name": "Offer",
      "box1box2Name": "offers",
      "box1box2Min": "0",
      "box1box2Max": "N",
      "box2box1Name": "inquiry",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "relationship",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": true
    },
    {
      "box1Name": "Company",
      "box2Name": "Category",
      "box1box2Name": "branches",
      "box1box2Min": "1",
      "box1box2Max": "N",
      "box2box1Name": "companies",
      "box2box1Min": "1",
      "box2box1Max": "1",
      "category": "relationship",
      "internal": false,
      "box1box2Id": false,
      "box2box1Id": false
    }
  ]
}
''';
  