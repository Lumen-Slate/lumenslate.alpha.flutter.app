import '../../models/classroom.dart';

final List<Classroom> dummyClassrooms = [
  Classroom(
    id: '101',
    subject: 'Physics',
    teacherIds: ['101'],
    assignmentIds: ['201'],
    credits: 4,
    tags: ['mechanics', 'thermodynamics'],
  ),
  Classroom(
    id: '102',
    subject: 'Chemistry',
    teacherIds: ['102'],
    assignmentIds: ['202'],
    credits: 3,
    tags: ['organic', 'inorganic'],
  ),
  Classroom(
    id: '103',
    subject: 'Mathematics',
    teacherIds: ['103'],
    assignmentIds: ['203'],
    credits: 2,
    tags: ['algebra', 'geometry'],
  ),
  Classroom(
    id: '104',
    subject: 'Biology',
    teacherIds: ['104'],
    assignmentIds: ['204'],
    credits: 3,
    tags: ['cell biology', 'genetics'],
  ),
  Classroom(
    id: '105',
    subject: 'History',
    teacherIds: ['105'],
    assignmentIds: ['205'],
    credits: 5,
    tags: ['ancient', 'modern'],
  ),
  Classroom(
    id: '106',
    subject: 'Advanced Physics',
    teacherIds: ['106'],
    assignmentIds: ['206', '207'],
    credits: 5,
    tags: ['quantum', 'relativity'],
  ),
];