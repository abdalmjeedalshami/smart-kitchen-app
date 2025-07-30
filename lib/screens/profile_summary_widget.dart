import 'package:flutter/material.dart';
import 'package:meal_app_planner/services/profile_service.dart';

class ProfileSummaryWidget extends StatefulWidget {
  const ProfileSummaryWidget({super.key});

  @override
  State<ProfileSummaryWidget> createState() => _ProfileSummaryWidgetState();
}

class _ProfileSummaryWidgetState extends State<ProfileSummaryWidget> {
  String _userName = '';
  int _peopleCount = 1;
  List<String> _diseases = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final profileData = await ProfileService.getUserProfile();
    setState(() {
      _userName = profileData['name'];
      _peopleCount = profileData['peopleCount'];
      _diseases = List<String>.from(profileData['diseases']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      color: const Color(0xFFFFF6F0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  _userName.isNotEmpty ? _userName : 'الملف الشخصي',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.people, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'عدد الأشخاص: $_peopleCount',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            if (_diseases.isNotEmpty && !_diseases.contains('None')) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.medical_services,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'الأمراض:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children:
                    _diseases
                        .where((d) => d != 'None')
                        .map(
                          (disease) => Chip(
                            label: Text(
                              disease,
                              style: const TextStyle(fontSize: 13),
                            ),
                            backgroundColor: Colors.red.withOpacity(0.08),
                            labelStyle: const TextStyle(color: Colors.red),
                          ),
                        )
                        .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
