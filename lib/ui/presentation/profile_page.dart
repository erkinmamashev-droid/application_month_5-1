import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _menuItems = [
    ('ACCOUNT', true),
    ('SETTINGS', true),
    ('GENRES PREFERENCES', true),
    ('LOGOUT', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 32, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF252525),
                ),
              ),
              const SizedBox(height: 28),
              const Divider(height: 1, color: Color(0xFFD8D8D8)),
              for (final item in _menuItems)
                _PreferenceMenuItem(label: item.$1, hasChevron: item.$2),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferenceMenuItem extends StatelessWidget {
  const _PreferenceMenuItem({required this.label, required this.hasChevron});

  final String label;
  final bool hasChevron;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD8D8D8))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF303030),
              ),
            ),
          ),
          if (hasChevron)
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF303030)),
        ],
      ),
    );
  }
}
