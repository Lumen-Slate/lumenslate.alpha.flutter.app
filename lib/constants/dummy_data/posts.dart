

import '../../models/posts.dart';

final List<Posts> dummyPosts = [
  Posts(
    id: '501',
    title: 'Understanding Calculus',
    body: 'Can anyone help me with limits and derivatives?',
    attachments: ['calculus_notes.pdf'],
    userId: '301',
    commentIds: ['601', '602'],
  ),
  Posts(
    id: '502',
    title: 'Science Project Ideas',
    body: 'Looking for ideas for my upcoming science fair project.',
    attachments: [],
    userId: '302',
    commentIds: ['603', '604'],
  ),
  Posts(
    id: '503',
    title: 'History Presentation',
    body: 'Sharing my presentation slides on World War II.',
    attachments: ['ww2_presentation.pptx'],
    userId: '303',
    commentIds: ['605'],
  ),
  Posts(
    id: '504',
    title: 'Essay Writing Tips',
    body: 'Does anyone have tips for writing a good essay?',
    attachments: [],
    userId: '304',
    commentIds: ['606', '607'],
  ),
  Posts(
    id: '505',
    title: 'Python Programming Challenge',
    body: 'Participate in this week’s coding challenge on recursion.',
    attachments: ['challenge_details.txt'],
    userId: '305',
    commentIds: ['608', '609', '610'],
  ),
];