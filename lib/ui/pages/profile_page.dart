import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../core/theme.dart';
import '../widgets/bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) return const SizedBox();
          final user = state.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.warmBeige,
                  backgroundImage: user.photoUrl.isNotEmpty
                      ? CachedNetworkImageProvider(user.photoUrl)
                      : null,
                  child: user.photoUrl.isEmpty
                      ? Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.forestGreen),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(user.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                Text(user.email, style: const TextStyle(color: AppTheme.greyText, fontSize: 14)),

                const SizedBox(height: 36),

                // Menu items
                _menuItem(context, Icons.person_outline, 'Edit Profile', () {}),
                _menuItem(context, Icons.notifications_outlined, 'Notifications', () {}),
                _menuItem(context, Icons.help_outline, 'Help & Support', () {}),
                _menuItem(context, Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
                _menuItem(context, Icons.info_outline, 'About CampsiteMY', () {}),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),

                ListTile(
                  onTap: () => _signOutConfirm(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                  tileColor: Colors.red.withOpacity(0.06),
                ),

                const SizedBox(height: 24),
                Text('CampsiteMY v1.0.0',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.forestGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.forestGreen, size: 20),
        ),
        title: Text(label, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.greyText),
      ),
    );
  }

  void _signOutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
