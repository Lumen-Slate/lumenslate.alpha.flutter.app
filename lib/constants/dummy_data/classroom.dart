import '../../models/classroom.dart';

final List<Classroom> dummyClassrooms = [
  Classroom(
    id: '101',
    name: 'Physics',
    teacherIds: ['101'],
    assignmentIds: ['201'],
    credits: 4,
    tags: ['mechanics', 'thermodynamics'],
  ),
  Classroom(
    id: '102',
    name: 'Chemistry',
    teacherIds: ['102'],
    assignmentIds: ['202'],
    credits: 3,
    tags: ['organic', 'inorganic'],
  ),
  Classroom(
    id: '103',
    name: 'Mathematics',
    teacherIds: ['103'],
    assignmentIds: ['203'],
    credits: 2,
    tags: ['algebra', 'geometry'],
  ),
  Classroom(
    id: '104',
    name: 'Biology',
    teacherIds: ['104'],
    assignmentIds: ['204'],
    credits: 3,
    tags: ['cell biology', 'genetics'],
  ),
  Classroom(
    id: '105',
    name: 'History',
    teacherIds: ['105'],
    assignmentIds: ['205'],
    credits: 5,
    tags: ['ancient', 'modern'],
  ),
  Classroom(
    id: '106',
    name: 'Advanced Physics',
    teacherIds: ['106'],
    assignmentIds: ['206', '207'],
    credits: 5,
    tags: ['quantum', 'relativity'],
  ),
];
