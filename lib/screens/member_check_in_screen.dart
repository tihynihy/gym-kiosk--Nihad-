import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/member.dart';
import '../models/check_in.dart';
import '../services/check_in_service.dart';
import 'success_screen.dart';

class MemberCheckInScreen extends StatelessWidget {
  final Member member;
  final String classSessionId;

  const MemberCheckInScreen({
    super.key,
    required this.member,
    required this.classSessionId,
  });

  Future<void> _handleCheckIn(BuildContext context) async {
    final checkInService = Provider.of<CheckInService>(context, listen: false);
    
    // Check if already checked in
    final alreadyCheckedIn = await checkInService.hasCheckedIn(
      member.id,
      classSessionId,
    );

    if (alreadyCheckedIn) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This member is already checked in'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Create check-in
    final checkIn = CheckIn(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      memberId: member.id,
      classSessionId: classSessionId,
      timestamp: DateTime.now(),
      status: CheckInStatus.confirmed,
    );

    final success = await checkInService.addCheckIn(checkIn);

    if (context.mounted) {
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              memberName: member.fullName,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to check in. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: member.profilePicture != null
                  ? NetworkImage(member.profilePicture!)
                  : null,
              child: member.profilePicture == null
                  ? Text(
                      member.firstName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 48),
                    )
                  : null,
            ),
            const SizedBox(height: 24),
            // Member Name
            Text(
              member.fullName,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Date
            Text(
              today,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Check In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleCheckIn(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text(
                  'Check In',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}