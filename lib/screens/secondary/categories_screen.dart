import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';
import '../../core/navigation/route_names.dart';
import '../../widgets/bottom_nav.dart';

/// Categories Screen - Pixel-perfect match to React version
/// Matches: components/screens/categories-screen.tsx
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedCategory;
  late AnimationController _animationController;

  final _categories = [
    {
      'id': 1,
      'icon': Icons.menu_book,
      'label': 'الأدب العربي',
      'courses': 24,
      'color': AppColors.purple,
    },
    {
      'id': 2,
      'icon': Icons.calculate,
      'label': 'الرياضيات',
      'courses': 32,
      'color': AppColors.orange,
    },
    {
      'id': 3,
      'icon': Icons.science,
      'label': 'الكيمياء',
      'courses': 18,
      'color': AppColors.purple,
    },
    {
      'id': 4,
      'icon': Icons.language,
      'label': 'اللغة الإنجليزية',
      'courses': 45,
      'color': AppColors.orange,
    },
    {
      'id': 5,
      'icon': Icons.bolt,
      'label': 'الفيزياء',
      'courses': 21,
      'color': AppColors.purple,
    },
    {
      'id': 6,
      'icon': Icons.code,
      'label': 'البرمجة',
      'courses': 38,
      'color': AppColors.orange,
    },
    {
      'id': 7,
      'icon': Icons.palette,
      'label': 'التصميم',
      'courses': 27,
      'color': AppColors.purple,
    },
    {
      'id': 8,
      'icon': Icons.music_note,
      'label': 'الموسيقى',
      'courses': 15,
      'color': AppColors.orange,
    },
    {
      'id': 9,
      'icon': Icons.business,
      'label': 'إدارة الأعمال',
      'courses': 30,
      'color': AppColors.purple,
    },
    {
      'id': 10,
      'icon': Icons.favorite,
      'label': 'التنمية البشرية',
      'courses': 22,
      'color': AppColors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleCategoryClick(Map<String, dynamic> category) {
    setState(() {
      _selectedCategory = category['id'] as int;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      final course = {
        'id': category['id'],
        'title': 'دورة ${category['label']}',
        'category': category['label'],
        'instructor': 'محمد أحمد',
        'rating': 4.8,
        'hours': 48,
        'price': 35.0,
        'lessons': [
          {
            'id': 1,
            'title': 'المقدمة',
            'duration': '2 دقيقة 18 ثانية',
            'completed': true,
            'locked': false,
          },
          {
            'id': 2,
            'title': 'الدرس الأول',
            'duration': '18 دقيقة 46 ثانية',
            'completed': false,
            'locked': true,
          },
          {
            'id': 3,
            'title': 'الدرس الثاني',
            'duration': '20 دقيقة 58 ثانية',
            'completed': false,
            'locked': true,
          },
          {
            'id': 4,
            'title': 'الدرس الثالث',
            'duration': '15 دقيقة 30 ثانية',
            'completed': false,
            'locked': true,
          },
        ],
      };
      if (mounted) {
        context.push(RouteNames.courseDetails, extra: course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 400
                    ? (MediaQuery.of(context).size.width - 400) / 2
                    : 0,
              ),
              child: Column(
                children: [
                  // Header - matches React: bg-[var(--purple)] rounded-b-[3rem] pt-4 pb-8 px-4
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.largeCard),
                        bottomRight: Radius.circular(AppRadius.largeCard),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 16, // pt-4
                      bottom: 32, // pb-8
                      left: 16, // px-4
                      right: 16,
                    ),
                    child: Column(
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
                              'التصنيفات',
                              style: AppTextStyles.h2(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16), // mb-4
                        // Subtitle
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'اختر المادة التي تريد تعلمها',
                            style: AppTextStyles.bodyMedium(
                              color: Colors.white.withOpacity(0.7), // white/70
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Categories Grid - matches React: px-4 -mt-6
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, -24), // -mt-6 = -24px
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16, // gap-4
                            mainAxisSpacing: 16, // gap-4
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = _selectedCategory == category['id'];
                            final color = category['color'] as Color;

                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 500 + (index * 50)),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.scale(
                                    scale: 0.8 + (value * 0.2),
                                    child: child,
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () => _handleCategoryClick(category),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24), // rounded-3xl
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05), // shadow-sm
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Gradient overlay on hover (simulated)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(24),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                color.withOpacity(0.1),
                                                color.withOpacity(0.05),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Content - matches React: p-5
                                      Padding(
                                        padding: const EdgeInsets.all(20), // p-5
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Icon - matches React: w-16 h-16 rounded-2xl mb-4
                                            Container(
                                              width: 64, // w-16
                                              height: 64, // h-16
                                              decoration: BoxDecoration(
                                                color: color.withOpacity(0.15), // color15
                                                borderRadius:
                                                    BorderRadius.circular(16), // rounded-2xl
                                              ),
                                              child: Icon(
                                                category['icon'] as IconData,
                                                size: 32, // w-8 h-8
                                                color: color,
                                              ),
                                            ),
                                            const SizedBox(height: 16), // mb-4

                                            // Title - matches React: font-bold text-lg mb-1
                                            Text(
                                              category['label'] as String,
                                              style: AppTextStyles.h4(
                                                color: AppColors.foreground,
                                              ),
                                            ),
                                            const SizedBox(height: 4), // mb-1

                                            // Courses count - matches React: text-sm
                                            Text(
                                              '${category['courses']} دورة',
                                              style: AppTextStyles.bodySmall(
                                                color: AppColors.mutedForeground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Animated corner accent
                                      Positioned(
                                        bottom: -16,
                                        left: -16,
                                        child: Container(
                                          width: 64, // w-16
                                          height: 64, // h-16
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            const BottomNav(activeTab: 'home'),
          ],
        ),
      ),
    );
  }
}
