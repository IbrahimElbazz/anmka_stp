import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';

/// Notifications Screen - Pixel-perfect match to React version
/// Matches: components/screens/notifications-screen.tsx
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Static data matching React exactly
  final _notifications = [
    {
      'id': 1,
      'type': 'course',
      'title': 'درس جديد متاح',
      'message': 'تم إضافة درس جديد في دورة تصميم واجهات المستخدم',
      'time': 'منذ 5 دقائق',
      'isNew': true,
      'icon': Icons.menu_book,
      'color': AppColors.purple,
    },
    {
      'id': 2,
      'type': 'achievement',
      'title': 'تهانينا! حصلت على شهادة',
      'message': 'لقد أكملت دورة أساسيات البرمجة بنجاح',
      'time': 'منذ ساعة',
      'isNew': true,
      'icon': Icons.emoji_events,
      'color': AppColors.orange,
    },
    {
      'id': 3,
      'type': 'message',
      'title': 'رسالة من المعلم',
      'message': 'أحمد محمد أرسل لك رسالة جديدة',
      'time': 'منذ 3 ساعات',
      'isNew': true,
      'icon': Icons.message,
      'color': AppColors.purple,
    },
    {
      'id': 4,
      'type': 'announcement',
      'title': 'عرض خاص',
      'message': 'خصم 50% على جميع الدورات لفترة محدودة',
      'time': 'أمس',
      'isNew': false,
      'icon': Icons.campaign,
      'color': AppColors.orange,
    },
    {
      'id': 5,
      'type': 'course',
      'title': 'تذكير',
      'message': 'لم تكمل درس الفيزياء الحديثة بعد',
      'time': 'منذ يومين',
      'isNew': false,
      'icon': Icons.menu_book,
      'color': AppColors.purple,
    },
  ];

  List<Map<String, dynamic>> get _newNotifications =>
      _notifications.where((n) => n['isNew'] == true).toList();

  List<Map<String, dynamic>> get _readNotifications =>
      _notifications.where((n) => n['isNew'] != true).toList();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title - matches React: gap-4 mb-4
                  Row(
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
                        'الإشعارات',
                        style: AppTextStyles.h3(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // mb-4
                  // Notification count - matches React: gap-2
                  Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 20, // w-5 h-5
                        color: Colors.white.withOpacity(0.7), // white/70
                      ),
                      const SizedBox(width: 8), // gap-2
                      Text(
                        '${_newNotifications.length} إشعارات جديدة',
                        style: AppTextStyles.bodyMedium(
                          color: Colors.white.withOpacity(0.7), // white/70
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content - matches React: px-4 -mt-4 space-y-6
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -16), // -mt-4
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24), // space-y-6

                      // New Notifications section
                      if (_newNotifications.isNotEmpty) ...[
                        Text(
                          'جديد',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.foreground,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12), // mb-3
                        ..._newNotifications.asMap().entries.map((entry) {
                          final index = entry.key;
                          final notification = entry.value;
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration:
                                Duration(milliseconds: 400 + (index * 100)),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildNotificationCard(notification,
                                isNew: true),
                          );
                        }),
                      ],

                      const SizedBox(height: 24), // space-y-6

                      // Read Notifications section
                      if (_readNotifications.isNotEmpty) ...[
                        Text(
                          'سابقة',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.foreground,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12), // mb-3
                        ..._readNotifications.asMap().entries.map((entry) {
                          final index = entry.key;
                          final notification = entry.value;
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(
                              milliseconds: 400 +
                                  ((_newNotifications.length + index) * 100),
                            ),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildNotificationCard(notification,
                                isNew: false),
                          );
                        }),
                      ],

                      // Empty state - matches React
                      if (_notifications.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 96, // w-24
                                height: 96, // h-24
                                decoration: BoxDecoration(
                                  color: AppColors.lavenderLight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.notifications,
                                  size: 48, // w-12 h-12
                                  color: AppColors.purple,
                                ),
                              ),
                              const SizedBox(height: 16), // mb-4
                              Text(
                                'لا توجد إشعارات',
                                style: AppTextStyles.h4(
                                  color: AppColors.foreground,
                                ),
                              ),
                              const SizedBox(height: 8), // mb-2
                              Text(
                                'ستظهر الإشعارات الجديدة هنا',
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.mutedForeground,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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

  Widget _buildNotificationCard(Map<String, dynamic> notification,
      {required bool isNew}) {
    final color = notification['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12), // space-y-3
      decoration: BoxDecoration(
        color: isNew
            ? Colors.white
            : Colors.white.withOpacity(0.7), // bg-white or bg-white/70
        borderRadius: BorderRadius.circular(16), // rounded-2xl
        boxShadow: isNew
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Purple indicator for new notifications - matches React
          if (isNew)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: 8, // w-2
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),

          // Content - matches React: flex items-start gap-3 pr-3
          Padding(
            padding: EdgeInsets.only(
              top: 16, // p-4
              bottom: 16,
              left: 16,
              right: isNew ? 24 : 16, // pr-3 for new notifications
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container - matches React: w-12 h-12 rounded-xl
                Container(
                  width: 48, // w-12
                  height: 48, // h-12
                  decoration: BoxDecoration(
                    color: color.withOpacity(
                        isNew ? 0.15 : 0.1), // color15 or opacity-60
                    borderRadius: BorderRadius.circular(12), // rounded-xl
                  ),
                  child: Icon(
                    notification['icon'] as IconData,
                    size: 24, // w-6 h-6
                    color: isNew ? color : color.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 12), // gap-3
                // Text content - matches React: flex-1
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'] as String,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.foreground,
                        ).copyWith(
                          fontWeight: isNew ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4), // mb-1
                      Text(
                        notification['message'] as String,
                        style: AppTextStyles.bodySmall(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 8), // mb-2
                      Text(
                        notification['time'] as String,
                        style: AppTextStyles.labelSmall(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
