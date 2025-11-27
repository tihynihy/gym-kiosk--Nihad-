import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/member.dart';
import '../models/check_in.dart';

class AttendeeListItem extends StatelessWidget {
  final Member member;
  final CheckIn checkIn;

  const AttendeeListItem({
    super.key,
    required this.member,
    required this.checkIn,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final checkInTime = timeFormat.format(checkIn.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: member.profilePicture != null
              ? NetworkImage(member.profilePicture!)
              : null,
          child: member.profilePicture == null
              ? Text(member.firstName[0].toUpperCase())
              : null,
        ),
        title: Text(member.fullName),
        subtitle: Text('Checked in at $checkInTime'),
        trailing: _buildStatusChip(),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String label;

    switch (checkIn.status) {
      case CheckInStatus.confirmed:
        chipColor = Colors.green;
        label = 'Confirmed';
        break;
      case CheckInStatus.registered:
        chipColor = Colors.blue;
        label = 'Registered';
        break;
      case CheckInStatus.waitlisted:
        chipColor = Colors.orange;
        label = 'Waitlisted';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}