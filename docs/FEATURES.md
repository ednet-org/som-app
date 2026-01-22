# SOM Platform - Features Documentation

<div align="center">

**Comprehensive Feature Guide for Smart Offer Management Platform**

[Overview](#overview) • [Feature Matrix](#feature-matrix) • [Buyer Features](#buyer-features) • [Provider Features](#provider-features) • [Consultant Features](#consultant-features) • [Subscription Tiers](#subscription-tiers)

</div>

---

## Overview

**SOM (Smart Offer Management)** is a comprehensive B2B marketplace platform designed to streamline business inquiry and offer management across three distinct user roles:

- 🏢 **Buyers** - Companies seeking products or services
- 🏭 **Providers** - Service/product providers responding to inquiries
- 👔 **Consultants** - Platform administrators managing the ecosystem

This document provides detailed documentation of all features available to each user role, including user workflows, UI navigation, and feature-specific functionality.

For architecture details, see [ARCHITECTURE.md](ARCHITECTURE.md). For general project information, see [README.md](../README.md).

---

## Feature Matrix

### Quick Reference Table

| Feature Category | Buyer | Provider | Consultant | Consultant Admin |
|-----------------|-------|----------|------------|------------------|
| **User Management** | ✅ Company users | ✅ Company users | ✅ All users | ✅ All users |
| **Inquiry Management** | ✅ Create/View | ✅ View/Respond | ✅ View all/Assign | ✅ View all |
| **Offer Management** | ✅ Accept/Reject | ✅ Create offers | ✅ View all | ✅ View all |
| **Company Management** | ✅ Own company | ✅ Own company | ✅ All companies | ✅ All companies |
| **Subscription Management** | ❌ | ✅ View/Upgrade | ✅ View all | ✅ Manage/Payment |
| **Ads Management** | ✅ View only | ✅ Create/Manage | ✅ Approve/Manage | ✅ Approve/Manage |
| **Branch Management** | ❌ | ❌ | ✅ Full CRUD | ✅ Full CRUD |
| **Statistics** | ✅ Own data | ✅ Own data + Export | ✅ Platform-wide | ✅ Platform-wide + Billing |
| **Portal Switching** | ✅ Buyer ↔ Provider | ✅ Provider ↔ Buyer | ✅ All portals | ✅ All portals |
| **CSV Export** | ✅ | ✅ | ✅ | ✅ |

---

## Buyer Features

### 1. Registration & Authentication

#### 1.1 Company Registration

**Purpose**: Register a new buyer company on the SOM platform.

**User Flow**:
1. Navigate to registration page
2. Fill mandatory company information:
   - Company Name
   - Company Address (Street, ZIP, City, Country)
   - UID Number (Tax ID)
   - Firmenbuchnummer (Commercial Register Number)
   - Employee Count
3. Create initial admin user:
   - Email address
   - First Name
   - Last Name
   - Salutation (Mr./Ms./Dr.)
   - Role (automatically set to "Buyer Admin")
4. Submit registration
5. Receive verification email

**Validation Rules**:
- All fields are mandatory
- Email must be unique across platform
- UID Number must be valid format
- Firmenbuchnummer must be valid format
- Password must meet security requirements (min 8 chars, uppercase, lowercase, number)

**UI Components**:
- Multi-step registration wizard
- Field validation with inline error messages
- Progress indicator
- Terms & Conditions acceptance

> **Screenshot**: *Registration form - coming soon*

---

#### 1.2 Email Verification

**Purpose**: Verify user email address to activate account.

**User Flow**:
1. Receive verification email after registration
2. Click verification link (valid for 24 hours)
3. Redirected to login page with success message
4. Account activated

**Expiry Handling**:
- Verification links expire after 24 hours
- Resend verification option available on login
- Expired link shows clear error message with resend action

---

#### 1.3 Login & Logout

**Purpose**: Secure authentication for platform access.

**Login Flow**:
1. Navigate to login page
2. Enter email and password
3. Optional: "Remember me" checkbox
4. Submit credentials
5. Redirect to dashboard upon success

**Features**:
- ✅ Email/password authentication via Supabase Auth
- ✅ "Forgot Password" link
- ✅ "Remember me" persistence
- ✅ Session management with JWT tokens
- ✅ Automatic logout after inactivity (30 minutes)

**Logout Flow**:
1. Click "Logout" button in navigation
2. Confirm logout action
3. Session terminated
4. Redirect to login page

> **Screenshot**: *Login page - coming soon*

---

#### 1.4 Password Management

**Purpose**: Allow users to reset forgotten passwords securely.

**Reset Flow**:
1. Click "Forgot Password" on login page
2. Enter registered email address
3. Receive password reset email
4. Click reset link (valid for 1 hour)
5. Enter new password (with confirmation)
6. Submit new password
7. Redirect to login with success message

**Password Requirements**:
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character (optional)

---

#### 1.5 Portal Switching

**Purpose**: Allow companies registered as both buyer and provider to switch between portals.

**User Flow**:
1. Click "Switch Portal" button in navigation
2. Select target portal (Buyer or Provider)
3. Interface updates to selected portal view
4. Access features specific to selected role

**Business Rules**:
- Only available if company has both buyer and provider registrations
- Role permissions update based on selected portal
- Session persists across portal switch
- Dashboard content adapts to selected portal

---

### 2. User Management

#### 2.1 Create Additional Users

**Purpose**: Allow company admins to add team members.

**User Flow** (Admin only):
1. Navigate to "User Management" in settings
2. Click "Add User" button
3. Fill user details:
   - Email (unique)
   - First Name
   - Last Name
   - Salutation
   - Role (Buyer or Buyer Admin)
4. Submit form
5. New user receives invitation email with password setup link

**Roles & Permissions**:

| Role | Create Inquiries | View Offers | Edit Company | Manage Users | View Statistics |
|------|-----------------|-------------|--------------|--------------|-----------------|
| **Buyer** | ✅ | ✅ | ❌ | ❌ | ✅ (own) |
| **Buyer Admin** | ✅ | ✅ | ✅ | ✅ | ✅ (all) |

**Validation**:
- Email must be unique across entire platform
- Admin role required to create users
- Maximum users determined by subscription tier

> **Screenshot**: *User management interface - coming soon*

---

#### 2.2 Edit User Profiles

**Purpose**: Update user information and roles.

**User Flow**:
1. Navigate to "User Management"
2. Click "Edit" on user row
3. Modify editable fields:
   - First Name
   - Last Name
   - Salutation
   - Role (Admin only)
4. Save changes

**Permissions**:
- Users can edit own profile (except role and email)
- Admins can edit all company users
- Email changes require re-verification

---

#### 2.3 Delete Users

**Purpose**: Remove users from company account (soft delete).

**User Flow** (Admin only):
1. Navigate to "User Management"
2. Click "Delete" on user row
3. Confirm deletion in modal dialog
4. User marked as inactive (soft delete)

**Business Rules**:
- Soft delete: user data retained but account deactivated
- Cannot delete last admin user
- Deleted users cannot log in
- Admin confirmation required
- User receives deactivation notification email

---

### 3. Inquiry Management

#### 3.1 Create Inquiry

**Purpose**: Submit a business inquiry to find suitable providers.

**User Flow**:
1. Navigate to "Create Inquiry" page
2. Select **Branch & Category** from dropdown hierarchy
3. Set **Delivery Deadline** (date picker)
4. Define **Delivery Locations** (ZIP codes, multiple allowed)
5. Set **Number of Providers** to receive inquiry (1-50)
6. Enter **Inquiry Description** (rich text editor, max 5000 chars)
7. Upload **Supporting Documents** (PDF, max 10MB, optional)
8. Configure **Provider Criteria**:
   - ZIP code proximity
   - Search radius (km)
   - Provider type (Manufacturer, Distributor, Service Provider)
   - Company size (Small, Medium, Large, Enterprise)
9. Preview inquiry
10. Submit inquiry

**Validation**:
- Branch and category are mandatory
- Deadline must be in future
- At least one delivery location required
- Description required (min 50 chars)
- Provider count must be 1-50

**Matching Logic**:
- System automatically matches providers based on:
  - Branch/category match
  - ZIP code + radius proximity
  - Provider type filter
  - Company size filter
  - Subscription tier (prioritize Premium/Enterprise)
- Selected providers receive email notification

**Status Lifecycle**:
```
Draft → Published → Open → Closed (Offers Received) | Expired (No Offers)
```

> **Screenshot**: *Create inquiry form - coming soon*

---

#### 3.2 View Inquiry List

**Purpose**: Monitor all company inquiries with advanced filtering.

**User Flow**:
1. Navigate to "My Inquiries" page
2. View inquiry list in table/card view
3. Apply filters (see below)
4. Click inquiry to view details
5. Export filtered results to CSV

**Display Columns**:
- Inquiry ID
- Branch / Category
- Status (badge with color coding)
- Created Date
- Deadline
- Editor (user who created it)
- Provider Type filter
- Company Size filter
- Number of Providers matched
- Offer count received
- Actions (View, Edit, Close)

**Filtering Options**:
- **Status**: All, Draft, Open, Closed, Expired
- **Editor**: Filter by creating user
- **Branch**: Filter by business branch
- **Provider Type**: Manufacturer, Distributor, Service Provider, All
- **Date Range**: From/To date picker
- **Company Size**: Small, Medium, Large, Enterprise, All
- **Deadline**: Upcoming (next 7 days), This Month, All

**Sorting**:
- Sort by: Created Date, Deadline, Status, Offer Count
- Order: Ascending / Descending

**Actions**:
- **View Details**: See full inquiry with provider responses
- **Edit**: Modify draft inquiries (published inquiries cannot be edited)
- **Close**: Manually close inquiry before deadline
- **Delete**: Remove draft inquiries

> **Screenshot**: *Inquiry list with filters - coming soon*

---

#### 3.3 Export to CSV

**Purpose**: Export inquiry data for external analysis.

**User Flow**:
1. Apply desired filters to inquiry list
2. Click "Export to CSV" button
3. Download CSV file with filtered data

**CSV Columns**:
- Inquiry ID
- Branch
- Category
- Status
- Created Date
- Deadline
- Editor
- Provider Type Filter
- Company Size Filter
- Providers Matched
- Offers Received
- Description (truncated)

---

### 4. Offer Management

#### 4.1 Receive Offer Notifications

**Purpose**: Notify buyers when providers submit offers.

**Notification Channels**:
- ✅ Email notification with offer summary
- ✅ In-app notification badge
- ✅ Dashboard "New Offers" widget

**Email Content**:
- Provider name
- Inquiry reference
- Offer submission date
- Link to view offer details
- CTA: "Review Offer"

---

#### 4.2 View & Evaluate Offers

**Purpose**: Review offers from providers and make decisions.

**User Flow**:
1. Navigate to "Offers" page or click inquiry with offers
2. View offer list for specific inquiry
3. Click offer to view details:
   - Provider information (name, contact, location)
   - Offer description
   - Pricing details
   - Delivery terms
   - Attached PDF proposal
4. Download PDF offer document
5. Perform action: Accept or Reject

**Offer Details Screen**:
- Provider company profile (name, address, contact)
- Offer submission date
- Offer text/description
- Pricing breakdown (if provided)
- Delivery timeline
- Terms & conditions
- Attached documents (PDF download)
- Action buttons: Accept, Reject, Request Clarification

**Accept/Reject Actions**:
- **Accept Offer**:
  1. Click "Accept Offer" button
  2. Confirm acceptance in modal
  3. Provider receives acceptance notification
  4. Inquiry status changes to "Closed"
  5. Contact details exchanged for direct communication

- **Reject Offer**:
  1. Click "Reject Offer" button
  2. Optional: Provide rejection reason
  3. Confirm rejection
  4. Provider receives rejection notification
  5. Inquiry remains open for other offers

**Business Rules**:
- Buyer can accept multiple offers per inquiry
- Once accepted, buyer contact details shared with provider
- Rejected offers cannot be re-accepted
- Inquiry auto-closes after deadline or when all offers processed

> **Screenshot**: *Offer details and actions - coming soon*

---

#### 4.3 Download Offer PDFs

**Purpose**: Access detailed offer proposals submitted by providers.

**User Flow**:
1. Click "Download PDF" button on offer card
2. PDF opens in new tab or downloads
3. Review detailed proposal offline

**PDF Content** (provider-submitted):
- Detailed service/product description
- Itemized pricing
- Delivery schedule
- Payment terms
- Company credentials
- Terms & conditions

---

### 5. Statistics

#### 5.1 Inquiry Statistics Dashboard

**Purpose**: Monitor inquiry performance and trends.

**Visualizations**:

**1. Open vs Closed Inquiries (Bar Chart)**
- X-axis: Time period (daily, weekly, monthly)
- Y-axis: Count of inquiries
- Two bars per period: Open (blue), Closed (green)

**2. Offers Received per Inquiry (Bar Chart)**
- X-axis: Inquiry ID or date
- Y-axis: Number of offers
- Color coding by offer status (Pending, Accepted, Rejected)

**3. Inquiries by Branch (Pie Chart)**
- Distribution of inquiries across business branches
- Click slice to filter details

**4. Average Response Time**
- Time from inquiry publication to first offer
- Displayed as metric card

**Filtering Options**:
- **Period**: Last 7 days, Last 30 days, Last 90 days, Custom range
- **Editor**: Filter by inquiry creator
- **Branch**: Filter by business branch
- **Status**: All, Open, Closed, Expired

**Export**:
- Export charts as PNG image
- Export raw data as CSV
- Scheduled email reports (future feature)

> **Screenshot**: *Statistics dashboard - coming soon*

---

### 6. Ads Viewing

#### 6.1 View Promotional Banners

**Purpose**: Display relevant advertisements from providers.

**User Flow**:
1. Navigate to "Ads" section or view on dashboard
2. Banners displayed as slideshow/carousel
3. Click banner to view provider details or external link

**Display Modes**:
- **Banner Slideshow**: Auto-rotating carousel (5-second intervals)
- **Grid View**: Multiple normal ads in grid layout

**Filtering**:
- **Filter by Branch**: Show only ads relevant to selected branch
- **Filter by Category**: Narrow down to specific categories

**Ad Types**:
- **Banner Ads**: Full-width promotional banners (Enterprise tier only)
- **Normal Ads**: Standard rectangular ads (Premium/Enterprise tier)

**Business Rules**:
- Ads shown based on buyer's inquiry history and branches
- Banner ads expire after 1 day
- Normal ads expire after 2 weeks
- Click tracking for analytics

> **Screenshot**: *Ad banner carousel - coming soon*

---

## Provider Features

### 1. Registration

#### 1.1 Provider Company Registration

**Purpose**: Register as a service/product provider with subscription.

**User Flow** (extends Buyer registration):
1. Complete standard company registration (see Buyer section 1.1)
2. **Additional Provider Fields**:
   - **Branch/Category Selection**: Select all applicable branches (multi-select)
   - **Bank Details**:
     - IBAN (International Bank Account Number)
     - BIC/SWIFT Code
     - Account Owner Name
   - **Subscription Tier Selection**:
     - Standard (€39.90/month)
     - Premium (€79.90/month)
     - Enterprise (€149.90/month)
   - **Payment Interval**: Monthly or Annually (10% discount)
3. Review subscription details
4. Agree to provider terms & conditions
5. Submit registration
6. **Payment Setup**:
   - Redirected to payment gateway
   - Enter payment details (credit card or SEPA direct debit)
   - Confirm subscription
7. Receive confirmation email with invoice

**Validation**:
- All buyer validation rules apply
- IBAN must be valid format
- BIC must match IBAN country
- At least one branch must be selected
- Payment method required before activation

**Free Trial** (Premium/Enterprise only):
- 2 months free trial
- No payment required during trial
- Full feature access
- Reminder emails 7 days before trial ends
- Auto-conversion to paid subscription unless cancelled

**Setup Fee** (Standard tier only):
- One-time €49 setup fee
- Charged with first monthly payment
- Waived for annual subscriptions

> **Screenshot**: *Provider registration - subscription selection - coming soon*

---

### 2. Subscription Management

#### 2.1 View Current Subscription

**Purpose**: Display active subscription details and usage.

**User Flow**:
1. Navigate to "Subscription" in account settings
2. View subscription overview card:
   - Current tier (Standard, Premium, Enterprise)
   - Billing cycle (Monthly/Annual)
   - Next billing date
   - Payment method (last 4 digits)
   - User count (current / maximum)
   - Ads quota (used / total)

**Display Sections**:
- **Plan Details**: Tier name, price, billing frequency
- **Features Enabled**: Checkmark list of tier features
- **Usage Metrics**:
  - Users: 2 / 5 (Premium example)
  - Normal Ads: 1 / 1 this month
  - Banner Ads: 0 / 1 this month (Enterprise only)
- **Billing History**: Table of past invoices with download links

---

#### 2.2 Upgrade Subscription

**Purpose**: Move to higher subscription tier for additional features.

**User Flow**:
1. Navigate to "Subscription" settings
2. Click "Upgrade Plan" button
3. View comparison table of tiers
4. Select target tier (Premium or Enterprise)
5. Review changes:
   - New features unlocked
   - Price difference (prorated)
   - Effective date (immediate)
6. Confirm upgrade
7. Payment processed immediately (prorated amount)
8. Features unlocked instantly

**Upgrade Path**:
```
Standard → Premium (immediate, prorated)
Standard → Enterprise (immediate, prorated)
Premium → Enterprise (immediate, prorated)
```

**Prorated Billing**:
- Credit for unused days on current tier
- Charge for remaining days on new tier
- Example: Upgrade on day 15 of 30-day cycle
  - Credit: €39.90 * 15/30 = €19.95
  - Charge: €79.90 * 15/30 = €39.95
  - Total: €19.95 due immediately

---

#### 2.3 Downgrade Subscription

**Purpose**: Reduce subscription tier (requires 3-month notice).

**User Flow**:
1. Navigate to "Subscription" settings
2. Click "Change Plan" button
3. Select lower tier
4. System displays notice requirement:
   - "Downgrade to Standard requires 3-month notice"
   - Effective date: [3 months from today]
5. Confirm downgrade request
6. Confirmation email sent
7. Reminder emails at 30 days, 7 days before downgrade
8. Downgrade executes on effective date

**Business Rules**:
- 3-month notice required for all downgrades
- No refund for remaining period
- Features remain active until effective date
- If usage exceeds new tier limits, user must reduce before downgrade:
  - Delete excess users
  - Deactivate excess ads
- Cancellation of downgrade request allowed anytime before effective date

**Downgrade Validation**:
- Check user count ≤ new tier limit
- Check active ads ≤ new tier limit
- Warn if limits exceeded
- Block downgrade until compliance

---

#### 2.4 Billing & Payment

**Purpose**: Manage payment methods and view invoices.

**User Flow**:
1. Navigate to "Billing" section
2. View payment method on file
3. Update payment method:
   - Click "Update Payment Method"
   - Enter new credit card or bank details
   - Verify with test charge (€0.01, refunded)
   - Save new method
4. View invoice history:
   - Date, amount, status, download PDF
5. Enable/disable auto-renewal

**Invoice Details**:
- Invoice number
- Billing date
- Subscription tier
- Billing period
- Amount (net, VAT, gross)
- Payment status (Paid, Pending, Failed)
- Download PDF button

**Failed Payment Handling**:
- Email notification on payment failure
- Retry after 3 days (automatic)
- Account suspended after 3 failed attempts
- Reactivation upon successful payment

> **Screenshot**: *Subscription management interface - coming soon*

---

### 3. Offer Creation

#### 3.1 Receive Inquiry Notifications

**Purpose**: Alert providers to new matching inquiries.

**User Flow**:
1. Buyer publishes inquiry
2. System matches inquiry to providers based on:
   - Branch/category match
   - ZIP code proximity
   - Provider type
   - Company size
   - Subscription tier (Premium/Enterprise prioritized)
3. Matched providers receive email notification:
   - Inquiry summary
   - Buyer company name (anonymized or full, based on settings)
   - Branch/category
   - Delivery locations
   - Deadline
   - Link to view full inquiry
4. In-app notification badge incremented

**Email Content**:
```
Subject: New Inquiry in [Branch]: [Category]

You have been matched to a new inquiry:

Branch: [Branch Name]
Category: [Category Name]
Delivery Locations: [ZIP Codes]
Deadline: [Date]
Number of Providers: [Count]

[Truncated Description...]

View Full Inquiry & Submit Offer:
[Link to Inquiry Details]

---
This is an automated notification from SOM Platform.
```

---

#### 3.2 Submit Offer

**Purpose**: Respond to buyer inquiries with competitive offers.

**User Flow**:
1. Navigate to "Inquiries" page (provider view)
2. Click inquiry to view full details
3. Review inquiry requirements
4. Click "Create Offer" button
5. Fill offer form:
   - **Offer Description** (rich text, max 5000 chars)
   - **Pricing Details** (optional structured fields or free text)
   - **Delivery Timeline** (date or duration)
   - **Terms & Conditions** (optional)
   - **Upload PDF Proposal** (optional, max 10MB)
6. Preview offer
7. Submit offer
8. Buyer receives notification

**Offer Form Fields**:
- Description: Detailed proposal text
- Unit Price: Price per unit (if applicable)
- Total Price: Total offer amount
- Currency: EUR (default)
- Delivery Time: Days or specific date
- Validity: Offer valid until date
- PDF Attachment: Upload detailed proposal

**Validation**:
- Description required (min 100 chars)
- At least one pricing field required (unit or total)
- Delivery time required
- PDF optional but recommended

**Status Tracking**:
- Offer status: Submitted, Under Review, Accepted, Rejected
- Provider can view status in "My Offers" page

> **Screenshot**: *Create offer form - coming soon*

---

#### 3.3 Decline to Offer

**Purpose**: Opt out of inquiry without submitting offer.

**User Flow**:
1. View inquiry details
2. Click "Don't Want to Make Offer" button
3. Optional: Select reason from dropdown:
   - Not in our service area
   - Capacity constraints
   - Pricing not competitive
   - Requirements unclear
   - Other (free text)
4. Confirm decline
5. Inquiry removed from provider's active list

**Business Rules**:
- Decline action removes inquiry from provider's dashboard
- Buyer not notified of decline (to preserve anonymity)
- Provider can still access inquiry in "Declined" filter
- No penalty for declining

---

#### 3.4 Inquiry Assignment (Admin)

**Purpose**: Allow provider admins to assign inquiries to specific users.

**User Flow** (Admin only):
1. Navigate to "Inquiries" page
2. Click "Assign" button on inquiry row
3. Select user from company user dropdown
4. Add optional note for assignee
5. Submit assignment
6. Assignee receives email notification
7. Inquiry appears in assignee's "My Assigned Inquiries" filter

**Permissions**:
- Only provider admins can assign inquiries
- Assignee must be active user in company
- Reassignment allowed
- Unassign option available

---

### 4. Inquiry Navigation

#### 4.1 Filter & Search Inquiries

**Purpose**: Efficiently navigate inquiries relevant to provider.

**User Flow**:
1. Navigate to "Inquiries" page (provider view)
2. View inquiries matched to provider profile
3. Apply filters:
   - **Status**: New, In Progress, Offer Submitted, Declined, Expired
   - **Editor**: Filter by assigned user (if assigned)
   - **Deadline**: Upcoming (7 days), This Month, All
   - **Branch**: Filter by business branch
4. Sort by: Deadline, Created Date, Status
5. Click inquiry to view details

**Inquiry Card Display**:
- Inquiry ID
- Branch / Category
- Buyer (anonymized or full name based on privacy settings)
- Delivery Locations (ZIP codes)
- Deadline (with countdown if < 7 days)
- Status badge
- Action buttons: View, Create Offer, Decline

---

#### 4.2 View Buyer Contact Details

**Purpose**: Access buyer information after offer acceptance.

**User Flow**:
1. Buyer accepts provider's offer
2. Provider receives "Offer Accepted" email notification
3. Navigate to "My Offers" → "Accepted" tab
4. Click offer to view details
5. **Buyer Contact Details Revealed**:
   - Company name
   - Contact person (name, salutation)
   - Email address
   - Phone number (if provided)
   - Company address
6. Provider initiates direct communication with buyer

**Privacy Rules**:
- Buyer contact details hidden until offer accepted
- Only anonymized company name shown before acceptance
- Full contact exchange upon acceptance
- Buyer can opt-in to show contact earlier (future feature)

---

#### 4.3 Export to CSV

**Purpose**: Export inquiry data for analysis and reporting.

**User Flow**:
1. Apply desired filters to inquiry list
2. Click "Export to CSV" button
3. Download CSV file

**CSV Columns**:
- Inquiry ID
- Branch
- Category
- Buyer (anonymized)
- Deadline
- Status
- My Offer Status
- Created Date
- Delivery Locations

---

### 5. Ads Management

#### 5.1 Create Normal Ad

**Purpose**: Publish promotional ads (Premium/Enterprise tiers).

**User Flow**:
1. Navigate to "Ads" → "My Ads"
2. Click "Create Ad" button
3. Fill ad form:
   - **Ad Title** (max 100 chars)
   - **Ad Description** (max 500 chars)
   - **Branch/Category**: Select target audience
   - **Ad Image**: Upload image (JPG/PNG, max 2MB, 800x600px recommended)
   - **Call-to-Action**: Text for button (e.g., "Learn More", "Contact Us")
   - **Target URL**: Link destination (optional)
4. Preview ad
5. Submit for review (if approval required) or publish immediately

**Quota & Limits**:
- **Premium**: 1 normal ad per month, active for 2 weeks
- **Enterprise**: 1 normal ad per month, active for 2 weeks
- Unused quota does not roll over
- Only 1 active normal ad at a time

**Ad Review Process**:
- Consultant reviews ad for compliance
- Approval within 24 hours
- Rejection with reason provided
- Provider can edit and resubmit

**Image Requirements**:
- Format: JPG, PNG
- Max file size: 2MB
- Recommended dimensions: 800x600px (4:3 ratio)
- No explicit content or misleading claims

---

#### 5.2 Create Banner Ad (Enterprise Only)

**Purpose**: Publish prominent banner ads (Enterprise tier only).

**User Flow**:
1. Navigate to "Ads" → "My Ads"
2. Click "Create Banner Ad" button
3. Fill banner form:
   - **Banner Title**
   - **Banner Description** (shorter, 200 chars max)
   - **Branch/Category**: Target audience
   - **Banner Image**: Upload (JPG/PNG, max 5MB, 1920x400px recommended)
   - **Call-to-Action Button**: Text + URL
4. Preview banner (full-width mockup)
5. Submit for approval

**Quota & Limits**:
- **Enterprise only**: 1 banner ad per month
- Active for 1 day (24 hours)
- Prominent placement on buyer dashboard
- Higher visibility than normal ads

**Banner Requirements**:
- Format: JPG, PNG
- Max file size: 5MB
- Recommended dimensions: 1920x400px (landscape)
- Professional quality imagery
- Consultant approval required

---

#### 5.3 Manage Ads

**Purpose**: Control ad lifecycle and status.

**User Flow**:
1. Navigate to "Ads" → "My Ads"
2. View ad list with status badges:
   - **Draft**: Not yet published
   - **Pending Approval**: Awaiting consultant review
   - **Active**: Currently live
   - **Expired**: Past active period
   - **Deactivated**: Manually stopped
   - **Rejected**: Failed review
3. Perform actions:
   - **Activate**: Publish approved draft ad
   - **Deactivate**: Pause active ad before expiry
   - **Reactivate**: Resume deactivated ad (if within quota)
   - **Edit**: Modify draft or rejected ad
   - **Delete**: Remove ad permanently
   - **Update**: Edit active ad (triggers re-approval)

**Business Rules**:
- Active ads count toward quota
- Deactivating ad does not refund quota
- Expired ads can be reactivated if quota available
- Editing active ad pauses it pending re-approval

> **Screenshot**: *Ads management interface - coming soon*

---

#### 5.4 View Ad Performance

**Purpose**: Monitor ad effectiveness and engagement.

**User Flow**:
1. Navigate to "Ads" → "My Ads"
2. Click ad to view details
3. View performance metrics:
   - **Impressions**: Number of times ad displayed
   - **Clicks**: Number of clicks on ad or CTA
   - **Click-Through Rate (CTR)**: Clicks / Impressions
   - **Engagement by Branch**: Which branches viewed/clicked most
   - **Daily Performance Chart**: Impressions and clicks over time

**Metrics Display**:
- Real-time updates
- Visual charts (line graph for trends)
- Comparison to previous ads
- Export metrics to CSV

---

### 6. Statistics

#### 6.1 Offer Statistics Dashboard

**Purpose**: Monitor offer performance and business trends.

**Visualizations**:

**1. Offers by Status (Bar Chart)**
- X-axis: Status (Open, Offer Created, Lost, Won, Ignored)
- Y-axis: Count
- Color coding by status

**2. Win Rate Over Time (Line Chart)**
- X-axis: Time period
- Y-axis: Percentage of offers won
- Trend line

**3. Response Time Analysis**
- Average time to submit offer after inquiry receipt
- Displayed as metric card
- Comparison to industry average (future feature)

**4. Offers by Branch (Pie Chart)**
- Distribution of offers across branches
- Click to drill down

**Filtering Options**:
- **Period**: Last 7 days, Last 30 days, Last 90 days, Custom
- **Status**: All, Open, Won, Lost, Ignored
- **Editor**: Filter by user who created offer
- **Branch**: Filter by business branch

**Export**:
- ✅ Export charts as PNG
- ✅ Export raw data to CSV
- ✅ Scheduled email reports (Premium/Enterprise)

**Subscription Tier Differences**:
- **Standard**: Basic statistics, no export
- **Premium/Enterprise**: Detailed statistics with CSV export

> **Screenshot**: *Provider statistics dashboard - coming soon*

---

## Consultant Features

### 1. User Management

#### 1.1 Create Consultant Accounts

**Purpose**: Onboard new consultants to manage platform.

**User Flow** (Consultant Admin only):
1. Navigate to "Consultants" → "User Management"
2. Click "Add Consultant" button
3. Fill consultant details:
   - Email (unique)
   - First Name
   - Last Name
   - Salutation
   - Role: Consultant or Consultant Admin
4. Set permissions (if role-based access control enabled)
5. Submit
6. New consultant receives invitation email

**Consultant Roles**:
- **Consultant**: Manage buyers, providers, inquiries, ads, branches
- **Consultant Admin**: All consultant permissions + subscription management, payments, system settings

---

#### 1.2 Create Buyer/Provider Accounts

**Purpose**: Manually onboard companies on behalf of clients.

**User Flow**:
1. Navigate to "Companies" → "Create Company"
2. Select company type: Buyer or Provider
3. Fill company registration form (same fields as self-registration)
4. Create initial admin user for company
5. **For Providers**: Select subscription tier and setup payment
6. Submit
7. Company admin receives welcome email with login credentials

**Use Cases**:
- Onboarding clients via sales team
- Migrating existing clients to platform
- Offering white-glove setup service

---

### 2. Company Management

#### 2.1 View All Companies

**Purpose**: Central registry of all buyers and providers.

**User Flow**:
1. Navigate to "Companies" page
2. View company list with tabs:
   - All Companies
   - Buyers
   - Providers
3. Apply filters:
   - **Company Type**: Buyer, Provider
   - **Status**: Active, Inactive, Churned
   - **Subscription Tier** (Providers): Standard, Premium, Enterprise
   - **Registration Date**: Date range
4. Sort by: Name, Registration Date, Employee Count

**Display Columns**:
- Company Name
- Type (Buyer/Provider badge)
- Primary Contact (admin user)
- Email
- Registration Date
- Status
- Subscription (Providers only)
- Employee Count
- Actions (View, Edit, Deactivate)

---

#### 2.2 Edit Companies

**Purpose**: Update company information and settings.

**User Flow**:
1. Navigate to "Companies"
2. Click "Edit" on company row
3. Modify editable fields:
   - Company name
   - Address
   - Contact information
   - UID Number
   - Firmenbuchnummer
   - Employee count
   - Branches (Providers)
   - Bank details (Providers)
4. Save changes
5. Company receives update confirmation email

**Permissions**:
- Consultants can edit all fields
- Changes logged in audit trail

---

#### 2.3 Delete (Churn) Companies

**Purpose**: Deactivate companies (soft delete for data retention).

**User Flow**:
1. Navigate to "Companies"
2. Click "Deactivate" on company row
3. Select churn reason:
   - Customer request
   - Non-payment
   - Violation of terms
   - Business closure
   - Other (free text)
4. Confirm deactivation
5. Company and all users deactivated (soft delete)
6. Company receives deactivation notification

**Business Rules**:
- Soft delete: data retained for audit and compliance
- All company users lose login access
- Active inquiries/offers remain visible (read-only)
- Subscriptions cancelled automatically
- Company can be reactivated by Consultant Admin

---

### 3. Inquiry Management

#### 3.1 View All Inquiries

**Purpose**: Platform-wide inquiry monitoring.

**User Flow**:
1. Navigate to "Inquiries" (consultant view)
2. View inquiries from all buyers
3. Apply filters:
   - **Buyer Company**: Select specific buyer
   - **Provider Company**: Filter by matched provider
   - **Branch/Category**
   - **Status**: All, Open, Closed, Expired
   - **Date Range**
   - **Deadline**
4. Sort by: Created Date, Deadline, Offer Count

**Display Columns**:
- Inquiry ID
- Buyer Company
- Branch/Category
- Status
- Created Date
- Deadline
- Providers Matched
- Offers Received
- Actions (View, Assign, Close)

---

#### 3.2 Assign Inquiries to Providers

**Purpose**: Manually match inquiries to specific providers.

**User Flow**:
1. Navigate to "Inquiries" (consultant view)
2. Click "Assign Providers" on inquiry row
3. View list of potential providers (with matching score)
4. Select providers to notify (multi-select)
5. Add optional note for providers
6. Submit assignment
7. Selected providers receive inquiry notification

**Use Cases**:
- Override automatic matching algorithm
- Prioritize specific providers
- Expand inquiry reach beyond initial matches
- Quality control for high-value inquiries

**Matching Score Display**:
- Shows how well provider matches inquiry criteria:
  - Branch/category match: ✅ or ❌
  - ZIP proximity: X km away
  - Provider type match: ✅ or ❌
  - Company size match: ✅ or ❌
  - Subscription tier: Standard/Premium/Enterprise

---

#### 3.3 Advanced Filtering

**Purpose**: Powerful search and filter for inquiry analysis.

**Advanced Filters**:
- **Buyer Company Type**: By industry or employee count
- **Provider Type Filter Applied**: Filter inquiries by what provider type buyer requested
- **Geographic Region**: By ZIP code range or region
- **Offer Count Range**: Inquiries with 0-5, 5-10, 10+ offers
- **Response Rate**: % of matched providers who submitted offers
- **Value Indicators**: High-value inquiries (based on description keywords)

**Saved Filters**:
- Save custom filter combinations
- Name saved filters (e.g., "High-Value Construction Inquiries")
- Quick access dropdown for saved filters

---

### 4. Branch Management

#### 4.1 Add Branch/Category

**Purpose**: Expand platform taxonomy for new business areas.

**User Flow**:
1. Navigate to "Branches" management page
2. Click "Add Branch" button
3. Fill branch details:
   - Branch Name (e.g., "Construction")
   - Branch Description
   - Branch Icon (upload or select from library)
   - Parent Branch (if subcategory, optional)
4. Add categories under branch:
   - Category Name (e.g., "Electrical Work")
   - Category Description
   - Keywords (for search/matching)
5. Submit
6. New branch/category immediately available for inquiries and provider profiles

**Hierarchy**:
```
Branch (Level 1)
  └── Category (Level 2)
      └── Subcategory (Level 3, optional)
```

**Example**:
```
Construction (Branch)
  ├── Electrical Work (Category)
  ├── Plumbing (Category)
  └── HVAC (Category)
```

---

#### 4.2 Edit Branch/Category

**Purpose**: Update branch/category information.

**User Flow**:
1. Navigate to "Branches" management
2. Click "Edit" on branch/category row
3. Modify fields (name, description, icon, keywords)
4. Save changes
5. Changes reflected immediately across platform

**Impact Analysis**:
- Shows number of inquiries using this branch
- Shows number of providers registered under this branch
- Warns if branch used in active inquiries

---

#### 4.3 Delete Branch/Category

**Purpose**: Remove obsolete or unused branches.

**User Flow**:
1. Navigate to "Branches" management
2. Click "Delete" on branch/category row
3. System checks for dependencies:
   - Active inquiries using branch
   - Providers registered under branch
4. If dependencies exist:
   - Display warning with count
   - Offer "Reassign" option to move dependencies to different branch
5. If no dependencies or after reassignment:
   - Confirm deletion
   - Branch soft-deleted (hidden from UI, data retained)

**Business Rules**:
- Cannot delete branch with active inquiries unless reassigned
- Cannot delete branch if providers registered (must reassign)
- Soft delete for audit trail
- Deleted branches not shown in dropdowns but visible in historical data

---

### 5. Ads Management

#### 5.1 View All Ads

**Purpose**: Platform-wide ad monitoring and moderation.

**User Flow**:
1. Navigate to "Ads" (consultant view)
2. View all ads from all providers
3. Apply filters:
   - **Provider Company**: Select specific provider
   - **Ad Type**: Normal, Banner
   - **Status**: Draft, Pending Approval, Active, Expired, Rejected
   - **Branch/Category**
   - **Date Range**
4. Sort by: Created Date, Status, Impressions

**Display Columns**:
- Ad ID
- Provider Company
- Ad Type (Normal/Banner badge)
- Title
- Branch/Category
- Status
- Created Date
- Expiry Date
- Impressions
- Clicks
- CTR
- Actions (View, Approve, Reject, Deactivate)

---

#### 5.2 Approve/Reject Ads

**Purpose**: Review and moderate provider ads for compliance.

**User Flow**:
1. Navigate to "Ads" → "Pending Approval" tab
2. Click ad to view details and preview
3. Review ad content:
   - Title and description
   - Image quality and appropriateness
   - Target URL (if external)
   - Compliance with ad policies
4. Perform action:
   - **Approve**: Publish ad immediately
   - **Reject**: Deny ad with reason
5. If rejecting:
   - Select rejection reason:
     - Inappropriate content
     - Misleading claims
     - Poor image quality
     - Wrong category
     - Other (free text)
6. Submit decision
7. Provider receives approval or rejection notification

**Ad Policy Compliance Checklist**:
- ✅ No explicit or offensive content
- ✅ Accurate representation of services/products
- ✅ Professional quality imagery
- ✅ Correct branch/category selection
- ✅ No copyright infringement
- ✅ No competitor disparagement

> **Screenshot**: *Ad approval interface - coming soon*

---

### 6. Statistics

#### 6.1 Platform-Wide Statistics

**Purpose**: Monitor overall platform health and activity.

**Visualizations**:

**1. Platform Activity Dashboard**
- Total Buyers
- Total Providers
- Active Inquiries
- Total Offers (this month)
- Growth metrics (% change vs last period)

**2. Inquiries by Status (Stacked Bar Chart)**
- X-axis: Time period (daily, weekly, monthly)
- Y-axis: Count
- Stacked bars: Open, Closed, Expired

**3. Offers by Status (Pie Chart)**
- Submitted
- Under Review
- Accepted
- Rejected

**4. Provider Performance Matrix**
- Table with providers ranked by:
  - Offers submitted
  - Win rate
  - Average response time
  - Customer ratings (future feature)

**5. Revenue Analytics (Consultant Admin only)**
- Monthly Recurring Revenue (MRR)
- Subscription distribution by tier
- Churn rate
- Average Revenue Per User (ARPU)

**Filtering Options**:
- **Period**: Last 7 days, Last 30 days, Last 90 days, Last 12 months, Custom
- **Provider Type**: Manufacturer, Distributor, Service Provider, All
- **Provider Size**: Small, Medium, Large, Enterprise, All
- **Branch**: Filter by business branch
- **Geography**: Filter by region or ZIP code range

**Export**:
- ✅ Export all charts as PNG
- ✅ Export raw data to CSV
- ✅ Generate PDF report
- ✅ Schedule automated email reports (weekly/monthly)

> **Screenshot**: *Platform statistics dashboard - coming soon*

---

## Consultant Admin Features

### 1. Provider Subscription Management

**Purpose**: Manage provider subscriptions and billing.

**User Flow**:
1. Navigate to "Subscriptions" (Consultant Admin only)
2. View subscription list with all providers
3. Apply filters:
   - **Tier**: Standard, Premium, Enterprise
   - **Status**: Active, Trial, Suspended, Cancelled
   - **Payment Status**: Current, Overdue, Failed
4. Click provider to view subscription details:
   - Current tier
   - Billing cycle
   - Next billing date
   - Payment method
   - Billing history

**Actions**:
- **Upgrade Subscription**: Manually upgrade provider (e.g., as part of sales promotion)
- **Downgrade Subscription**: Manually downgrade (e.g., for non-payment)
- **Suspend Subscription**: Pause subscription (e.g., for policy violation)
- **Cancel Subscription**: Terminate subscription
- **Apply Discount**: Add promotional discount code
- **Extend Trial**: Extend free trial period
- **Refund Payment**: Process refund for overpayment or cancellation

**Discount Management**:
- Create discount codes (percentage or fixed amount)
- Set expiry dates
- Limit to specific tiers
- Track usage

---

### 2. Payment Overview

**Purpose**: Monitor payment health and revenue.

**User Flow**:
1. Navigate to "Payments" (Consultant Admin only)
2. View payment dashboard:
   - **Monthly Recurring Revenue (MRR)**: Current MRR and trend
   - **Outstanding Payments**: Overdue invoices requiring attention
   - **Failed Payments**: Recent payment failures
   - **Refunds Issued**: Total refunds this month
3. Click section to drill down:
   - **MRR Breakdown**: By subscription tier
   - **Outstanding Payments List**: Provider, amount, days overdue
   - **Failed Payments List**: Provider, reason, retry status
4. Take action:
   - Send payment reminder email
   - Suspend account for non-payment
   - Process manual payment
   - Issue refund

**Payment Analytics**:
- Revenue trends (line chart)
- Payment success rate
- Average payment cycle time
- Churn impact on revenue

---

### 3. Export Functionality

**Purpose**: Generate comprehensive reports for analysis.

**User Flow**:
1. Navigate to desired section (Subscriptions, Payments, Inquiries, etc.)
2. Apply filters for target data
3. Click "Export" button
4. Select export format:
   - **CSV**: For spreadsheet analysis
   - **Excel**: Formatted workbook with multiple sheets
   - **PDF**: Formatted report for presentation
   - **JSON**: For API integration or custom processing
5. Select data range:
   - Current view (filtered data)
   - All data (ignoring filters)
   - Custom selection
6. Submit export request
7. Download file or receive via email (for large exports)

**Available Exports**:
- ✅ Subscription list with billing details
- ✅ Payment history with transaction details
- ✅ Inquiry list with buyer and provider information
- ✅ Offer list with acceptance rates
- ✅ Company directory with contact information
- ✅ User list with roles and activity
- ✅ Branch and category taxonomy
- ✅ Ad performance metrics
- ✅ Platform statistics and KPIs

**Scheduled Exports**:
- Set up recurring exports (daily, weekly, monthly)
- Email delivery to specified recipients
- Automated archiving to cloud storage

---

## Subscription Tiers

### Comparison Table

| Feature | **Standard** | **Premium** | **Enterprise** |
|---------|-------------|------------|---------------|
| **Monthly Price** | €39.90 | €79.90 | €149.90 |
| **Annual Price** | €430 (10% discount) | €863 (10% discount) | €1,619 (10% discount) |
| **Setup Fee** | €49 (one-time) | None | None |
| **Free Trial** | No | 2 months | 2 months |
| | | | |
| **Users** | 1 user | 5 users | 15 users (+€10/additional user) |
| **Inquiry Access** | ✅ Receive inquiries | ✅ Receive inquiries | ✅ Priority inquiry matching |
| **Offer Submission** | ✅ Unlimited | ✅ Unlimited | ✅ Unlimited |
| | | | |
| **Normal Ads** | ❌ No | 1/month (2 weeks active) | 1/month (2 weeks active) |
| **Banner Ads** | ❌ No | ❌ No | 1/month (1 day active) |
| **Ad Analytics** | ❌ No | ✅ Basic | ✅ Detailed + Export |
| | | | |
| **Statistics** | ✅ Basic charts | ✅ Detailed charts + CSV export | ✅ Detailed charts + CSV export |
| **Email Reports** | ❌ No | ✅ Monthly | ✅ Weekly + Monthly |
| **API Access** | ❌ No | ❌ No | ✅ REST API (future) |
| **Priority Support** | ❌ No | ✅ Email support (24h response) | ✅ Phone + Email (4h response) |
| **Account Manager** | ❌ No | ❌ No | ✅ Dedicated account manager |

### Feature Details

#### Standard Tier (€39.90/month)

**Target Audience**: Small providers testing the platform or with limited inquiry volume.

**Included Features**:
- 1 user account
- Receive inquiries matching your profile
- Submit unlimited offers
- Basic statistics dashboard
- Standard email support

**Limitations**:
- No advertising capabilities
- No CSV export
- €49 setup fee
- No free trial

**Best For**:
- Solo practitioners
- Small businesses
- Initial platform evaluation (after setup)

---

#### Premium Tier (€79.90/month)

**Target Audience**: Growing businesses seeking more visibility and team collaboration.

**Included Features**:
- 5 user accounts
- Priority inquiry matching (higher in provider selection)
- Submit unlimited offers
- **1 Normal Ad per month** (active for 2 weeks)
- Detailed statistics with CSV export
- Monthly email reports
- 24-hour email support
- **2 months free trial**

**Limitations**:
- No banner ads
- No API access

**Best For**:
- Medium-sized businesses
- Teams requiring collaboration
- Providers seeking advertising opportunities

---

#### Enterprise Tier (€149.90/month)

**Target Audience**: Established businesses requiring maximum visibility and advanced features.

**Included Features**:
- 15 user accounts (€10/month per additional user beyond 15)
- **Highest priority** inquiry matching
- Submit unlimited offers
- **1 Normal Ad per month** (active for 2 weeks)
- **1 Banner Ad per month** (active for 1 day, prominent placement)
- Detailed statistics with CSV export
- Weekly and monthly email reports
- Advanced ad analytics
- Priority phone and email support (4-hour response SLA)
- Dedicated account manager
- **2 months free trial**
- API access (future feature)

**Limitations**:
- None

**Best For**:
- Large enterprises
- High-volume providers
- Businesses requiring maximum platform visibility
- Organizations needing dedicated support

---

### Subscription Policies

#### Free Trial (Premium/Enterprise)

- **Duration**: 2 months (60 days)
- **Features**: Full access to all tier features
- **Payment**: No payment required during trial
- **Conversion**: Automatic conversion to paid subscription at trial end
- **Cancellation**: Cancel anytime during trial with no charge
- **Reminder**: Email reminders at 7 days before trial end

#### Billing Cycles

- **Monthly**: Billed on the same day each month
- **Annual**: Billed once per year, 10% discount applied
- **Prorated**: Upgrades prorated for remaining period
- **Downgrade**: Requires 3-month notice, no prorating

#### Payment Methods

- Credit Card (Visa, Mastercard, American Express)
- SEPA Direct Debit (EU only)
- Bank Transfer (annual subscriptions only)

#### Cancellation Policy

- Cancel anytime (no long-term contract)
- Access remains until end of billing period
- No refund for partial month/year
- Data exported upon request (30 days after cancellation)

#### Failed Payments

1. Automatic retry after 3 days
2. Email notification to admin
3. Second retry after 7 days
4. Account suspended after 10 days of non-payment
5. Account deactivated after 30 days

#### Upgrade/Downgrade

- **Upgrade**: Immediate effect, prorated billing
- **Downgrade**: 3-month notice required, effective at next billing cycle
- **User Limit Compliance**: Must reduce users before downgrade if exceeding new tier limit

---

## UI Navigation

### Navigation Structure

#### Buyer Navigation

```
Dashboard
├── My Inquiries
│   ├── Create Inquiry
│   ├── Draft Inquiries
│   ├── Active Inquiries
│   └── Closed Inquiries
├── Offers
│   ├── Pending Review
│   ├── Accepted Offers
│   └── Rejected Offers
├── Statistics
│   ├── Inquiry Analytics
│   └── Offer Analytics
├── Ads
│   └── View Ads
├── Settings
│   ├── Company Profile
│   ├── User Management
│   └── Notifications
└── Portal Switch (if also provider)
    └── Switch to Provider Portal
```

---

#### Provider Navigation

```
Dashboard
├── Inquiries
│   ├── New Inquiries
│   ├── My Assigned Inquiries
│   ├── Offer Submitted
│   ├── Declined
│   └── Expired
├── My Offers
│   ├── Submitted Offers
│   ├── Accepted Offers
│   ├── Rejected Offers
│   └── Expired Offers
├── Ads
│   ├── My Ads
│   ├── Create Normal Ad
│   └── Create Banner Ad (Enterprise only)
├── Statistics
│   ├── Offer Performance
│   ├── Ad Analytics (Premium/Enterprise)
│   └── Revenue Trends
├── Subscription
│   ├── Current Plan
│   ├── Billing History
│   ├── Payment Method
│   └── Upgrade Plan
├── Settings
│   ├── Company Profile
│   ├── User Management
│   ├── Bank Details
│   └── Notifications
└── Portal Switch (if also buyer)
    └── Switch to Buyer Portal
```

---

#### Consultant Navigation

```
Dashboard
├── Companies
│   ├── All Companies
│   ├── Buyers
│   ├── Providers
│   └── Create Company
├── Inquiries
│   ├── All Inquiries
│   ├── Open Inquiries
│   ├── Closed Inquiries
│   └── Assign Providers
├── Offers
│   └── All Offers
├── Ads
│   ├── All Ads
│   ├── Pending Approval
│   ├── Active Ads
│   └── Rejected Ads
├── Branches
│   ├── All Branches
│   ├── Add Branch
│   └── Edit Branch/Category
├── Users
│   ├── Consultants
│   ├── Buyers
│   ├── Providers
│   └── Create User
├── Statistics
│   ├── Platform Overview
│   ├── Inquiry Analytics
│   ├── Offer Analytics
│   ├── Provider Performance
│   └── Revenue Analytics (Admin only)
├── Subscriptions (Admin only)
│   ├── Active Subscriptions
│   ├── Trials
│   ├── Suspended
│   └── Cancelled
├── Payments (Admin only)
│   ├── Payment Overview
│   ├── Outstanding Payments
│   ├── Failed Payments
│   └── Refunds
└── Settings
    ├── System Settings (Admin only)
    ├── Email Templates
    └── Platform Configuration
```

---

## Responsive Design

### Mobile Experience

All features optimized for mobile devices (iOS/Android):

- **Responsive layouts**: Adaptive grid for phone, tablet, desktop
- **Touch-optimized UI**: Large touch targets, swipe gestures
- **Offline support**: Basic read-only access to cached data
- **Push notifications**: Real-time alerts for inquiries, offers
- **Image optimization**: Automatic compression for mobile networks

### Desktop Experience

Enhanced features for desktop users:

- **Multi-column layouts**: Sidebar navigation + main content
- **Keyboard shortcuts**: Power user productivity features
- **Drag-and-drop**: File uploads, reordering
- **Advanced filtering**: More screen space for complex filters
- **Split views**: Compare offers side-by-side

---

## Accessibility

### WCAG 2.1 AA Compliance

- **Keyboard navigation**: Full keyboard access without mouse
- **Screen reader support**: ARIA labels and semantic HTML
- **Color contrast**: Minimum 4.5:1 ratio for all text
- **Focus indicators**: Clear focus states for all interactive elements
- **Resizable text**: Support for up to 200% zoom without layout break
- **Alternative text**: All images have descriptive alt text

---

## Internationalization (i18n)

### Supported Languages

- 🇩🇪 **German (de)**: Primary language
- 🇬🇧 **English (en)**: Secondary language
- 🇷🇸 **Serbian (sr)**: Additional language support

### Localization Features

- **Date/Time formats**: Locale-specific formatting
- **Currency**: EUR with locale-specific formatting (€39,90 vs €39.90)
- **Number formatting**: Thousands separator, decimal separator
- **Right-to-left (RTL)**: Not currently supported (future feature)

---

## Related Documentation

- **[README.md](../README.md)** - Project overview and setup instructions
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture and design patterns
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Deployment and infrastructure guide
- **[API Documentation](../openapi/)** - REST API specification

---

## Screenshots

> **Note**: Screenshots are planned and will be added after UI implementation is complete.

### Planned Screenshots

1. **Registration & Authentication**
   - Company registration wizard
   - Login page
   - Email verification flow

2. **Buyer Portal**
   - Buyer dashboard
   - Create inquiry form
   - Inquiry list with filters
   - Offer details page
   - Statistics dashboard

3. **Provider Portal**
   - Provider dashboard
   - Inquiry list (provider view)
   - Create offer form
   - Ads management interface
   - Subscription management
   - Provider statistics

4. **Consultant Portal**
   - Platform statistics dashboard
   - Company management
   - Inquiry assignment interface
   - Ad approval workflow
   - Branch management

5. **Mobile Experience**
   - Mobile dashboard
   - Mobile inquiry creation
   - Mobile offer submission
   - Mobile navigation

---

## Support & Feedback

For feature requests, bug reports, or general questions:

- **Email**: support@som-platform.com
- **Issue Tracker**: [GitHub Issues](../../issues)
- **Documentation Wiki**: [Project Wiki](../../wiki)

---

<div align="center">

**Last Updated**: January 22, 2026

**Version**: 1.0.0

</div>
