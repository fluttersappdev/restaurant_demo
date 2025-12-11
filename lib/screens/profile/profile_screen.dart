import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/profile.svg',
                        width: 50,
                        height: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),

                  // User Email
                  Text(
                    'john.doe@example.com',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Edit profile functionality
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Addresses',
                    onTap: () {
                      // Navigate to delivery addresses
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    context,
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    onTap: () {
                      // Navigate to payment methods
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    context,
                    icon: Icons.history_outlined,
                    title: 'Order History',
                    onTap: () {
                      // Navigate to order history
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // Navigate to notifications
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // Navigate to help & support
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      // Navigate to about
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      // Logout functionality
                    },
                    textColor: AppTheme.errorColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App Version
            Text(
              'QuickBite v1.0.0',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color? textColor,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppTheme.darkTextColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: textColor ?? AppTheme.lightTextColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}