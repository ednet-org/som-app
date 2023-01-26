Bounded Contexts:

Inquiry Management
User Management
Company Management
Ads Management
Entities:

Inquiry
Offer
User
Company
Ad
Branch
Category
Value Objects:

Contact Person (Name, Last Name, Title, Salutation)
Telephone
Email
PDF
Description
Delivery Address
Provider Type (Händler, Hersteller, Dienstleister, Großhändler)
Company Size (0-10, 11-50, 51-100, 101-250, 251-500, 500+)
Postcode City
Status (Open/Closed/Offer Created/Lost/Won/Ignored/Draft/Expired/Active)
Action (Accepted/Rejected)
Time Period
Filter Options
Aggregates:

Inquiry Management Aggregate (Inquiry, Offer, User)
User Management Aggregate (User, Company)
Company Management Aggregate (Company)
Ads Management Aggregate (Ad)
Repositories:

Inquiry Repository
Offer Repository
User Repository
Company Repository
Ad Repository
Branch Repository
Category Repository
Services:

Inquiry Service
Offer Service
User Service
Company Service
Ad Service
Branch Service
Category Service
Statistics Service
Domain Events:

Inquiry Assigned to Provider Event
Offer Created Event
Inquiry Decision Made Event
Offer Accepted/Rejected Event
Application Services:

Inquiry Management Application Service
User Management Application Service
Company Management Application Service
Ads Management Application Service
Factories:

Inquiry Factory
Offer Factory
User Factory
Company Factory
Ad Factory
Controllers:

Inquiry Management Controller
User Management Controller
Company Management Controller
Ads Management Controller
User Interface:

Inquiry Management User Interface
User Management User Interface
Company Management User Interface
Ads Management User Interface