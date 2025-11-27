import 'package:flutter/material.dart';
import '../models/class_session.dart';

class ClassCard extends StatelessWidget {
  final ClassSession classSession;
  final VoidCallback onTap;
  final int attendeeCount;

  const ClassCard({
    super.key,
    required this.classSession,
    required this.onTap,
    this.attendeeCount = 0,
  });

  Color _getTagColor(String tag) {
    switch (tag.toUpperCase()) {
      case 'KIDS':
        return const Color(0xFFFFB6C1); // Pink
      case 'YBGA':
        return const Color(0xFF87CEEB); // Light blue
      case 'MMA':
        return const Color(0xFFFFA500); // Orange
      case 'BJJ':
        return const Color(0xFF90EE90); // Green
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructor Profile Picture
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: classSession.instructorProfilePicture != null
                        ? NetworkImage(classSession.instructorProfilePicture!)
                        : null,
                    child: classSession.instructorProfilePicture == null
                        ? Text(
                            classSession.instructor.isNotEmpty
                                ? classSession.instructor[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 20),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Class Name
                        Text(
                          classSession.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        // Time
                        Text(
                          classSession.timeRangeWithH,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Tags
              if (classSession.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: classSession.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getTagColor(tag),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),
              // Attendees and Instructor
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '$attendeeCount/${classSession.capacity} attendees',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    classSession.instructorShortName ?? classSession.instructor,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
