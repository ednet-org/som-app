# 

[**Buyer**](#buyer)	**[2](#buyer)**

[Registration](#registration)	[2](#registration)

[Login](#login)	[6](#login)

[Logout](#logout)	[6](#logout)

[Password Change (Forgot)](#password-change-\(forgot\))	[6](#password-change-\(forgot\))

[Change Role between Buyer and Provider user](#change-role-between-buyer-and-provider-user)	[7](#change-role-between-buyer-and-provider-user)

[Creation of Users](#creation-of-users)	[7](#creation-of-users)

[Editing of users and company details](#editing-of-users-and-company-details)	[8](#editing-of-users-and-company-details)

[Deletion of users](#deletion-of-users)	[8](#deletion-of-users)

[Inquiry creation](#inquiry-creation)	[9](#inquiry-creation)

[Automatic email notification for new offers](#automatic-email-notification-for-new-offers)	[10](#automatic-email-notification-for-new-offers)

[Offer management](#offer-management)	[10](#offer-management)

[Inquiry Navigation (Filtering)](#inquiry-navigation-\(filtering\))	[11](#inquiry-navigation-\(filtering\))

[Ads Management](#ads-management)	[12](#ads-management)

[Statistics](#statistics)	[13](#statistics)

[Menu](#menu)	[14](#menu)

[**Provider**](#provider)	**[15](#provider)**

[Registration](#registration-1)	[15](#registration-1)

[Login](https://docs.google.com/document/d/12ASaG8pwNoyDQdVfiqsrwDEVNbd-1-APTAmij8D915s/edit#heading=h.1byx4jpotxok)	[16](https://docs.google.com/document/d/12ASaG8pwNoyDQdVfiqsrwDEVNbd-1-APTAmij8D915s/edit#heading=h.1byx4jpotxok)

[Logout](#logout-1)	[16](#logout-1)

[Password Change (Forgot)](#password-change-\(forgot\)-1)	[16](#password-change-\(forgot\)-1)

[Change between Buyer and Provider user](#change-between-buyer-and-provider-user)	[16](#change-between-buyer-and-provider-user)

[Creation of Users](#creation-of-users-1)	[16](#creation-of-users-1)

[Editing of Users and company details](#editing-of-users-and-company-details-1)	[16](#editing-of-users-and-company-details-1)

[Deletion of Users](#deletion-of-users-1)	[17](#deletion-of-users-1)

[Subscription Management](#subscription-management)	[17](#subscription-management)

[Cancelling subscription](#cancelling-subscription)	[17](#cancelling-subscription)

[Offer Creation](#offer-creation)	[18](#offer-creation)

[Inquiry Navigation (Filtering)](#inquiry-navigation-\(filtering\)-1)	[19](#inquiry-navigation-\(filtering\)-1)

[Ads Management](#ads-management-1)	[20](#ads-management-1)

[Statistics](#statistics-1)	[22](#statistics-1)

[Menu](#menu-1)	[22](#menu-1)

[**Consultant**](#consultant)	**[23](#consultant)**

[Login](#login-1)	[23](#login-1)

[Logout](#logout-2)	[23](#logout-2)

[Password Change (Forgot)](#password-change-\(forgot\)-2)	[23](#password-change-\(forgot\)-2)

[Consultant Creation](#consultant-creation)	[23](#consultant-creation)

[Provider or Buyer Creation](#provider-or-buyer-creation)	[24](#provider-or-buyer-creation)

[Provider or Buyer Churn](#provider-or-buyer-churn)	[24](#provider-or-buyer-churn)

[Inquiry Navigation](#inquiry-navigation)	[25](#inquiry-navigation)

[Ads Management](#ads-management-2)	[27](#ads-management-2)

[Statistics](#statistics-2)	[27](#statistics-2)

[Menu](#menu-2)	[28](#menu-2)

[**Consultant Admin**](#consultant-admin)	**[29](#consultant-admin)**

[Consultant Creation](#consultant-creation-1)	[29](#consultant-creation-1)

[Providers management](#providers-management)	[29](#providers-management)

[Subscription Management](#subscription-management-1)	[29](#subscription-management-1)

[**\-----------------------------------------------**](#-----------------------------------------------)	**[30](#-----------------------------------------------)**

[**Deletion of users and companies**](#deletion-of-users-and-companies)	**[30](#deletion-of-users-and-companies)**

[**System Admin**](#system-admin)	**[30](#system-admin)**

[**Languages**](#languages)	**[30](#languages)**

[**Static Pages**](#static-pages)	**[30](#static-pages)**

[**Email Templates**](#email-templates)	**[30](#email-templates)**

[Hosting](#hosting)	[30](#hosting)

# 

# 

# User Stories V2

# Buyer {#buyer}

## Registration {#registration}

**Precondition**: user has a valid e-mail address.  
As a new user, I want to create a new account so that  I can log in. I can choose between or both of 2 accounts-options: buyer and provider.

**Entering company details**

If I want to register as a buyer, I have to fill in the following mandatory fields:

* Company name  
* Address (Street, ZIP, City)  
* UID Number  
* Company registration number (Firmenbuchnummer)  
* Number of Employees (Dropdown \- 0-10, 11-50, 51-100, 101-250, 251-500, 500+)


Optional

* Website URL (system must validate that is really a URL)


  
	  
**Creating Users**

When registering the company, (multiple) user accounts can be created in the process of the registration.  
At least one user account must be created for the admin.  
When button “create user” is clicked, following fields have to be filled in:

* E-mail (mandatory)  
* Telephone  
* First Name (mandatory)  
* Last Name (mandatory)  
* Title  
* Role (mandatory)  
  * Buyer (only if buyer account is already chosen)  
  * Admin  
* Salutation (mandatory)


If e-mail that is already registered in the system is entered, an error message is shown.  
E.g. “E-mail already used.”  
	  
	  
At the end user has the option as a checkbox to accept  terms and conditions.   
		a) General terms and conditions  (AGBs) \+ link to the document  
		b) Privacy policy (Datenschutz) \+ link to the document  
		

Only if both are checked can the user click on the “complete/submit registration” button.

All users (admin and other roles) receive registration email with a URL.   
URL  has expiry date (TBD \- take standard).  After the expiry date all inactive users will automatically be deleted from the system.

The expiry date is to be defined. E.g. the expiry date is 2 weeks, there should be a notification to the user and the admin a few days in prior to remind them that the link is going to expire. 

If a user clicks on the expired link, the registration should not be possible and the message is shown “Expired link, please contact the admin for new registration”.

When a link is clicked the user is redirected to a page to define the password.   
The page contains two fields: password & confirm password (re-enter)  
Once this is submitted, the user's account is activated in the system.   
Users are automatically logged in and redirected to homepage.

If entered passwords don't match, an  error is displayed “Passwords don’t match” and the user is prompted to enter them again.

It is mandatory to define an admin user. It is not possible to delete an admin user without first creating another admin user or defining an existing one as admin.

## 

## Login {#login}

**Precondition**: registered user (Buyer)  
As a user I want to log in with email and password, so that I get the valid session to use the website.

When invalid e-mail or password are entered error message is shown “Invalid password or E-Mail”  
When E-Mail and password are correct, user is redirected to homepage (Profile Avatar is shown with first and last name)  
If a user forgot his password, he can change it by clicking on the “forgot your password” button. This button is shown on the login page   
Registration button is also shown on  this page.

## Logout {#logout}

**Precondition**: user is logged in.  
As a user I want to log out, so that my session is closed.   
As a user I can press the log out button on the right corner  
When the button is pressed, I am redirected back to the Homepage.

## Password Change (Forgot) {#password-change-(forgot)}

**Precondition**: user has a valid account.  
As a user, I want to be able to change my password in the case I forgot it, so that I can keep my account.  
If a user forgot his password, he can change it by clicking on the “forgot your password” button. This button is shown on the login page   
As a user I press the “forgot my password” button, so I am redirected to a page in which I have to enter my email address. When I have entered my email address, I receive an email with a link to change my password. After clicking this link, I am redirected to a page in which I have to enter my new password and confirm it again  
When I confirmed the new password I will log in and redirected to the homepage

## 

## Change Role between Buyer and Provider user {#change-role-between-buyer-and-provider-user}

**Precondition**: user has a valid account and has both buyer and provider role.

It is possible to register an email address as a buyer as well as a provider. Once this has been done, the logged in buyer can click on the button "switch to seller portal" in the menu and he will be redirected to the home page of a logged in provider without having to log in again. This menu item only exists for users who are registered with their email address as both buyer and provider. Also the other way around should work, with the option “switch to buyer portal”.  
When logging in, system checks what was the role that was used at the last login and uses this as default.

## Creation of Users {#creation-of-users}

**Precondition**: user has valid admin account and is logged in. (Role Buyer)  
As an admin, I want to be able to create users’ accounts for my company, so they can create inquiries or leads. 

I have the option of creating additional users for my company profile. In order to create another user I have to click on the “User Management” menu. Then I will be redirected to the page where I can see all registered users in list form with the fields provided in list below. Here I have buttons to edit users and to delete users ( pen and trash symbol next to each user). Below there is "Add new user" button to create a user. If I click on this, the following fields appear which are required to create an user:

* E-mail address,   
* Role: admin or buyer,   
* First name,  
* Surname,  
* Title,   
* Salutation 


After I have entered everything so far, I click on the "Create user" button and the new user will receive an email containing a link to create a new password for this user. Here he has to enter his new password twice and then click the "Save password" button. He is then immediately logged in and forwarded to the homepage

## Editing of users and company details {#editing-of-users-and-company-details}

**Precondition**: user has valid admin account and is logged in. (Role Buyer)  
As a user/admin, I can press the pen symbol next to the list of users and change my data. 

As a normal user, I can change the following fields.

* First name,  
* Surname,  
* Telephone  
* Title,   
* Salutation 

As an admin, I can in addition change the role of the user. 

If I have changed it, I can press the save button next to the list and the user is updated  
As an admin, I see all users and can change it, as a user I only see my user profile and can change it

As an admin, I can change the company details in the “Company Management” menu.  

## Deletion of users {#deletion-of-users}

**Precondition**: user has a valid admin account. (Role Buyer)

If I am logged in as admin, I have the option of deleting one or more users from my company profile. To delete a user, I have to click the "User Management" button in the menu as admin.  All active users are displayed. A trash icon for deleting the user is displayed next to each active user. When I click this symbol for a user, I am asked whether I really want to delete the user. Now I can confirm the process with YES or cancel it with NO. When I proceed with yes, the site will refresh and the user is deleted. When I cancel this progress the confirmation window disappears and everything stays as it was before.

The user is not deleted from the database but marked as inactive. All offers/inquiries stay in the system unchanged. The user is not allowed to log in anymore with the email address.

## Inquiry creation {#inquiry-creation}

**Precondition**: user has valid admin or buyer account and is logged in. (Role Buyer)

As a buyer, I want to create inquiry so that I can receive offers for it. 

Buyer has a button “New Inquiry” on his dashboard/Main page. 

As soon as I have clicked on this, I will be redirected to the page on which I can create my inquiry. 

On this page I have to fill in the following fields: 

* Branch and category from the list of existing branches/categories of the inquiry and can add products which are in the form of tags and he can choose existing ones or define new ones. This list is saved per account and not shared between buyers/providers.  
* Deadline for offers (mandatory field): calendar view to choose, minimum 3 (configurable) work days in future  
* ZIP Code(s) of delivery places (mandatory field): text field, comma separated  
* Number of providers (mandatory field): dropdown (1-10)

Optionally there is

* Description field: text field, maximum number of characters to be defined  
* Option to upload one PDF file. 

  If I click the "Add file" button, a window appears in which I can upload the desired PDF. Then I click the "Add" button to upload the file or click the "x" on the right at the top of the window to cancel this process and the window closes in both cases.


Optional Provider Criteria: 

* Provider ZIP Code (optional), one ZIP, autocomplete with valid Austrian ZIPs  
* Max Radius from provider location, can be filled only if Provider ZIP is entered, dropdown (no limit, 50km, 150km, 250km)  
* Provider type   
  * Dropdown: Händler, Hersteller, Dienstleister, Großhändler

    

* Company size:  (Dropdown \- 0-10, 11-50, 51-100, 101-250, 251-500, 500+)


  

Automatically user data is shown (as contact info)

* Company name (will be filled in automatically and can’t be changed )  
* Salutation, title, first name, surname, telephone number and email address of the contact person (will be filled in automatically and can all  be edited by simply entering text)

At the end of the page there is a “Cancel” button that when clicked redirects the user to homepage. 

Once I have filled all mandatory fields, I have the option to proceed with sending the inquiry by clicking on a button (e.g. “Create inquiry”). If I click on that button I get an overview of the inquiry with a button “Send inquiry”. In the upper right corner of the overview is a “X” sign.  

When I click on the "Send inquiry" button, a window appears with a  message with info that the inquiry has been forwarded for processing and I am automatically forwarded to the homepage.   
Consultants get email with a link to the new inquiry.

If I click the "X" sign, the overview will be closed and the user is back to inquiry creation. 

## 

## Automatic email notification for new offers {#automatic-email-notification-for-new-offers}

As a buyer I want to be notified when there are new offers for my inquiries. 

As soon as the number of offers reached the number that buyer choose at inquiry creation or   
The deadline for offers  has been reached (17.00 CET) the buyer will receive an automatic email with the link to the inquiry and its offers.   
When the user clicks on the link it is forwarded to the inquiry view. 

## Offer management {#offer-management}

**Precondition**: user has valid buyer account and is logged in (Role Buyer)

As a buyer, I will receive a link by email which will forward me to the offers assigned to my inquiry. If I click the link I will be forwarded to the view which shows the inquiry and the offers and have the opportunity to download the PDFs that provider uploaded in the offer

Users are also forwarded to this view via the menu “My Inquiries” , by selecting a specific offer. 

Inquiry data that is shown  
	Id  
	Status (Open/Closed)  
	Inquiry creator  
	Branch  
	Deadline  
	Creation date

When clicked on inquiry Offers are dropped down with following  data  
		Id  
		PDF  
		Provider Name	  
		Status (Accepted/Open/Rejected)   
Date when the offer has been forwarded to the buyer  
Date when the offer has been resolved by buyer (accepted/rejected)

		  
Next to each offer there are two buttons "reject" and "accept". If I click on "reject", the provider will be contacted by email with a rejection (and link to the offer). If I click on "accept", the provider will be contacted with a confirmation (and link to the offer). 

If the offer has been accepted the email will also contain contact details of the buyer. By this provider and buyer are able to agree on the next steps (contract, agreement, ...) with one another. 

	

## Inquiry Navigation (Filtering) {#inquiry-navigation-(filtering)}

**Precondition**: user has valid buyer account. (Role Buyer)

As a buyer, I can click on "my or all Inquiries" in the menu and see all previous inquiries. 

I can filter the following areas here:

* Status (Open/Closed). This is a drop down.   
* Editor (this point is only visible for admin). This is the buyer that created the inquiry. The admin gets here a list of all users and he can select one or multiple for filtering.   
* Branch: this is either a free text or a list of in system already saved branches. Developers to decide.   
* Provider type (Händler, Hersteller, Dienstleister, Großhändler)  
* Creation Date: Timespan. E.g. 1.10.2020-1.11.2020 or since 1.10.2020.   
* Provider size: Drop down, defined values in previous user stories.  
* Deadline: Timespan. E.g. all inquiries that have a deadline between 1.10.2020 and 1.11.2020 should be filtered.

When each filter is chosen, it is preferable that the number of inquiries that match is shown, for multiple filters the number should reflect the inquiries that match all filters. This is nice to have, not a must. 

It is open whether the list will be automatically updated as soon as one filter is changed or there should be an additional button, which when clicked will deliver the updated list.

The list of inquiries is shown if there are matching results and users can click on one inquiry to get a detailed view of it. 

Each row in the list shows following fields:  
Id  
Status (Open/Closed)  
Inquiry creator  
Branch  
Deadline  
Creation date  
	

When clicked on one Inquiry its overview with all filled fields at the creation and uploaded documents is shown. There is also option to click on “Offers” to provide following details of each offer of the inquiry:

		Id  
		PDF  
		Provider Name	  
		Status (Accepted/Open/Rejected)   
		Date when the offer has been forwarded to the buyer  
Date when the offer has been resolved (accepted/rejected)

Next to each offer the user has the option to download the PDF.

I also have the option to export the list of inquiries. This is exported to a .csv file with all the fields that are shown in the list view, additionally with offers and their details, but without PDF. 

## Ads Management {#ads-management}

As a buyer I see a banner slideshow on top of the page.   
As a buyer I see a banner slideshow on the right side of the page.  
As a buyer I have an option to see all active ads.  
As a buyer I can filter list of ads by branch.  
When a buyer clicks on an ad, a new tab to an ad link is opened.

## Statistics {#statistics}

Precondition: user has valid admin/user account. (Role Buyer)  
As a buyer, I can click on “statistics” in the menu to view my inquiry statistics. As a user I only see mine and as an admin I see all the users from the registered company. I have the following filter options:

* Period: timespan  
* Editor (only for admin): the person that created inquiries. This is a list where one or multiple or all users can be chosen.

The bar chart is created that shows the number of closed/open inquiries for chosen user(users). 

Example:   
![][image1]

There is no summed up view, there is always  a bar for a user. If all users are chosen in filtering then the bar is displayed for each one.

I also have the option of exporting the statistics to Excel. This should be a .csv file. The file contains following columns:  
	Email address  
	Number of open inquiries  
	Number of closed inquiries  
	  
If the bar chart is for the whole company, then the email address is not shown in the exported file.

## Menu {#menu}

As a normal  user I have the following menu items in the header:

* Inquiries  
  * All inquiries  
  * Statistics  
      
* SOM Ads  
* My Profile  
  * Logout  
    

Additionally, there is a button “New Inquiry” that is placed separately that when clicked leads to the inquiry creation.

As admin I have in addition the following menu items in the header:

* User management  
  * Company management  
  * 

# Provider {#provider}

## Registration {#registration-1}

*See Registration for Buyer. Everything applies and following additionally for the provider.*

If I want to register as a provider , I have to fill in additionally following mandatory fields:

**Branch**

Branch designation has the following structure: **branch/category/product** where **branch** and **category** are required. 

User can choose from a list of predefined branches and categories  
For the branches/categories that were already added to the system, auto-completion should work. 

If there is no suitable branch or category, the user can define additional ones and. This makes registration not complete but in “Pending” status. Users will get email same is normal in registration but with info that company is not yet fully registered. Email is triggered and sent to the consultants to review the branch/category. In the email there is a link that leads to the list of the existing branches/categories and shows the newly requested one. Consultant has options:

* to  confirm the category which triggers the completing the registration  
  * Users get email that registration is completed  
* To update the category which also leeds to completing the registration  
  * Users get email that registration is completed  
* To decline the category which will leave the registration in “Pending”  
  * Users get an email that registration is not completed because the category has been declined.

Companies that have “pending” registration can login but cannot receive inquiries.

**Bank details (for subscriptions)**

* IBAN  
  * BIC/SWIFT  
  * Account owner (Kontoinhaber): Name and Last Name  
* Payment Interval  
  * Monthly, yearly

**Subscriptions**

If the provider account is chosen, the user must choose the subscription model before completing the registration. 

| SOM Standard |  |  | SOM Premium |  |  | SOM Enterprise |  |  |
| :---- | ----- | ----- | :---- | ----- | ----- | :---- | ----- | ----- |
|   \- keine Werbeanzeigen bei SOM Ads  \- 1 Benutzer anlegen  \- Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser |  |  |   \- 1 Werbeanzeige pro Monat bei SOM Ads für min zwei Wochen (Mo-So)  \- bis zu 5 Benutzer anlegen  \- Detaillierte Statistik mit Exportmöglichkeit  \- Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser  \- die ersten zwei Monate Gratis |  |  |   \- 1 Werbeanzeige pro Monat bei SOM Ads für min zwei Wochen (Mo-So) \- 1 Banneranzeige pro Monat bei SOM Ads für einen Tag \- bis zu 15 Benutzer anlegen (jeder weitere Benutzer kostet €10,-) \- Detaillierte Statistik mit Exportmöglichkeit  \- Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser  \- die ersten zwei Monate Gratis |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
| Einrichtungspauschale € 49,- |  |  | Einrichtungspauschale entfällt |  |  | Einrichtungspauschale entfällt |  |  |
| € 39,90 / Monat |  |  | 79,90 / Monat |  |  | € 149,90 / Monat |  |  |

These subscriptions models are not fixed. I.e. the prices could change. 

## 

## Login

*See Login for Buyer. Everything applies for providers as well.*

## Logout {#logout-1}

*See Logout for Buyer. Everything applies for providers as well.*

## Password Change (Forgot) {#password-change-(forgot)-1}

*See Password Change for Buyer. Everything applies for providers as well.*

## Change between Buyer and Provider user {#change-between-buyer-and-provider-user}

*See Change between Buyer and Provider user  for Buyer. Everything applies for providers as well*

## Creation of Users {#creation-of-users-1}

*See Creation of Users for Buyer. Everything applies for providers as well.*

## Editing of Users and company details {#editing-of-users-and-company-details-1}

*See Editing of Users for Buyer. Everything applies for providers as well.*

## Deletion of Users {#deletion-of-users-1}

*See Deletion of Users for Buyer. Everything applies for providers as well.*

## Subscription Management {#subscription-management}

Precondition: user has valid admin account. (Role Provider)

If I am logged in as admin and the company is registered as a provider, I have the option of editing or viewing my subscription. For this, I as admin have to click on the "Company Management" menu. Then I will be redirected to the page where I can see all my data and those of the company.   
My subscription package, date of the company registration and the company details are displayed here. A pen symbol for editing the company data is displayed next to the details. A pen symbol for upgrading is also displayed with the subscription package. A downgrade is only possible three months before the end of the commitment. If I click this symbol for the subscription package, the package to which I can switch is displayed. An upgrade of the package is only possible at the beginning of the next month. As soon as I choose a new package, the contract is extended by one year. When I have decided on the new package, I have to tick the terms and conditions and click the "Upgrade" button. After I click on this button, I am redirected to the "Company management" page and the new subscription package including the start date can be seen.

	Payment  
Precondition: user has valid admin account. (Role Provider)  
TBD

	Billing  
Precondition: user has valid admin account. (Role Provider)  
TBD

## Cancelling subscription {#cancelling-subscription}

Note: this is not a functionality of SOM; must be done via email.

The admin of a registered company can cancel his subscription at the end of the contract. However, the termination must be in writing by email three months before the end of the commitment. If there is no termination three months before the end of the commitment, the contract is automatically extended for another year. In the event of termination, the consultants manually send a confirmation of termination to the admin by email. The company profile is then deleted from the SOM platform by the consultants. This is described under Provider churn for the consultants.

##  Offer Creation {#offer-creation}

Precondition: user has valid admin/user account and has received inquiry. (Role Provider)

As a provider I want to be able to create offers for the inquiries I have received.

Only admins receive email with a link with newly forwarded inquiry to my company.  
Users only see assigned inquiries to them in My Inquiries menu. Admins see all inquiries.

When I click on an inquiry (either from the menu “My Inquiries” or from a link from the email) I  see an inquiry overview (defined in Inquiry navigation, see below) and have the option to upload my offer via the SOM platform. Additionally if I am an admin, I have an option to assign the inquiry to one user (From the list of all company users).

Next to the inquiry there are two buttons "Upload offer", “I don’t want to make an offer". If I click on "Upload offer", a window appears in which I can drag the offer in PDF format. Once I have done that, I can either click the "Upload" button (the window closes and the page is updated) or I click the "x" in this window to cancel the process (the window also closes here). 

After I have uploaded the offer, the status of this request is updated from "open" to "offer uploaded" and I receive a "Thank you for your offer" message.

## Inquiry Navigation (Filtering) {#inquiry-navigation-(filtering)-1}

Precondition: user has valid admin/user account. (Role Provider)

As a provider I want to be able to manage my inquiries.

As a provider, if I am logged in, I can choose  “My inquiries” to manage all inquiries sent to me in a form of a list. Each row in the list shows following fields:

* Id  
* Company name  
* Status (Open/Offer Created/Lost/Won/Ignored)  
* Deadline

As an admin, I will receive an email with the link to the inquiry whenever a consultant forwards an inquiry.  
   
Inquiry overview (when clicked on inquiry) shows following data

* Buyer data  
  * Company Name  
  * Contact Person: Name, Last Name, Title, Salutation  
  * Telephone  
  * Email  
* Inquiry  
  * Id  
  * PDF file  
  * Description  
  * Deadline  
  * Delivery address  
  * Editor (this point is only visible for admin), this is the provider that inquiry is assigned to  
  * Status (Open/Offer Created/Lost/Won/Ignored)

	  
Inquiries that have status Open have additionally two buttons "Upload offer", “I don’t want to make an offer" (see Offer Creation, the logic is the same.)	

The list of inquiries can be filtered by the following fields:

* Status: Status (Open/Offer Created/Lost/Won/Ignored)  
* Editor (this point is only visible for admin), this is the provider that inquiry is assigned to  
* Deadline: timespan

I also have the option to export the list of inquiries in .csv format. Columns that are exported:  
	

* Id  
* Company name  
* Status (Open/Offer Created/Lost/Won/Ignored)  
* Deadline  
* Editor

## Ads Management  {#ads-management-1}

Precondition: user has valid admin account. (Role provider)

As a provider I want to have the possibility to create ads so that they can be displayed to the users. 

As a provider (admin) I have the possibility to click on "SOM Ads" in the header and then on button "Create Ad". If I clicked on it, I will be forwarded to the one in which I have to fill out the following points.

* Ad type: banner or normal ad. Banner is for available for enterprise providers  
* For banners (enterprise): Day on which the ad will be displayed to the users. The platform suggests available slot according to already existing ads. (mandatory)  
* For normal ads: Period in which the ad will be displayed to the users. The maximum is defined by the system, see below(mandatory)  
* Branch: mandatory  
* URL (own homepage) (mandatory)  
* Image for the ad : format and resolution must be conform to the the fix defined format and resolution   
* For normal ads only: Headline of the ad (mandatory)  
* For normal ads only: Short description of the ad (number of maximum characters to be defined)  
* Status: active or draft 

Once I have filled out everything I need to, I click on the "Create Ad" button below. Now the consultant receives an email with a link to the ad in SOM.

I can also see the ads that have already expired or the ads that are still active by clicking on "SOM Ads" in the header and then on "All ads". I will be redirected to the page where I can see all the ads and have the following filter options:

* Status (draft, expired and active ads)  
* Expiry Date (time range)  
* Type of ad: banner or normal add (only VIP Partner)

The ads are displayed in a list. 

User can click on an ad and has the following possibilities: 

- Reactivate: an ad that is already expired can be activated if users enter a new time period. The system must prove when the user has the next time slot available.    
- Activate: if the ad is in draft status, the time period must be in future   
- Deactivate: ad that is active can change status to draft   
- Delete: ad can be deleted at any time   
- Update: all fields besides the time period can be updated. If the ad has a status draft time period can also be updated according to the next available time slot for the user. 

If a user reactivated or activated the ad an automatic email is sent to the consultants.

**Banner**

There is a maximum number of slots in the banner that ads can be assigned to.   
This number is going to be hard-coded (proposal: 5-10)  
One slot is valid for one whole day.  
The ads in the banner are shown in slide show sorted by the creation date (newest \-\> oldest)  
When creating the banner the customer can choose only one slot in the month if there is one available. 

**Normal ad**

There is no maximum number of slots here.  
One provider can activate max one ad (besides banner) per month,  
Every ad has an expiry date. (proposal : 2 weeks)  
The ads are sorted by the creation date (newest \-\> oldest)

## Statistics {#statistics-1}

Precondition: user has a valid admin/user account. (Role Provider)  
As a provider, I can click on "Statistics" in the menu to display my inquiry statistics. As a user I only see mine and as an administrator, I see all registered users. 

The statistics are displayed as a bar  chart and I have the following filter options:

* Status: Status (Open/Offer Created/Lost/Won/Ignored)  
* Period: Time range (Calendar view to choose from)  
* Editor (only for admin): the user that created the offer.


A bar chart is created that shows the number of Open/Offer Created/Lost/Won/Ignored inquiries for chosen users(users). See Statistics for Buyer, same layout but more columns.  

I also have the option of exporting the statistics to Excel. This should be a .csv file. The file contains the following columns:  
	Email address  
	Number of open inquiries  
	Number of offer created inquiries  
	Number of lost inquiries  
	Number of won inquiries  
	Number of ignored inquiries  
If the bar chart is for the whole company, then the email address is not shown in the exported file.

## Menu {#menu-1}

Precondition: user has a valid admin/user account. (Role Provider)  
As a normal  user I have the following menu items in the header:

* Inquiries  
  * All inquiries  
  * Statistics  
* My Profile  
  * Logout

As admin I have in addition the following menu items in the header:

* User management  
  * Company management  
  * SOM Ads Management

# 

# 

# Consultant {#consultant}

## Login {#login-1}

*See Login for Buyer. Everything applies for a consultant as well.*

## Logout {#logout-2}

*See Logout for Buyer. Everything applies to a consultant as well.*

## Password Change (Forgot) {#password-change-(forgot)-2}

*See Password Change for Buyer. Everything applies to a consultant as well.*

## Consultant Creation  {#consultant-creation}

As a consultant, I want to be able to create other users with the role \- consultant. 

In User Management I have the option to create a consultant when I click on “Add new consultant”.

If I click on this, the following fields appear which are required to create a user:

* E-mail address,   
* First name,  
* Surname,  
* Title,   
* Salutation 

After I have entered everything so far, I click on the "Create user" button and the new user will receive an email containing a link to create a new password for this user. Here he has to enter his new password twice and then click the "Save password" button. He is then immediately logged in and forwarded to the homepage.

If there is already a user with this email in the system registered an error message will be displayed. 

## Provider or Buyer Creation {#provider-or-buyer-creation}

Precondition: user has a valid account. (Role Consultant)

As a consultant, I have the option of registering a provider/buyer by choosing the menu "Registered Companies" . In this case, a window opens in which I can click on the "Create provider/buyer" button. As soon as I click on this, I have to go through the same process that a provider/buyer has to go through. However, here I have the option of choosing a free subscription package for providers. In addition, there are no mandatory fields that have to be filled out for the consultants.   
An admin user must be created. This user will receive an email to enter the password same as in the registration process.

## Provider or Buyer Churn {#provider-or-buyer-churn}

Precondition: user has valid admin account. (Role Consultant)

The consultants can click on the "Registered Companies" button in the menu. As soon as this is clicked, the consultant is redirected to the page in which he can see all registered companies (buyers and providers). The companies are sorted alphabetically by the company name. It is also possible to filter the list of partners by the type: buyer and provider. 

There is also a search field in which I can search for a partner using a free text search for the name of the company. 

Next to each partner there is a pencil symbol to edit the buyer or provider and a trash can symbol to delete him. If I want to delete him, a window appears in which I can confirm the process with YES or cancel with NO. If I confirm with YES, the page is updated and the buyer or provider is deleted and the admin user gets a churn mail. If I cancel with No, this window disappears and the process is cancelled.

The company is not deleted but marked as inactive with all its users  in the database. 

## Inquiry Navigation {#inquiry-navigation}

Precondition: user has a valid account. (Role Consultant)

As a consultant I want to be able to manage the inquiries. 

As a consultant, I receive the link to newly created inquiries by email.   
Another option to get to the inquiries is via the header, there is a menu “Inquiry management” that leads to all inquiries. 

**Filtering**

Firstly, the company must be filtered by the name (free text search). 

I can filter then additionally by the:

* Status (Open/Closed). This is a drop down.   
* Editor: This is the buyer that created the inquiry. The consultant gets here a list of all users and he can select one or multiple for filtering.   
* Branch: this is either a free text or a list of in system already saved branches. Developers to decide.   
* Provider type (Händler, Hersteller, Dienstleister, Großhändler)  
* Creation Date: Timespan. E.g. 1.10.2020-1.11.2020 or since 1.10.2020.   
* Provider size: Drop down, defined values in previous user stories.  
* Deadline: Timespan. E.g. all inquiries that have a deadline between 1.10.2020 and 1.11.2020 should be filtered.

Each row in the list shows following fields:  
Id  
Status (Open/Closed)  
Inquiry creator  
Branch  
Deadline  
Creation date  
Offer creation date (if there is an offer already)  
Decision date (if the offer has been accepted/rejected)  
Assignment date (when the inquiry was forwarded to the providers)

Inquiry overview (when clicked on inquiry) shows following data

* Buyer data  
  * Company Name  
  * Contact Person: Name, Last Name, Title, Salutation  
  * Telephone  
  * Email  
* Inquiry  
  * Id  
  * PDF file  
  * Description  
  * Deadline  
  * Delivery address  
  * Providers: companies that the inquiry has been forwarded to 

There is also option to click on “Offers” to provide following details of each offer of the inquiry:

		Id  
		PDF  
		Provider Name	  
Provider editor : user  
	Buyer action (Accepted/Open/Rejected)   
Provider action (Open/Offer Created/Lost/Won/Ignored)  
	Date when the offer has been forwarded to the buyer  
Date when the offer has been resolved (accepted/rejected)

I also have the option to export the list of inquiries. This is exported to a .csv file with all the fields that are shown in the list view, additionally with offers and their details, but without PDF. 

If one inquiry is selected, if the status is open,  the consultant has the option to assign it to one or more providers.   
As soon as I click on it, a list of providers appears. There is also the option of various filters:

* Branch  
* Company size (Dropdown \- 0-10, 11-50, 51-100, 101-250, 251-500, 500+)  
* Provider type (Händler, Hersteller, Dienstleister, Großhändler)  
* Postcode City: e.g. if user enters “5” all providers should be listed who have ZIP starting with “5”  
* Number of received inquiries: range  
* Number of sent offers: range   
* Number of accepted offers: range  
* Claimed

The goal is to get this list of suggested providers automatically in the future. This is not part of the first version of software. 

The list shows following providers data

* Company Name  
* Branch  
* Company size  
* Provider type  
* Postcode  
* Claimed: yes/no   
* Number of received inquiries  
* Number of sent offers  
* Number of accepted offers

Next to each provider is a field that you can click to select. As soon as I have clicked on the provider(s) I want, I now have to click the "Forward inquiry" button  and all the selected providers will receive emails asking them to click the link which leads them to the inquiries in SOM. The inquiry gets then automatically saved the date when this assignment happened (Assignment date). 

## Branch Management

As a consultant I want to be able to manage existing branches and categories and add new ones.

There should be a menu for Branch Management where the list of existing ones is shown in table with columns

* Branch  
* Category

And option to delete existing ones and add new ones.

## Ads Management  {#ads-management-2}

Precondition: user has a valid account. (Role Consultant)

As a consultant, I want to be able to manage all ads in the system.

If the users clicks on "SOM Ads" in the header and then on "All ads" he will be redirected to the page where I can see all the ads and have the following filter options:

* Status (draft, expired and active ads)  
* Expiry Date  
* Company name (free text search)

The consultant has the same rights and possibilities with ads as a provider admin, with the difference that he can see the ads from all the companies. (See Provider/Ads Management for details)

## Statistics {#statistics-2}

Precondition: user has a valid account. (Role Consultant)  
As a consultant, I can click on "Statistics" in the menu to display all inquiry statistics for all registered companies. The statistics are displayed as a bar chart and I have the following fields to create the statistic for:

* Status  
  * Open inquiries (count of inquiries with no decision from buyer or without offers)  
  * closed inquiries (count of inquiries with decision from buyers)  
  * offers won (count)  
  * lost offers (count)

* Period (amount of inquiries per month \- 12 bars)  
* Provider type (amount of inquiries per defined types)  
* Provider size (amount of inquiries per defined sizes)

Fields can't be combined, only one bar chart is going to be created per field.

Additionally, I can enter a time period as a filter.

I also have the option of exporting the statistics to Excel. This should be a .csv file. The file contains the following columns:  
	If field “status”: status, count of inquiries  
	If fields “period”: month, count of inquiries  
	If fields “provider type”: provider type, count of inquiries  
	If fields “provider size”: provider size, count of inquiries

## Menu {#menu-2}

Precondition: user has a valid admin/user account. (Role Consultant)  
As a consultant I have the following menu items in the header:

* Inquiries  
  * All inquiries  
  * Statistics  
      
* SOM Ads  
* My Profile  
  * Logout  
* User Management  
* Ads Management  
* Buyer/Provider Management (Registered companies)

# Consultant Admin {#consultant-admin}

## Consultant Creation {#consultant-creation-1}

As a consultant admin I want to be able to create further consultant accounts.

## Providers management {#providers-management}

As a consultant admin I want to have the possibility to manage registered providers and their subscription. 

In menu “Providers management” I have an option to list all providers and see following  
	Company details  
Subscription package type  
Registration date  
Payment details  
IBAN  
	BIC/SWIFT  
	Kontoinhaber  
Payment Interval

Here I want to have the option to export this data in a .csv file.    

## Subscription Management {#subscription-management-1}

TBD

As a consultant admin I want to have the possibility to manage different subscription packages. 

In the menu “Subscription Management” I want to see all existing packages (limited to 3\)

Title  
Price  
Max number of users  
Max nr of normal ads in month  
Max nr of banners in month

# \----------------------------------------------- {#-----------------------------------------------}

# 

# Deletion of users and companies {#deletion-of-users-and-companies}

TBD: how can we delete users and companies completely from the system if they request it.

# System Admin {#system-admin}

There should be one created super consultant with default pwd and username that can create the following consultants. The username and pwd will be provided by the developers. 

# Languages {#languages}

German & English

# 

# Static Pages  {#static-pages}

	Content  
	Sitemaps  
	AGB & Datenschutz \- in googledrive

# Email Templates {#email-templates}

In googledrive

## Hosting {#hosting}

**TBD:**  
Data \- in cloud or on premise  
Sensitive customer data etc  


[image1]: <data:image/png;base64,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>