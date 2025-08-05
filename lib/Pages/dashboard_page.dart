import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final userName = authService.userName ?? 'User';

        return Scaffold(
          backgroundColor: Color(0xFFFAFAFA),
          appBar: AppBar(
            title: Text('🍪 Sandy\'s Snacks'),
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF0A0A0B),
            elevation: 1,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => authService.signOut(),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome, $userName! 👋',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A0A0B),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Ready for some amazing snacks?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF52525B),
                  ),
                ),
                SizedBox(height: 40),

                // Simple status card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFE4E4E7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Status',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0A0A0B),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '🎉 Welcome to Sandy\'s Snacks!\nYour account is set up and ready to go.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF52525B),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
