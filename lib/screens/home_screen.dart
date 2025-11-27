import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/class_session.dart';
import '../services/data_service.dart';
import '../services/check_in_service.dart';
import 'class_screen.dart';
import '../widgets/class_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ClassSession> _classes = [];
  Map<String, int> _attendeeCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() => _isLoading = true);
    final classes = await DataService.loadClasses();
    final checkInService = Provider.of<CheckInService>(context, listen: false);
    
    // Load attendee counts for each class
    final Map<String, int> counts = {};
    for (var classSession in classes) {
      final checkIns = await checkInService.getCheckInsForClass(classSession.id);
      counts[classSession.id] = checkIns.length;
    }
    
    setState(() {
      _classes = classes;
      _attendeeCounts = counts;
      _isLoading = false;
    });
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekday = DateFormat('EEEE').format(now);
    final day = now.day;
    final month = DateFormat('MMMM').format(now);
    
    // Get ordinal suffix
    String suffix = 'th';
    if (day % 10 == 1 && day % 100 != 11) {
      suffix = 'st';
    } else if (day % 10 == 2 && day % 100 != 12) {
      suffix = 'nd';
    } else if (day % 10 == 3 && day % 100 != 13) {
      suffix = 'rd';
    }
    
    return '${weekday.toUpperCase()}, ${day}$suffix ${month.toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadClasses,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Date
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 8),
                      child: Text(
                        _getFormattedDate(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                      ),
                    ),
                    // Welcome Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'Welcome to ',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                          ),
                          // Logo placeholder (spider/circle icon)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: Icon(Icons.circle, size: 30, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Aranha',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Summer BJJ Bootcamp Banner
                    _buildPromoBanner(
                      backgroundColor: const Color(0xFF1A1A1A),
                      title: 'EXPERIENCES',
                      subtitle: 'Summer BJJ Bootcamp',
                      description: 'Roll more, learn more, sweat more. Summer starts on the mat.',
                      rightWidget: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF6B35),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B35).withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              '24.7',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Today's classes section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Today's classes",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Classes Grid
                    if (_classes.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No classes today',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _classes.length,
                          itemBuilder: (context, index) {
                            final classSession = _classes[index];
                            return ClassCard(
                              classSession: classSession,
                              attendeeCount: _attendeeCounts[classSession.id] ?? 0,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClassScreen(classSession: classSession),
                                  ),
                                );
                                if (result == true) {
                                  _loadClasses();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 32),
                    // Aranha x MAAT Store Banner
                    _buildPromoBanner(
                      backgroundColor: const Color(0xFFDC143C),
                      title: 'Aranha x MAAT Store',
                      description: 'Roll more, learn more, sweat more. Summer starts on the mat.',
                      rightWidget: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Pro Tip Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.qr_code_scanner, color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Pro tip: Open your MAAT app and bump this device, you will be checked in automatically.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPromoBanner({
    required Color backgroundColor,
    required String title,
    String? subtitle,
    required String description,
    required Widget rightWidget,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          rightWidget,
        ],
      ),
    );
  }
}
