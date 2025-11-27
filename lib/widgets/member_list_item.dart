import 'package:flutter/material.dart';
import '../models/member.dart';

class MemberListItem extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;

  const MemberListItem({
    super.key,
    required this.member,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}