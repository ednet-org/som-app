part of ednet_core;

/// Finance domain semantic data
///
/// Provides semantically coherent test data for financial domains including
/// accounts, transactions, payments, loans, and banking workflows.
class FinanceDomain {
  /// Account types
  static const accountTypes = [
    'Checking',
    'Savings',
    'MoneyMarket',
    'CertificateOfDeposit',
    'IRA',
    'Brokerage',
    'CreditCard',
    'Loan',
    'Mortgage',
  ];

  /// Transaction types
  static const transactionTypes = [
    'Deposit',
    'Withdrawal',
    'Transfer',
    'Payment',
    'DirectDebit',
    'StandingOrder',
    'CardPayment',
    'ATMWithdrawal',
    'InterestCredit',
    'Fee',
    'Refund',
  ];

  /// Transaction statuses
  static const transactionStatuses = [
    'Pending',
    'Authorized',
    'Completed',
    'Failed',
    'Cancelled',
    'Reversed',
    'OnHold',
  ];

  /// Customer account personas
  static const accountPersonas = <AccountPersona>[
    AccountPersona(
      accountNumber: 'ACC-1001-2345',
      accountType: 'Checking',
      customerName: 'John Smith',
      balance: 5430.75,
      currency: 'USD',
      status: 'Active',
      openDate: '2020-01-15',
      interestRate: 0.01,
    ),
    AccountPersona(
      accountNumber: 'ACC-1002-6789',
      accountType: 'Savings',
      customerName: 'Mary Johnson',
      balance: 25000.00,
      currency: 'USD',
      status: 'Active',
      openDate: '2018-06-22',
      interestRate: 0.025,
    ),
    AccountPersona(
      accountNumber: 'ACC-1003-9012',
      accountType: 'CreditCard',
      customerName: 'David Brown',
      balance: -1250.50,
      currency: 'USD',
      status: 'Active',
      openDate: '2021-03-10',
      interestRate: 0.1899,
    ),
  ];

  /// Payment methods
  static const paymentMethods = [
    'ACH',
    'Wire',
    'Check',
    'DebitCard',
    'CreditCard',
    'DigitalWallet',
    'Cryptocurrency',
    'Cash',
  ];

  /// Loan types
  static const loanTypes = [
    'PersonalLoan',
    'HomeMortgage',
    'AutoLoan',
    'StudentLoan',
    'BusinessLoan',
    'LineOfCredit',
  ];

  /// Credit card transaction scenarios
  static const creditCardTransactions = <CreditCardTransaction>[
    CreditCardTransaction(
      transactionId: 'TXN-CC-001',
      cardNumber: '**** **** **** 1234',
      merchantName: 'Amazon.com',
      merchantCategory: 'E-commerce',
      amount: 89.99,
      currency: 'USD',
      transactionDate: '2025-01-15',
      authorizationCode: 'AUTH123456',
    ),
    CreditCardTransaction(
      transactionId: 'TXN-CC-002',
      cardNumber: '**** **** **** 1234',
      merchantName: 'Starbucks',
      merchantCategory: 'Food & Beverage',
      amount: 5.75,
      currency: 'USD',
      transactionDate: '2025-01-16',
      authorizationCode: 'AUTH789012',
    ),
    CreditCardTransaction(
      transactionId: 'TXN-CC-003',
      cardNumber: '**** **** **** 5678',
      merchantName: 'Shell Gas Station',
      merchantCategory: 'Fuel',
      amount: 45.20,
      currency: 'USD',
      transactionDate: '2025-01-16',
      authorizationCode: 'AUTH345678',
    ),
  ];

  /// Financial domain events
  static const domainEvents = [
    'AccountOpened',
    'AccountClosed',
    'DepositMade',
    'WithdrawalMade',
    'TransferInitiated',
    'TransferCompleted',
    'PaymentProcessed',
    'PaymentFailed',
    'LoanApproved',
    'LoanDisbursed',
    'LoanPaymentReceived',
    'LoanDefaulted',
    'OverdraftOccurred',
    'FraudDetected',
    'CardActivated',
    'CardBlocked',
    'InterestAccrued',
    'FeeCharged',
  ];

  /// Fraud detection rules
  static const fraudDetectionRules = [
    'MultipleFailedAttempts',
    'UnusualLocation',
    'HighValueTransaction',
    'RapidSuccessiveTransactions',
    'VelocityCheck',
    'MerchantCategoryMismatch',
    'DeviceFingerprintMismatch',
  ];

  /// BDD scenario templates for finance
  static const bddScenarios = <BDDScenario>[
    BDDScenario(
      feature: 'Money Transfer',
      scenario: 'Customer transfers money between accounts',
      given: [
        'Customer has checking account with sufficient balance',
        'Customer has savings account',
        'Transfer amount is within daily limit',
      ],
      when: [
        'Customer initiates transfer',
        'System validates account balances',
        'Transfer is authorized',
      ],
      then: [
        'TransferInitiated event is published',
        'Amount is debited from checking account',
        'Amount is credited to savings account',
        'TransferCompleted event is published',
        'Customer receives confirmation',
      ],
    ),
    BDDScenario(
      feature: 'Fraud Detection',
      scenario: 'System detects suspicious transaction',
      given: [
        'Customer has normal transaction pattern',
        'Fraud detection rules are active',
        'Customer card is active',
      ],
      when: [
        'Transaction from unusual location is attempted',
        'Amount exceeds typical spending',
        'Fraud score threshold is exceeded',
      ],
      then: [
        'FraudDetected event is published',
        'Transaction is blocked',
        'Card is temporarily frozen',
        'Customer receives alert notification',
        'Fraud team is notified for review',
      ],
    ),
    BDDScenario(
      feature: 'Loan Application',
      scenario: 'Customer applies for personal loan',
      given: [
        'Customer has active checking account',
        'Customer has good credit score',
        'Loan amount is within lending limits',
      ],
      when: [
        'Customer submits loan application',
        'Credit check is performed',
        'Risk assessment is completed',
        'Loan is approved',
      ],
      then: [
        'LoanApproved event is published',
        'Loan account is created',
        'Funds are disbursed',
        'LoanDisbursed event is published',
        'Payment schedule is generated',
      ],
    ),
  ];

  /// Regulatory compliance requirements
  static const complianceRequirements = [
    'KYC_IdentityVerification',
    'AML_TransactionMonitoring',
    'PCI_DSS_DataSecurity',
    'GDPR_DataPrivacy',
    'SOX_FinancialReporting',
    'FATCA_TaxCompliance',
  ];

  /// Interest calculation methods
  static const interestCalculationMethods = [
    'Simple',
    'Compound',
    'DailyCompound',
    'MonthlyCompound',
    'AnnualPercentageYield',
  ];
}

/// Account persona model
class AccountPersona {
  final String accountNumber;
  final String accountType;
  final String customerName;
  final double balance;
  final String currency;
  final String status;
  final String openDate;
  final double interestRate;

  const AccountPersona({
    required this.accountNumber,
    required this.accountType,
    required this.customerName,
    required this.balance,
    required this.currency,
    required this.status,
    required this.openDate,
    required this.interestRate,
  });
}

/// Credit card transaction model
class CreditCardTransaction {
  final String transactionId;
  final String cardNumber;
  final String merchantName;
  final String merchantCategory;
  final double amount;
  final String currency;
  final String transactionDate;
  final String authorizationCode;

  const CreditCardTransaction({
    required this.transactionId,
    required this.cardNumber,
    required this.merchantName,
    required this.merchantCategory,
    required this.amount,
    required this.currency,
    required this.transactionDate,
    required this.authorizationCode,
  });
}
