import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';

/// Settings Screen - Pixel-perfect match to React version
/// Matches: components/screens/settings-screen.tsx
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header - Purple gradient like Home
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.largeCard),
                  bottomRight: Radius.circular(AppRadius.largeCard),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16, // pt-4
                bottom: 32, // pb-8
                left: 16, // px-4
                right: 16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, // w-10
                      height: 40, // h-10
                      decoration: BoxDecoration(
                        color: AppColors.whiteOverlay20, // bg-white/20
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 20, // w-5 h-5
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // gap-4
                  Text(
                    'الإعدادات',
                    style: AppTextStyles.h3(color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content - matches React: px-4 -mt-4
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -16), // -mt-4
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile section - matches React: bg-white rounded-3xl p-5 mb-6
                      Container(
                        margin: const EdgeInsets.only(bottom: 24), // mb-6
                        padding: const EdgeInsets.all(20), // p-5
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(24), // rounded-3xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar - matches React: w-16 h-16 rounded-full
                            Container(
                              width: 64, // w-16
                              height: 64, // h-16
                              decoration: BoxDecoration(
                                color: AppColors.orangeLight,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/user-avatar.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.person,
                                    size: 32,
                                    color: AppColors.purple,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16), // gap-4
                            // User info - matches React: flex-1
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'يعقوب أحمد',
                                    style: AppTextStyles.h3(
                                      color: AppColors.foreground,
                                    ),
                                  ),
                                  Text(
                                    'yaqoub@email.com',
                                    style: AppTextStyles.bodyMedium(
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Edit button - matches React: w-10 h-10 rounded-xl
                            Container(
                              width: 40, // w-10
                              height: 40, // h-10
                              decoration: BoxDecoration(
                                color: AppColors.lavenderLight,
                                borderRadius:
                                    BorderRadius.circular(12), // rounded-xl
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 20, // w-5 h-5
                                color: AppColors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Settings title - matches React: text-lg font-bold mb-4
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16), // mb-4
                        child: Text(
                          'الإعدادات العامة',
                          style: AppTextStyles.h4(
                            color: AppColors.foreground,
                          ),
                        ),
                      ),

                      // Language setting - matches React SettingItem
                      _buildSettingItem(
                        icon: Icons.language,
                        label: 'اللغة',
                        value: 'العربية',
                      ),

                      // Notifications toggle - matches React SettingItem with toggle
                      _buildSettingItem(
                        icon: Icons.notifications,
                        label: 'الإشعارات',
                        hasToggle: true,
                        toggleValue: _notifications,
                        onToggle: () {
                          setState(() {
                            _notifications = !_notifications;
                          });
                        },
                      ),

                      // Dark mode toggle - matches React SettingItem with toggle
                      _buildSettingItem(
                        icon: Icons.dark_mode,
                        label: 'الوضع الداكن',
                        hasToggle: true,
                        toggleValue: _darkMode,
                        onToggle: () {
                          setState(() {
                            _darkMode = !_darkMode;
                          });
                        },
                      ),

                      // Privacy setting
                      _buildSettingItem(
                        icon: Icons.shield,
                        label: 'الخصوصية والأمان',
                      ),

                      // Help setting
                      _buildSettingItem(
                        icon: Icons.help,
                        label: 'المساعدة والدعم',
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    String? value,
    bool hasToggle = false,
    bool toggleValue = false,
    VoidCallback? onToggle,
  }) {
    return GestureDetector(
      onTap: hasToggle ? onToggle : () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // mb-3
        padding: const EdgeInsets.all(16), // p-4
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // rounded-2xl
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon and label - matches React: gap-3
            Row(
              children: [
                Container(
                  width: 40, // w-10
                  height: 40, // h-10
                  decoration: BoxDecoration(
                    color: AppColors.lavenderLight,
                    borderRadius: BorderRadius.circular(12), // rounded-xl
                  ),
                  child: Icon(
                    icon,
                    size: 20, // w-5 h-5
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(width: 12), // gap-3
                Text(
                  label,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.foreground,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            // Value or toggle
            if (hasToggle)
              // Toggle switch - matches React custom toggle
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 48, // w-12
                  height: 28, // h-7
                  padding: const EdgeInsets.all(4), // p-1
                  decoration: BoxDecoration(
                    color: toggleValue ? AppColors.purple : Colors.grey[200],
                    borderRadius: BorderRadius.circular(999), // rounded-full
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: toggleValue
                        ? Alignment.centerLeft // RTL: toggle moves left when on
                        : Alignment.centerRight,
                    child: Container(
                      width: 20, // w-5
                      height: 20, // h-5
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              Row(
                children: [
                  if (value != null)
                    Text(
                      value,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  const SizedBox(width: 8), // gap-2
                  const Icon(
                    Icons.chevron_left,
                    size: 20, // w-5 h-5
                    color: AppColors.mutedForeground,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
