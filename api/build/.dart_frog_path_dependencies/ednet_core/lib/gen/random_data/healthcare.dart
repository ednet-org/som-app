part of ednet_core;

/// Healthcare domain semantic data
///
/// Provides semantically coherent test data for healthcare domains including
/// patients, appointments, medical records, treatments, and clinical workflows.
class HealthcareDomain {
  /// Medical specialties
  static const medicalSpecialties = [
    'Cardiology',
    'Dermatology',
    'Endocrinology',
    'Gastroenterology',
    'Neurology',
    'Oncology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Radiology',
  ];

  /// Appointment types
  static const appointmentTypes = [
    'InitialConsultation',
    'FollowUp',
    'AnnualCheckup',
    'Emergency',
    'Telemedicine',
    'Vaccination',
    'LabTest',
    'Procedure',
    'TherapySession',
  ];

  /// Appointment statuses
  static const appointmentStatuses = [
    'Scheduled',
    'Confirmed',
    'CheckedIn',
    'InProgress',
    'Completed',
    'Cancelled',
    'NoShow',
    'Rescheduled',
  ];

  /// Patient persona templates
  static const patientPersonas = <PatientPersona>[
    PatientPersona(
      id: 'PAT-001',
      firstName: 'Robert',
      lastName: 'Williams',
      dateOfBirth: '1965-03-15',
      gender: 'Male',
      bloodType: 'A+',
      allergies: ['Penicillin', 'Peanuts'],
      chronicConditions: ['Type 2 Diabetes', 'Hypertension'],
      insuranceProvider: 'BlueCross BlueShield',
      insuranceId: 'BC123456789',
    ),
    PatientPersona(
      id: 'PAT-002',
      firstName: 'Jennifer',
      lastName: 'Martinez',
      dateOfBirth: '1982-07-22',
      gender: 'Female',
      bloodType: 'O-',
      allergies: [],
      chronicConditions: [],
      insuranceProvider: 'Aetna',
      insuranceId: 'AET987654321',
    ),
    PatientPersona(
      id: 'PAT-003',
      firstName: 'David',
      lastName: 'Thompson',
      dateOfBirth: '1990-11-08',
      gender: 'Male',
      bloodType: 'B+',
      allergies: ['Latex'],
      chronicConditions: ['Asthma'],
      insuranceProvider: 'UnitedHealthcare',
      insuranceId: 'UHC456789123',
    ),
  ];

  /// Healthcare provider personas
  static const providerPersonas = <ProviderPersona>[
    ProviderPersona(
      id: 'DOC-001',
      firstName: 'Dr. Sarah',
      lastName: 'Anderson',
      specialty: 'Cardiology',
      licenseNumber: 'MD123456',
      yearsOfExperience: 15,
      acceptingNewPatients: true,
    ),
    ProviderPersona(
      id: 'DOC-002',
      firstName: 'Dr. James',
      lastName: 'Lee',
      specialty: 'Pediatrics',
      licenseNumber: 'MD789012',
      yearsOfExperience: 8,
      acceptingNewPatients: true,
    ),
    ProviderPersona(
      id: 'DOC-003',
      firstName: 'Dr. Maria',
      lastName: 'Garcia',
      specialty: 'Neurology',
      licenseNumber: 'MD345678',
      yearsOfExperience: 12,
      acceptingNewPatients: false,
    ),
  ];

  /// Vital signs templates (normal ranges)
  static const vitalSignsTemplates = <VitalSignsTemplate>[
    VitalSignsTemplate(
      type: 'BloodPressure',
      unit: 'mmHg',
      normalRange: '90/60 - 120/80',
      exampleValues: ['118/76', '110/70', '122/82'],
    ),
    VitalSignsTemplate(
      type: 'HeartRate',
      unit: 'bpm',
      normalRange: '60-100',
      exampleValues: ['72', '85', '68'],
    ),
    VitalSignsTemplate(
      type: 'Temperature',
      unit: 'F',
      normalRange: '97-99',
      exampleValues: ['98.6', '98.2', '97.8'],
    ),
    VitalSignsTemplate(
      type: 'OxygenSaturation',
      unit: '%',
      normalRange: '95-100',
      exampleValues: ['98', '99', '97'],
    ),
  ];

  /// Medical procedures
  static const medicalProcedures = [
    'BloodTest',
    'ECG',
    'X-Ray',
    'MRI',
    'CTScan',
    'Ultrasound',
    'Biopsy',
    'Endoscopy',
    'PhysicalExamination',
    'VaccinationAdministration',
  ];

  /// Prescription medications (generic examples)
  static const medications = <Medication>[
    Medication(
      name: 'Metformin',
      type: 'Tablet',
      dosage: '500mg',
      frequency: 'Twice daily',
      purpose: 'Diabetes management',
    ),
    Medication(
      name: 'Lisinopril',
      type: 'Tablet',
      dosage: '10mg',
      frequency: 'Once daily',
      purpose: 'Blood pressure control',
    ),
    Medication(
      name: 'Amoxicillin',
      type: 'Capsule',
      dosage: '500mg',
      frequency: 'Three times daily',
      purpose: 'Antibiotic',
    ),
  ];

  /// Healthcare domain events
  static const domainEvents = [
    'PatientRegistered',
    'PatientUpdated',
    'AppointmentScheduled',
    'AppointmentConfirmed',
    'AppointmentCancelled',
    'AppointmentCompleted',
    'PatientCheckedIn',
    'VitalSignsRecorded',
    'DiagnosisMade',
    'PrescriptionIssued',
    'LabTestOrdered',
    'LabResultsReceived',
    'TreatmentPlanCreated',
    'InsuranceClaimSubmitted',
    'InsuranceClaimApproved',
  ];

  /// BDD scenario templates for healthcare
  static const bddScenarios = <BDDScenario>[
    BDDScenario(
      feature: 'Appointment Scheduling',
      scenario: 'Patient books initial consultation',
      given: [
        'Patient is registered in system',
        'Doctor has available time slots',
        'Patient has selected preferred date/time',
      ],
      when: [
        'Patient submits appointment request',
        'System validates availability',
        'Appointment is confirmed',
      ],
      then: [
        'AppointmentScheduled event is published',
        'Patient receives confirmation email',
        'Doctor\'s calendar is updated',
        'Reminder notification is scheduled',
      ],
    ),
    BDDScenario(
      feature: 'Clinical Documentation',
      scenario: 'Doctor records patient diagnosis',
      given: [
        'Patient has completed appointment',
        'Doctor has examined patient',
        'Vital signs are recorded',
      ],
      when: [
        'Doctor enters diagnosis',
        'Treatment plan is created',
        'Prescription is issued',
      ],
      then: [
        'DiagnosisMade event is published',
        'Medical record is updated',
        'PrescriptionIssued event is triggered',
        'Follow-up appointment is suggested',
      ],
    ),
    BDDScenario(
      feature: 'Lab Test Workflow',
      scenario: 'Doctor orders lab test and receives results',
      given: [
        'Patient requires lab work',
        'Doctor is authorized to order tests',
        'Lab facility is available',
      ],
      when: [
        'Doctor orders lab test',
        'Patient completes lab work',
        'Results are processed',
      ],
      then: [
        'LabTestOrdered event is published',
        'Lab receives test request',
        'Results are uploaded to system',
        'LabResultsReceived event notifies doctor',
      ],
    ),
  ];

  /// Clinical workflow states
  static const clinicalWorkflowStates = [
    'PatientRegistration',
    'InsuranceVerification',
    'AppointmentScheduling',
    'PreVisitPreparation',
    'CheckIn',
    'VitalSignsCollection',
    'DoctorConsultation',
    'DiagnosisAndTreatment',
    'PrescriptionFulfillment',
    'CheckOut',
    'FollowUpScheduling',
  ];
}

/// Patient persona model
class PatientPersona {
  final String id;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String insuranceProvider;
  final String insuranceId;

  const PatientPersona({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.insuranceProvider,
    required this.insuranceId,
  });
}

/// Healthcare provider persona model
class ProviderPersona {
  final String id;
  final String firstName;
  final String lastName;
  final String specialty;
  final String licenseNumber;
  final int yearsOfExperience;
  final bool acceptingNewPatients;

  const ProviderPersona({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialty,
    required this.licenseNumber,
    required this.yearsOfExperience,
    required this.acceptingNewPatients,
  });
}

/// Vital signs template
class VitalSignsTemplate {
  final String type;
  final String unit;
  final String normalRange;
  final List<String> exampleValues;

  const VitalSignsTemplate({
    required this.type,
    required this.unit,
    required this.normalRange,
    required this.exampleValues,
  });
}

/// Medication model
class Medication {
  final String name;
  final String type;
  final String dosage;
  final String frequency;
  final String purpose;

  const Medication({
    required this.name,
    required this.type,
    required this.dosage,
    required this.frequency,
    required this.purpose,
  });
}
