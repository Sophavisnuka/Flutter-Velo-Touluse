import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/states/user_global_state.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/list_tile_card.dart';
import 'package:velo_toulouse/ui/widgets/primary_button.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/pass_detail_screen.dart';
import 'package:velo_toulouse/util/formatter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlanCard(context),
                  const SizedBox(height: 20),
                  _buildSettingsSection(),
                  const SizedBox(height: 20),
                  // _buildSignOutButton(),
                  PrimaryButton(
                    onViewDetails: () {}, 
                    text: "Sign out", 
                    icon: Icons.logout
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userVm = context.watch<UserGlobalState>();
    final user = userVm.user;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 48, left: 20, right: 20),
      color: AppTheme.primary,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppTheme.primary.withOpacity(0.15), width: 3),
            ),
            child: const Icon(Icons.person, size: 32, color: AppTheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            user?.username ?? 'Guest',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context) {
    final provider = context.watch<UserGlobalState>();
    final user = provider.user;
    final pass = user?.passType ?? PassType.none;
    final expiry = provider.expiresAt;
    final expiryText = expiry != null ? Formatter.expiry(expiry) : '—';

    final card = Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: pass.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(pass.icon, size: 18, color: pass.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pass.label, style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text('Expire date: $expiryText', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: pass.isActive
                    ? AppTheme.secondary.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                pass.isActive ? 'Active' : 'No Plan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: pass.isActive ? AppTheme.secondary : Colors.grey,
                ),
              ),
            ),
            if (pass.isActive) ...[
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ],
        ),
      ),
    );

    if (!pass.isActive) return card;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PassDetailScreen()),
      ),
      child: card,
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SETTINGS',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.8, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12, width: 0.5),
          ),
          child: Column(
            children: [
              ListTileCard(
                color: Colors.grey, 
                bgColor: Colors.white, 
                icon: Icons.person_outline, 
                title: 'Edit Profile',
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.grey,
                  size: 15,
                ),
              ),
              ListTileCard(
                color: Colors.grey, 
                bgColor: Colors.white, 
                icon: Icons.notifications_outlined, 
                title: 'Notifications',
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.grey,
                  size: 15,
                ),
              ),
              ListTileCard(
                color: Colors.grey, 
                bgColor: Colors.white, 
                icon: Icons.language, 
                title: 'Language',
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.grey,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}