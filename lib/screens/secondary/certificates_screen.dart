import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';

/// Certificates Screen - Pixel-perfect match to React version
/// Matches: components/screens/certificates-screen.tsx
class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  // Static data matching React exactly
  static const _certificates = [
    {
      'id': 1,
      'courseName': 'أساسيات تصميم واجهات المستخدم',
      'studentName': 'يعقوب أحمد',
      'completionDate': '15 ديسمبر 2024',
      'grade': 'ممتاز',
      'certificateId': 'CERT-2024-001',
    },
    {
      'id': 2,
      'courseName': 'البرمجة بلغة بايثون للمبتدئين',
      'studentName': 'يعقوب أحمد',
      'completionDate': '10 ديسمبر 2024',
      'grade': 'جيد جداً',
      'certificateId': 'CERT-2024-002',
    },
    {
      'id': 3,
      'courseName': 'أساسيات الرياضيات',
      'studentName': 'يعقوب أحمد',
      'completionDate': '5 ديسمبر 2024',
      'grade': 'ممتاز',
      'certificateId': 'CERT-2024-003',
    },
  ];

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
                        'الشهادات',
                        style: AppTextStyles.h3(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // mb-4
                  // Certificate count - matches React: gap-2
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 20, // w-5 h-5
                        color: Colors.white.withOpacity(0.7), // white/70
                      ),
                      const SizedBox(width: 8), // gap-2
                      Text(
                        '${_certificates.length} شهادات محققة',
                        style: AppTextStyles.bodyMedium(
                          color: Colors.white.withOpacity(0.7), // white/70
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content - matches React: px-4 -mt-4 space-y-4
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -16), // -mt-4
                child: _certificates.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _certificates.length,
                        itemBuilder: (context, index) {
                          final cert = _certificates[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration:
                                Duration(milliseconds: 500 + (index * 100)),
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
                            child: _buildCertificateCard(cert),
                          );
                        },
                      )
                    : _buildEmptyState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateCard(Map<String, dynamic> cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // space-y-4
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // rounded-3xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Certificate Preview - matches React: bg-gradient-to-bl p-6 border-b-2 border-dashed
          Container(
            padding: const EdgeInsets.all(24), // p-6
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.purple.withOpacity(0.1),
                  AppColors.orange.withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.purple.withOpacity(0.2),
                  width: 2,
                  style: BorderStyle
                      .solid, // Flutter doesn't have dashed, using solid
                ),
              ),
            ),
            child: Column(
              children: [
                // Award icon - matches React: w-16 h-16 rounded-full
                Container(
                  width: 64, // w-16
                  height: 64, // h-16
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [AppColors.orange, AppColors.purple],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 32, // w-8 h-8
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16), // mb-4

                // Certificate title - matches React
                Text(
                  'شهادة إتمام',
                  style: AppTextStyles.h4(
                    color: AppColors.foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4), // mb-1

                // Course name - matches React
                Text(
                  cert['courseName'] as String,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.purple,
                  ).copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12), // mb-3

                // "Certifies that" text
                Text(
                  'يشهد بأن',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8), // my-2

                // Student name - matches React: text-xl font-bold
                Text(
                  cert['studentName'] as String,
                  style: AppTextStyles.h3(
                    color: AppColors.foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8), // my-2

                // "Has completed with grade" text
                Text(
                  'قد أتم هذه الدورة بتقدير',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Grade - matches React: font-bold text-[var(--orange)] text-lg
                Text(
                  cert['grade'] as String,
                  style: AppTextStyles.h4(
                    color: AppColors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Certificate Info - matches React: p-4
          Padding(
            padding: const EdgeInsets.all(16), // p-4
            child: Column(
              children: [
                // Date and ID row - matches React: mb-4
                Padding(
                  padding: const EdgeInsets.only(bottom: 16), // mb-4
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16, // w-4 h-4
                            color: AppColors.mutedForeground,
                          ),
                          const SizedBox(width: 8), // gap-2
                          Text(
                            cert['completionDate'] as String,
                            style: AppTextStyles.bodySmall(
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '#${cert['certificateId']}',
                        style: AppTextStyles.labelSmall(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons - matches React: flex gap-3
                Row(
                  children: [
                    // Download button - matches React: flex-1 bg-[var(--purple)]
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12), // py-3
                        decoration: BoxDecoration(
                          color: AppColors.purple,
                          borderRadius: BorderRadius.circular(12), // rounded-xl
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.download,
                              size: 20, // w-5 h-5
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8), // gap-2
                            Text(
                              'تحميل',
                              style: AppTextStyles.bodyMedium(
                                color: Colors.white,
                              ).copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), // gap-3
                    // Share button - matches React: flex-1 bg-[var(--orange)]/10
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12), // py-3
                        decoration: BoxDecoration(
                          color: AppColors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12), // rounded-xl
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.share,
                              size: 20, // w-5 h-5
                              color: AppColors.orange,
                            ),
                            const SizedBox(width: 8), // gap-2
                            Text(
                              'مشاركة',
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.orange,
                              ).copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96, // w-24
              height: 96, // h-24
              decoration: const BoxDecoration(
                color: AppColors.lavenderLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                size: 48, // w-12 h-12
                color: AppColors.purple,
              ),
            ),
            const SizedBox(height: 16), // mb-4
            Text(
              'لا توجد شهادات بعد',
              style: AppTextStyles.h4(
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 8), // mb-2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'أكمل الدورات للحصول على شهادات معتمدة',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
