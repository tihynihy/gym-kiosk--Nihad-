import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/class_session.dart';
import '../models/member.dart';
import '../models/check_in.dart';
import '../services/data_service.dart';
import '../services/check_in_service.dart';
import 'member_search_screen.dart';
import '../widgets/attendee_list_item.dart';

class ClassScreen extends StatefulWidget {
  final ClassSession classSession;

  const ClassScreen({super.key, required this.classSession});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  List<CheckIn> _checkIns = [];
  List<Member> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final checkInService = Provider.of<CheckInService>(context, listen: false);
    final checkIns = await checkInService.getCheckInsForClass(widget.classSession.id);
    final allMembers = await DataService.loadMembers();
    
    setState(() {
      _checkIns = checkIns;
      _members = allMembers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classSession.name),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildClassInfo(),
                _buildAttendeesSection(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberSearchScreen(
                classSessionId: widget.classSession.id,
              ),
            ),
          );
          if (result == true) {
            _loadData();
          }
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Check-In'),
      ),
    );
  }

  Widget _buildClassInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.classSession.name,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  widget.classSession.timeRange,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  widget.classSession.instructor,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            if (widget.classSession.description != null) ...[
              const SizedBox(height: 12),
              Text(
                widget.classSession.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 12),
            Text(
              '${_checkIns.length} / ${widget.classSession.capacity} attendees',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _checkIns.length >= widget.classSession.capacity
                        ? Colors.red
                        : Colors.green,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendeesSection() {
    if (_checkIns.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No check-ins yet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the button below to add a check-in',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _checkIns.length,
        itemBuilder: (context, index) {
          final checkIn = _checkIns[index];
          final member = _members.firstWhere(
            (m) => m.id == checkIn.memberId,
            orElse: () => Member(
                id: checkIn.memberId,
                firstName: 'Unknown',
                lastName: 'Member',
                profilePicture: null, 
            ),
            );
          return AttendeeListItem(
            member: member,
            checkIn: checkIn,
          );
        },
      ),
    );
  }
}