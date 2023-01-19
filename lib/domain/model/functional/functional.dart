// based on following requirements:
/*
# User Stories V2


# <span style="text-decoration:underline;">Buyer</span>


## Registration

**Precondition**: user has a valid e-mail address.

As a new user I want to create a new account, so that I can log in. I can choose between or both of 2 accounts-options: buyer and provider.

**Entering company details**

If I want to register as a buyer, I have to fill in the following mandatory fields:



* Company name
* Address (Street, ZIP, City)
* UID Number
* Company registration number (Firmenbuchnummer)
* Number of Employees (Dropdown - 0-10, 11-50, 51-100, 101-250, 251-500, 500+)

Optional



* Website URL (system must validate that is really a URL)



**Creating Users**

When registering the company, (multiple) user accounts can be created in the process of the registration.

At least one user account must be created for the admin. \
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

If e-mail that is already registered in the system is entered, an error message is shown. \
E.g. “E-mail already used.”

\


At the end user has the option as a checkbox to accept  terms and conditions.  \
a) General terms and conditions  (AGBs) + link to the document \
b) Privacy policy (Datenschutz) + link to the document \
\
\
Only if both are checked can the user click on the “complete/submit registration” button.

All users (admin and other roles) receive registration email with a URL.  \
URL  has expiry date (TBD - take standard).  After the expiry date all inactive users will automatically be deleted from the system. \


The expiry date is to be defined. E.g. the expiry date is 2 weeks, there should be a notification to the user and the admin a few days in prior to remind them that the link is going to expire.  \
\
If a user clicks on the expired link, the registration should not be possible and the message is shown “Expired link, please contact the admin for new registration”.

\
When a link is clicked the user is redirected to a page to define the password.  \
The page contains two fields: password & confirm password (re-enter) \
Once this is submitted, the user's account is activated in the system.  \
Users are automatically logged in and redirected to homepage.

If entered passwords don't match, an  error is displayed “Passwords don’t match” and the user is prompted to enter them again.

It is mandatory to define an admin user. It is not possible to delete an admin user without first creating another admin user or defining an existing one as admin.


##


## Login

**Precondition**: registered user (Buyer) \
As a user I want to log in with email and password, so that I get the valid session to use the website.

When invalid e-mail or password are entered error message is shown “Invalid password or E-Mail” \
When E-Mail and password are correct, user is redirected to homepage (Profile Avatar is shown with first and last name)

If a user forgot his password, he can change it by clicking on the “forgot your password” button. This button is shown on the login page

Registration button is also shown on  this page.


## Logout

**Precondition**: user is logged in. \
As a user I want to log out, so that my session is closed.

As a user I can press the log out button on the right corner

When the button is pressed, I am redirected back to the Homepage.


## Password Change (Forgot)

**Precondition**: user has a valid account. \
As a user, I want to be able to change my password in the case I forgot it, so that I can keep my account.

If a user forgot his password, he can change it by clicking on the “forgot your password” button. This button is shown on the login page

As a user I press the “forgot my password” button, so I am redirected to a page in which I have to enter my email address. When I have entered my email address, I receive an email with a link to change my password. After clicking this link, I am redirected to a page in which I have to enter my new password and confirm it again

When I confirmed the new password I will log in and redirected to the homepage


## Change Role between Buyer and Provider user

**Precondition**: user has a valid account and has both buyer and provider role.

It is possible to register an email address as a buyer as well as a provider. Once this has been done, the logged in buyer can click on the button "switch to seller portal" in the menu and he will be redirected to the home page of a logged in provider without having to log in again. This menu item only exists for users who are registered with their email address as both buyer and provider. Also the other way around should work, with the option “switch to buyer portal”.

When logging in, system checks what was the role that was used at the last login and uses this as default.


## Creation of Users

**Precondition**: user has valid admin account and is logged in. (Role Buyer) \
As an admin, I want to be able to create users’ accounts for my company, so they can create inquiries or leads.

\
I have the option of creating additional users for my company profile. In order to create another user I have to click on the “User Management” menu. Then I will be redirected to the page where I can see all registered users in list form with the fields provided in list below. Here I have buttons to edit users and to delete users ( pen and trash symbol next to each user). Below there is "Add new user" button to create a user. If I click on this, the following fields appear which are required to create an user:



* E-mail address,
* Role: admin or buyer,
* First name,
* Surname,
* Title,
* Salutation

After I have entered everything so far, I click on the "Create user" button and the new user will receive an email containing a link to create a new password for this user. Here he has to enter his new password twice and then click the "Save password" button. He is then immediately logged in and forwarded to the homepage


## Editing of users and company details

**Precondition**: user has valid admin account and is logged in. (Role Buyer)

As a user/admin, I can press the pen symbol next to the list of users and change my data.  \


As a normal user, I can change the following fields.



* First name,
* Surname,
* Telephone
* Title,
* Salutation

As an admin, I can in addition change the role of the user.

\
If I have changed it, I can press the save button next to the list and the user is updated

As an admin, I see all users and can change it, as a user I only see my user profile and can change it

As an admin, I can change the company details in the “Company Management” menu.


## Deletion of users

**Precondition**: user has a valid admin account. (Role Buyer)

If I am logged in as admin, I have the option of deleting one or more users from my company profile. To delete a user, I have to click the "User Management" button in the menu as admin.  All active users are displayed. A trash icon for deleting the user is displayed next to each active user. When I click this symbol for a user, I am asked whether I really want to delete the user. Now I can confirm the process with YES or cancel it with NO. When I proceed with yes, the site will refresh and the user is deleted. When I cancel this progress the confirmation window disappears and everything stays as it was before. \


The user is not deleted from the database but marked as inactive. All offers/inquiries stay in the system unchanged. The user is not allowed to log in anymore with the email address.


## Inquiry creation

**Precondition**: user has valid admin or buyer account and is logged in. (Role Buyer)

As a buyer, I want to create inquiry so that I can receive offers for it.  \
\
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
* Company size:  (Dropdown - 0-10, 11-50, 51-100, 101-250, 251-500, 500+)

Automatically user data is shown (as contact info)



* Company name (will be filled in automatically and can’t be changed )
* Salutation, title, first name, surname, telephone number and email address of the contact person (will be filled in automatically and can all  be edited by simply entering text)

At the end of the page there is a “Cancel” button that when clicked redirects the user to homepage.

Once I have filled all mandatory fields, I have the option to proceed with sending the inquiry by clicking on a button (e.g. “Create inquiry”). If I click on that button I get an overview of the inquiry with a button “Send inquiry”. In the upper right corner of the overview is a “X” sign.   \
\
When I click on the "Send inquiry" button, a window appears with a  message with info that the inquiry has been forwarded for processing and I am automatically forwarded to the homepage.

Consultants get email with a link to the new inquiry. \
\
If I click the "X" sign, the overview will be closed and the user is back to inquiry creation.


## Automatic email notification for new offers

As a buyer I want to be notified when there are new offers for my inquiries.  \


As soon as the number of offers reached the number that buyer choose at inquiry creation or

The deadline for offers  has been reached (17.00 CET) the buyer will receive an automatic email with the link to the inquiry and its offers.  \
When the user clicks on the link it is forwarded to the inquiry view.  \



## Offer management

**Precondition**: user has valid buyer account and is logged in (Role Buyer)

As a buyer, I will receive a link by email which will forward me to the offers assigned to my inquiry. If I click the link I will be forwarded to the view which shows the inquiry and the offers and have the opportunity to download the PDFs that provider uploaded in the offer

Users are also forwarded to this view via the menu “My Inquiries” , by selecting a specific offer.

Inquiry data that is shown

Id \
Status (Open/Closed) \
Inquiry creator \
Branch

Deadline \
Creation date

\
When clicked on inquiry Offers are dropped down with following  data \
Id \
PDF

Provider Name	 \
Status (Accepted/Open/Rejected)


Date when the offer has been forwarded to the buyer


Date when the offer has been resolved by buyer (accepted/rejected)



Next to each offer there are two buttons "reject" and "accept". If I click on "reject", the provider will be contacted by email with a rejection (and link to the offer). If I click on "accept", the provider will be contacted with a confirmation (and link to the offer).

If the offer has been accepted the email will also contain contact details of the buyer. By this provider and buyer are able to agree on the next steps (contract, agreement, ...) with one another.  \





## Inquiry Navigation (Filtering)

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

It is open whether the list will be automatically updated as soon as one filter is changed or there should be an additional button, which when clicked will deliver the updated list. \


The list of inquiries is shown if there are matching results and users can click on one inquiry to get a detailed view of it.  \


Each row in the list shows following fields:


Id \
Status (Open/Closed) \
Inquiry creator \
Branch


Deadline \
Creation date

\
\
When clicked on one Inquiry its overview with all filled fields at the creation and uploaded documents is shown. There is also option to click on “Offers” to provide following details of each offer of the inquiry:

\
Id \
PDF

Provider Name	 \
Status (Accepted/Open/Rejected)  \
Date when the offer has been forwarded to the buyer


Date when the offer has been resolved (accepted/rejected)

Next to each offer the user has the option to download the PDF.

I also have the option to export the list of inquiries. This is exported to a .csv file with all the fields that are shown in the list view, additionally with offers and their details, but without PDF.


## Ads Management

As a buyer I see a banner slideshow on top of the page.

As a buyer I see a banner slideshow on the right side of the page.

As a buyer I have an option to see all active ads. \
As a buyer I can filter list of ads by branch.

When a buyer clicks on an ad, a new tab to an ad link is opened.


## Statistics

Precondition: user has valid admin/user account. (Role Buyer)

As a buyer, I can click on “statistics” in the menu to view my inquiry statistics. As a user I only see mine and as an admin I see all the users from the registered company. I have the following filter options:



* Period: timespan
* Editor (only for admin): the person that created inquiries. This is a list where one or multiple or all users can be chosen.

The bar chart is created that shows the number of closed/open inquiries for chosen user(users).

\
Example:



<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")


There is no summed up view, there is always  a bar for a user. If all users are chosen in filtering then the bar is displayed for each one.

I also have the option of exporting the statistics to Excel. This should be a .csv file. The file contains following columns:

Email address

Number of open inquiries

Number of closed inquiries \


If the bar chart is for the whole company, then the email address is not shown in the exported file.


## Menu

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


# <span style="text-decoration:underline;">Provider</span>


## Registration

_See Registration for Buyer. Everything applies and following additionally for the provider._

If I want to register as a provider , I have to fill in additionally following mandatory fields:

**Branch**

Branch designation has the following structure: **branch/category/product **where **branch **and **category **are required.

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

**Subscriptions** \
\
If the provider account is chosen, the user must choose the subscription model before completing the registration.


<table>
<tr>
<td colspan="3" >SOM Standard
</td>
<td colspan="3" >SOM Premium
</td>
<td colspan="3" >SOM Enterprise
</td>
</tr>
<tr>
<td rowspan="12" colspan="3" > - keine Werbeanzeigen bei SOM Ads
<p>
- 1 Benutzer anlegen
<p>
- Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser
</td>
<td rowspan="12" colspan="3" > - 1 Werbeanzeige pro Monat
<p>
bei SOM Ads für min zwei Wochen (Mo-So)
<p>
- bis zu 5 Benutzer anlegen
<p>
- Detaillierte Statistik mit Exportmöglichkeit
<p>
- Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser
<p>
- die ersten zwei Monate Gratis
</td>
<td rowspan="12" colspan="3" >
<p>
- 1 Werbeanzeige pro Monat
<p>
bei SOM Ads für min zwei Wochen (Mo-So)
<p>
- 1 Banneranzeige pro Monat
<p>
bei SOM Ads für einen Tag
<p>
- bis zu 15 Benutzer anlegen (jeder weitere Benutzer kostet €10,-)
<p>
- Detaillierte Statistik mit Exportmöglichkeit
<p>
- Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser
<p>
- die ersten zwei Monate Gratis
</td>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
<td colspan="3" >Einrichtungspauschale € 49,-
</td>
<td colspan="3" >Einrichtungspauschale entfällt
</td>
<td colspan="3" >Einrichtungspauschale entfällt
</td>
</tr>
<tr>
<td colspan="3" >€ 39,90 / Monat
</td>
<td colspan="3" >79,90 / Monat
</td>
<td colspan="3" >€ 149,90 / Monat
</td>
</tr>
</table>


These subscriptions models are not fixed. I.e. the prices could change.


## Login

_See Login for Buyer. Everything applies for providers as well._


## Logout

_See Logout for Buyer. Everything applies for providers as well._


## Password Change (Forgot)

_See Password Change for Buyer. Everything applies for providers as well._


## Change between Buyer and Provider user

_See Change between Buyer and Provider user  for Buyer. Everything applies for providers as well_


## Creation of Users

_See Creation of Users for Buyer. Everything applies for providers as well._


## Editing of Users and company details

_See Editing of Users for Buyer. Everything applies for providers as well._


## Deletion of Users

_See Deletion of Users for Buyer. Everything applies for providers as well._


## Subscription Management

Precondition: user has valid admin account. (Role Provider)

If I am logged in as admin and the company is registered as a provider, I have the option of editing or viewing my subscription. For this, I as admin have to click on the "Company Management" menu. Then I will be redirected to the page where I can see all my data and those of the company.

My subscription package, date of the company registration and the company details are displayed here. A pen symbol for editing the company data is displayed next to the details. A pen symbol for upgrading is also displayed with the subscription package. A downgrade is only possible three months before the end of the commitment. If I click this symbol for the subscription package, the package to which I can switch is displayed. An upgrade of the package is only possible at the beginning of the next month. As soon as I choose a new package, the contract is extended by one year. When I have decided on the new package, I have to tick the terms and conditions and click the "Upgrade" button. After I click on this button, I am redirected to the "Company management" page and the new subscription package including the start date can be seen.

Payment

Precondition: user has valid admin account. (Role Provider)

TBD

\
Billing

Precondition: user has valid admin account. (Role Provider)

TBD \



## Cancelling subscription

Note: this is not a functionality of SOM; must be done via email.

The admin of a registered company can cancel his subscription at the end of the contract. However, the termination must be in writing by email three months before the end of the commitment. If there is no termination three months before the end of the commitment, the contract is automatically extended for another year. In the event of termination, the consultants manually send a confirmation of termination to the admin by email. The company profile is then deleted from the SOM platform by the consultants. This is described under Provider churn for the consultants.


##  \
Offer Creation

Precondition: user has valid admin/user account and has received inquiry. (Role Provider)

As a provider I want to be able to create offers for the inquiries I have received. \
\
Only admins receive email with a link with newly forwarded inquiry to my company. \
Users only see assigned inquiries to them in My Inquiries menu. Admins see all inquiries.

When I click on an inquiry (either from the menu “My Inquiries” or from a link from the email) I  see an inquiry overview (defined in Inquiry navigation, see below) and have the option to upload my offer via the SOM platform. Additionally if I am an admin, I have an option to assign the inquiry to one user (From the list of all company users).

Next to the inquiry there are two buttons "Upload offer", “I don’t want to make an offer". If I click on "Upload offer", a window appears in which I can drag the offer in PDF format. Once I have done that, I can either click the "Upload" button (the window closes and the page is updated) or I click the "x" in this window to cancel the process (the window also closes here).

After I have uploaded the offer, the status of this request is updated from "open" to "offer uploaded" and I receive a "Thank you for your offer" message. \



## Inquiry Navigation (Filtering)

Precondition: user has valid admin/user account. (Role Provider)

As a provider I want to be able to manage my inquiries.

As a provider, if I am logged in, I can choose  “My inquiries” to manage all inquiries sent to me in a form of a list. Each row in the list shows following fields:



* Id
* Company name
* Status (Open/Offer Created/Lost/Won/Ignored)
* Deadline

\
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


## Ads Management

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

User can click on an ad and has the following possibilities:  \




* Reactivate: an ad that is already expired can be activated if users enter a new time period. The system must prove when the user has the next time slot available.
* Activate: if the ad is in draft status, the time period must be in future
* Deactivate: ad that is active can change status to draft
* Delete: ad can be deleted at any time
* Update: all fields besides the time period can be updated. If the ad has a status draft time period can also be updated according to the next available time slot for the user.

If a user reactivated or activated the ad an automatic email is sent to the consultants.

**Banner**

There is a maximum number of slots in the banner that ads can be assigned to.  \
This number is going to be hard-coded (proposal: 5-10)

One slot is valid for one whole day. \
The ads in the banner are shown in slide show sorted by the creation date (newest -> oldest)

When creating the banner the customer can choose only one slot in the month if there is one available.

**Normal ad**

There is no maximum number of slots here.

One provider can activate max one ad (besides banner) per month, \
Every ad has an expiry date. (proposal : 2 weeks) \
The ads are sorted by the creation date (newest -> oldest)


## Statistics

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

Number of offer created inquiries \
Number of lost inquiries

Number of won inquiries \
Number of ignored inquiries

If the bar chart is for the whole company, then the email address is not shown in the exported file.


## Menu

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


# <span style="text-decoration:underline;">Consultant</span>


## Login

_See Login for Buyer. Everything applies for a consultant as well._


## Logout

_See Logout for Buyer. Everything applies to a consultant as well._


## Password Change (Forgot)

_See Password Change for Buyer. Everything applies to a consultant as well._


## Consultant Creation

As a consultant, I want to be able to create other users with the role - consultant.

In User Management I have the option to create a consultant when I click on “Add new consultant”.

If I click on this, the following fields appear which are required to create a user:



* E-mail address,
* First name,
* Surname,
* Title,
* Salutation

After I have entered everything so far, I click on the "Create user" button and the new user will receive an email containing a link to create a new password for this user. Here he has to enter his new password twice and then click the "Save password" button. He is then immediately logged in and forwarded to the homepage.

If there is already a user with this email in the system registered an error message will be displayed.


## Provider or Buyer Creation

Precondition: user has a valid account. (Role Consultant)

As a consultant, I have the option of registering a provider/buyer by choosing the menu "Registered Companies" . In this case a window opens in which I can click on the "Create provider/buyer" button. As soon as I click on this, I have to go through the same process that a provider/buyer has to go through. However, here I have the option of choosing a free subscription package for providers. In addition, there are no mandatory fields that have to be filled out for the consultants.

An admin user must be created. This user will receive an email to enter the password same as in the registration process.


## Provider or Buyer Churn

Precondition: user has valid admin account. (Role Consultant)

The consultants can click on the "Registered Companies" button in the menu. As soon as this is clicked, the consultant is redirected to the page in which he can see all registered companies (buyers and providers). The companies are sorted alphabetically by the company name. It is also possible to filter the list of partners by the type: buyer and provider.

There is also a search field in which I can search for a partner using a free text search for the name of the company.

Next to each partner there is a pencil symbol to edit the buyer or provider and a trash can symbol to delete him. If I want to delete him, a window appears in which I can confirm the process with YES or cancel with NO. If I confirm with YES, the page is updated and the buyer or provider is deleted and the admin user gets a churn mail. If I cancel with No, this window disappears and the process is cancelled.

The company is not deleted but marked as inactive with all its users  in the database.


## Inquiry Navigation

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


Id \
Status (Open/Closed) \
Inquiry creator \
Branch


Deadline \
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

\
There is also option to click on “Offers” to provide following details of each offer of the inquiry:

\
Id \
PDF

Provider Name


Provider editor : user \
Buyer action (Accepted/Open/Rejected)


Provider action (Open/Offer Created/Lost/Won/Ignored) \
Date when the offer has been forwarded to the buyer


Date when the offer has been resolved (accepted/rejected)

I also have the option to export the list of inquiries. This is exported to a .csv file with all the fields that are shown in the list view, additionally with offers and their details, but without PDF.

If one inquiry is selected, if the status is open,  the consultant has the option to assign it to one or more providers.

As soon as I click on it, a list of providers appears. There is also the option of various filters:



* Branch
* Company size (Dropdown - 0-10, 11-50, 51-100, 101-250, 251-500, 500+)
* Provider type (Händler, Hersteller, Dienstleister, Großhändler)
* Postcode City: e.g. if user enters “5” all providers should be listed who have ZIP starting with “5”
* Number of received inquiries: range
* Number of sent offers: range
* Number of accepted offers: range
* Claimed

The goal is to get this list of suggested providers automatically in the future. This is not part of the first version of software.  \


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

\
There should be a menu for Branch Management where the list of existing ones is shown in table with columns \




* Branch
* Category \


And option to delete existing ones and add new ones.


## Ads Management

Precondition: user has a valid account. (Role Consultant)

As a consultant, I want to be able to manage all ads in the system.

If the users clicks on "SOM Ads" in the header and then on "All ads" he will be redirected to the page where I can see all the ads and have the following filter options:



* Status (draft, expired and active ads)
* Expiry Date
* Company name (free text search)

The consultant has the same rights and possibilities with ads as a provider admin, with the difference that he can see the ads from all the companies. (See Provider/Ads Management for details)


## Statistics

Precondition: user has a valid account. (Role Consultant)

As a consultant, I can click on "Statistics" in the menu to display all inquiry statistics for all registered companies. The statistics are displayed as a bar chart and I have the following fields to create the statistic for:



* Status
* Open inquiries (count of inquiries with no decision from buyer or without offers)
* closed inquiries (count of inquiries with decision from buyers)
* offers won (count)
* lost offers (count)
* Period (amount of inquiries per month - 12 bars)
* Provider type (amount of inquiries per defined types)
* Provider size (amount of inquiries per defined sizes)

Fields can't be combined, only one bar chart is going to be created per field. \
\
Additionally, I can enter a time period as a filter.

I also have the option of exporting the statistics to Excel. This should be a .csv file. The file contains the following columns:

If field “status”: status, count of inquiries

If fields “period”: month, count of inquiries \
If fields “provider type”: provider type, count of inquiries \
If fields “provider size”: provider size, count of inquiries


## Menu

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


# Consultant Admin


## Consultant Creation

As a consultant admin I want to be able to create further consultant accounts.


## Providers management

As a consultant admin I want to have the possibility to manage registered providers and their subscription.  \
\
In menu “Providers management” I have an option to list all providers and see following \
Company details

Subscription package type

Registration date

Payment details


IBAN \
BIC/SWIFT \
Kontoinhaber


Payment Interval

Here I want to have the option to export this data in a .csv file.


## Subscription Management

TBD

As a consultant admin I want to have the possibility to manage different subscription packages.

In the menu “Subscription Management” I want to see all existing packages (limited to 3)

Title \
Price \
Max number of users \
Max nr of normal ads in month

Max nr of banners in month


# -----------------------------------------------


# Deletion of users and companies

TBD: how can we delete users and companies completely from the system if they request it.


# System Admin

There should be one created super consultant with default pwd and username that can create the following consultants. The username and pwd will be provided by the developers.


# Languages

German & English


# Static Pages

Content \
Sitemaps

AGB & Datenschutz - in googledrive


# Email Templates

In googledrive


## Hosting

**TBD:**

Data - in cloud or on premise \
Sensitive customer data etc


 */
// we shall implement domain model solution developed using freezd and fpdart to handle the domain logic fully functional and pure
//
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:fpdart/fpdart.dart';
//
// import 'package:flutter/widgets.dart';
// import 'package:functional_widget/functional_widget.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'dashboard.freezed.dart';
//
// @swidget
// Widget dashboard(BuildContext context, DashboardModel model) {
//   return Column(
//     children: [
//       for (final summary in model.summaries)
//         match(summary.runtimeType, {
//           InquirySummary: (summary) => InquirySummaryWidget(summary),
//           BranchSummary: (summary) => BranchSummaryWidget(summary),
//           ProviderSummary: (summary) => ProviderSummaryWidget(summary),
//           // ... other types of summaries
//         }),
//       RaisedButton(
//         onPressed: model.onCreateInquiry,
//         child: Text('Create Inquiry'),
//       ),
//     ],
//   );
// }
//
// @freezed
// abstract class DashboardModel with _$DashboardModel {
//   factory DashboardModel({
//     @required List<Summary> summaries,
//     @required VoidCallback onCreateInquiry,
//   }) = _DashboardModel;
// }
//
// abstract class Summary {}
//
// @freezed
// abstract class InquirySummary with _$InquirySummary {
//   factory InquirySummary({
//     @required int id,
//     @required String title,
//     @required InquiryStatus status,
//   }) = _InquirySummary;
// }
//
// @freezed
// abstract class BranchSummary with _$BranchSummary {
//   factory BranchSummary({
//     @required int id,
//     @required String name,
//     @required int inquiryCount,
//   }) = _BranchSummary;
// }
//
// @freezed
// abstract class ProviderSummary with _$ProviderSummary {
//   factory ProviderSummary({
//     @required int id,
//     @required String name,
//     @required int inquiryCount,
//   }) = _ProviderSummary;
// }
//
// @swidget
// Widget InquirySummaryWidget(InquirySummary summary) {
