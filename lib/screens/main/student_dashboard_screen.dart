import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_radius.dart';
import '../../core/navigation/route_names.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/auth_service.dart';

/// Student Dashboard Screen - Simple Modern Design
class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'تسجيل الخروج',
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: GoogleFonts.cairo(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'إلغاء',
              style: GoogleFonts.cairo(
                color: AppColors.mutedForeground,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'تسجيل الخروج',
              style: GoogleFonts.cairo(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !context.mounted) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'جاري تسجيل الخروج...',
                style: GoogleFonts.cairo(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Call logout API
      await AuthService.instance.logout();

      if (!context.mounted) return;

      // Clear local preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('hasLaunched');

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to splash/login screen
      if (context.mounted) {
        context.go(RouteNames.splash);
      }
    } catch (e) {
      if (!context.mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تسجيل الخروج: ${e.toString().replaceFirst('Exception: ', '')}',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final menuItems = [
      {
        'icon': Icons.menu_book_rounded,
        'label': 'الدروس المشترك بها',
        'subtitle': '12 دورة نشطة',
        'color': const Color(0xFF7C3AED),
        'bgColor': const Color(0xFFEDE9FE),
        'onTap': () => context.push(RouteNames.enrolled),
      },
      {
        'icon': Icons.assignment_rounded,
        'label': 'اختباراتي',
        'subtitle': '3 اختبارات قادمة',
        'color': const Color(0xFFF97316),
        'bgColor': const Color(0xFFFFF7ED),
        'onTap': () => context.push(RouteNames.myExams),
      },
      {
        'icon': Icons.videocam_rounded,
        'label': 'الكورسات اللايف',
        'subtitle': 'جلسة في انتظارك',
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFFD1FAE5),
        'onTap': () => context.push(RouteNames.liveCourses),
      },
      {
        'icon': Icons.emoji_events_rounded,
        'label': 'الشهادات',
        'subtitle': '5 شهادات محققة',
        'color': const Color(0xFFEAB308),
        'bgColor': const Color(0xFFFEF9C3),
        'onTap': () => context.push(RouteNames.certificates),
      },
      {
        'icon': Icons.download_rounded,
        'label': 'التحميلات',
        'subtitle': '8 ملفات محفوظة',
        'color': const Color(0xFF3B82F6),
        'bgColor': const Color(0xFFDBEAFE),
        'onTap': () => context.push(RouteNames.downloads),
      },
      {
        'icon': Icons.settings_rounded,
        'label': 'الإعدادات',
        'subtitle': 'تخصيص التطبيق',
        'color': const Color(0xFF6B7280),
        'bgColor': const Color(0xFFF3F4F6),
        'onTap': () => context.push(RouteNames.settings),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'القائمة الرئيسية',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Menu Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          return _buildMenuItem(
                            icon: item['icon'] as IconData,
                            label: item['label'] as String,
                            subtitle: item['subtitle'] as String,
                            color: item['color'] as Color,
                            bgColor: item['bgColor'] as Color,
                            onTap: item['onTap'] as VoidCallback,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Logout Button
                      GestureDetector(
                        onTap: () => _handleLogout(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded,
                                  color: Colors.red[600], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'تسجيل الخروج',
                                style: GoogleFonts.cairo(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Delete Account
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'حذف الحساب',
                            style: GoogleFonts.cairo(
                                fontSize: 13, color: Colors.red[300]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Navigation
          const BottomNav(activeTab: 'dashboard'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.largeCard),
          bottomRight: Radius.circular(AppRadius.largeCard),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go(RouteNames.home),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  Text(
                    'حسابي',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(RouteNames.settings),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.edit_outlined,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Profile Section
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/student-avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white,
                      child: const Icon(
                        Icons.person,
                        size: 45,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'يعقوب أحمد',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'yaqoub@email.com',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 16),

              // Stats Row
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStat('12', 'دورة', Icons.play_circle_fill_rounded),
                    Container(
                      width: 1,
                      height: 25,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStat('5', 'شهادة', Icons.emoji_events_rounded),
                    Container(
                      width: 1,
                      height: 25,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStat('48', 'ساعة', Icons.access_time_filled_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(0.8)),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
