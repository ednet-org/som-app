part of ednet_core;

/// Education domain semantic data
///
/// Provides semantically coherent test data for education domains including
/// students, courses, enrollments, assessments, and academic workflows.
class EducationDomain {
  /// Academic levels
  static const academicLevels = [
    'Elementary',
    'MiddleSchool',
    'HighSchool',
    'Undergraduate',
    'Graduate',
    'Doctorate',
    'Professional',
  ];

  /// Subject areas
  static const subjectAreas = [
    'Mathematics',
    'Science',
    'English',
    'History',
    'Geography',
    'Arts',
    'Music',
    'PhysicalEducation',
    'ForeignLanguages',
    'ComputerScience',
  ];

  /// Course difficulty levels
  static const difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  /// Student personas
  static const studentPersonas = <StudentPersona>[
    StudentPersona(
      studentId: 'STU-001',
      firstName: 'Emma',
      lastName: 'Wilson',
      grade: 'Grade 10',
      gpa: 3.8,
      enrollmentDate: '2023-09-01',
      major: 'Science',
      status: 'Active',
    ),
    StudentPersona(
      studentId: 'STU-002',
      firstName: 'Liam',
      lastName: 'Anderson',
      grade: 'Grade 11',
      gpa: 3.5,
      enrollmentDate: '2022-09-01',
      major: 'Mathematics',
      status: 'Active',
    ),
    StudentPersona(
      studentId: 'STU-003',
      firstName: 'Sophia',
      lastName: 'Martinez',
      grade: 'Grade 9',
      gpa: 3.9,
      enrollmentDate: '2024-09-01',
      major: 'Arts',
      status: 'Active',
    ),
  ];

  /// Course catalog
  static const courses = <Course>[
    Course(
      courseId: 'MATH-101',
      courseName: 'Algebra I',
      subject: 'Mathematics',
      credits: 3,
      difficulty: 'Beginner',
      description: 'Introduction to algebraic concepts',
      prerequisites: [],
    ),
    Course(
      courseId: 'SCI-201',
      courseName: 'Biology Fundamentals',
      subject: 'Science',
      credits: 4,
      difficulty: 'Intermediate',
      description: 'Core concepts in biology',
      prerequisites: ['SCI-101'],
    ),
    Course(
      courseId: 'ENG-101',
      courseName: 'English Literature',
      subject: 'English',
      credits: 3,
      difficulty: 'Beginner',
      description: 'Introduction to classic literature',
      prerequisites: [],
    ),
    Course(
      courseId: 'CS-301',
      courseName: 'Data Structures',
      subject: 'ComputerScience',
      credits: 4,
      difficulty: 'Advanced',
      description: 'Advanced data structures and algorithms',
      prerequisites: ['CS-101', 'CS-201'],
    ),
  ];

  /// Instructor personas
  static const instructorPersonas = <InstructorPersona>[
    InstructorPersona(
      instructorId: 'INST-001',
      firstName: 'Dr. Michael',
      lastName: 'Roberts',
      department: 'Mathematics',
      yearsOfExperience: 12,
      rating: 4.7,
      tenured: true,
    ),
    InstructorPersona(
      instructorId: 'INST-002',
      firstName: 'Prof. Lisa',
      lastName: 'Chen',
      department: 'Science',
      yearsOfExperience: 8,
      rating: 4.9,
      tenured: false,
    ),
  ];

  /// Assessment types
  static const assessmentTypes = [
    'Quiz',
    'MidtermExam',
    'FinalExam',
    'Project',
    'Assignment',
    'Presentation',
    'LabReport',
    'Essay',
  ];

  /// Grading scales
  static const gradingScales = <GradingScale>[
    GradingScale(
      grade: 'A',
      minPercentage: 90,
      maxPercentage: 100,
      points: 4.0,
    ),
    GradingScale(grade: 'B', minPercentage: 80, maxPercentage: 89, points: 3.0),
    GradingScale(grade: 'C', minPercentage: 70, maxPercentage: 79, points: 2.0),
    GradingScale(grade: 'D', minPercentage: 60, maxPercentage: 69, points: 1.0),
    GradingScale(grade: 'F', minPercentage: 0, maxPercentage: 59, points: 0.0),
  ];

  /// Enrollment statuses
  static const enrollmentStatuses = [
    'Enrolled',
    'Dropped',
    'Completed',
    'Withdrawn',
    'Deferred',
    'OnHold',
  ];

  /// Education domain events
  static const domainEvents = [
    'StudentRegistered',
    'StudentEnrolled',
    'CourseCreated',
    'CoursePublished',
    'AssignmentSubmitted',
    'AssignmentGraded',
    'ExamScheduled',
    'GradePosted',
    'AttendanceRecorded',
    'DegreeAwarded',
    'CourseCompleted',
    'EnrollmentCancelled',
  ];

  /// BDD scenario templates for education
  static const bddScenarios = <BDDScenario>[
    BDDScenario(
      feature: 'Course Enrollment',
      scenario: 'Student enrolls in new course',
      given: [
        'Student is registered in system',
        'Course has available seats',
        'Student meets prerequisites',
        'Enrollment period is open',
      ],
      when: [
        'Student selects course',
        'System validates prerequisites',
        'Student confirms enrollment',
      ],
      then: [
        'StudentEnrolled event is published',
        'Student is added to course roster',
        'Available seats are decremented',
        'Student receives confirmation email',
        'Course appears in student schedule',
      ],
    ),
    BDDScenario(
      feature: 'Assignment Grading',
      scenario: 'Instructor grades student submission',
      given: [
        'Student has submitted assignment',
        'Instructor has access to submissions',
        'Grading rubric is defined',
      ],
      when: [
        'Instructor reviews submission',
        'Grade is assigned based on rubric',
        'Feedback is provided',
        'Grade is submitted',
      ],
      then: [
        'AssignmentGraded event is published',
        'Grade is recorded in gradebook',
        'Student is notified of grade',
        'GPA is recalculated if final grade',
      ],
    ),
    BDDScenario(
      feature: 'Academic Progress',
      scenario: 'Student completes course requirements',
      given: [
        'Student is enrolled in course',
        'All assignments are submitted',
        'All exams are completed',
        'Minimum grade threshold is met',
      ],
      when: [
        'Final grade is calculated',
        'Course completion criteria are validated',
        'Grade is posted',
      ],
      then: [
        'CourseCompleted event is published',
        'Credits are awarded to student',
        'Transcript is updated',
        'Prerequisites unlocked for future courses',
      ],
    ),
  ];

  /// Academic calendar events
  static const academicCalendarEvents = [
    'SemesterStart',
    'AddDropDeadline',
    'MidtermWeek',
    'SpringBreak',
    'FinalExamWeek',
    'SemesterEnd',
    'GraduationCeremony',
  ];

  /// Learning modalities
  static const learningModalities = [
    'InPerson',
    'Online',
    'Hybrid',
    'Asynchronous',
    'SelfPaced',
  ];
}

/// Student persona model
class StudentPersona {
  final String studentId;
  final String firstName;
  final String lastName;
  final String grade;
  final double gpa;
  final String enrollmentDate;
  final String major;
  final String status;

  const StudentPersona({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.gpa,
    required this.enrollmentDate,
    required this.major,
    required this.status,
  });
}

/// Course model
class Course {
  final String courseId;
  final String courseName;
  final String subject;
  final int credits;
  final String difficulty;
  final String description;
  final List<String> prerequisites;

  const Course({
    required this.courseId,
    required this.courseName,
    required this.subject,
    required this.credits,
    required this.difficulty,
    required this.description,
    required this.prerequisites,
  });
}

/// Instructor persona model
class InstructorPersona {
  final String instructorId;
  final String firstName;
  final String lastName;
  final String department;
  final int yearsOfExperience;
  final double rating;
  final bool tenured;

  const InstructorPersona({
    required this.instructorId,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.yearsOfExperience,
    required this.rating,
    required this.tenured,
  });
}

/// Grading scale model
class GradingScale {
  final String grade;
  final int minPercentage;
  final int maxPercentage;
  final double points;

  const GradingScale({
    required this.grade,
    required this.minPercentage,
    required this.maxPercentage,
    required this.points,
  });
}
