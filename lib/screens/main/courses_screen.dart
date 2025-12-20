import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';
import '../../core/navigation/route_names.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/course_card_courses.dart';
import '../../widgets/subject_chip.dart';

/// Courses Screen - Pixel-perfect match to React version
/// Matches: components/screens/courses-screen.tsx
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _activeSubject = 'الرياضيات';

  final _subjects = [
    {'icon': '📚', 'label': 'الأدب'},
    {'icon': '📐', 'label': 'الرياضيات'},
    {'icon': '🧬', 'label': 'الأحياء'},
    {'icon': '⚛️', 'label': 'الفيزياء'},
    {'icon': '🧪', 'label': 'الكيمياء'},
  ];

  void _handleCourseClick(Map<String, dynamic> courseData) {
    final course = {
      'id': 1,
      'title': courseData['title'],
      'category': courseData['category'],
      'instructor': 'محمد أحمد',
      'rating': 4.8,
      'hours': 48,
      'price': 0.0, // Default to free
      'isFree': true,
      'youtubeVideoId': 'AevtORdu4pc',
      'banner': 'assets/images/motion-graphics-course-in-mumbai.png',
      'lessons': [
        {
          'id': 1,
          'title': 'المقدمة',
          'duration': '2 دقيقة 18 ثانية',
          'completed': true,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc',
        },
        {
          'id': 2,
          'title': 'ما هو التصميم؟',
          'duration': '18 دقيقة 46 ثانية',
          'completed': false,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc',
        },
        {
          'id': 3,
          'title': 'كيفية إنشاء الإطار السلكي',
          'duration': '20 دقيقة 58 ثانية',
          'completed': false,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc',
        },
        {
          'id': 4,
          'title': 'تصميمك الأول',
          'duration': '15 دقيقة 30 ثانية',
          'completed': false,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc',
        },
      ],
      'exam': {
        'id': 1,
        'title': 'امتحان الكورس',
        'questions': [
          {
            'id': 1,
            'question': 'ما هو موضوع هذا الكورس؟',
            'options': ['الخيار الأول', 'الخيار الثاني', 'الخيار الثالث', 'الخيار الرابع'],
            'correctAnswer': 0,
          },
          {
            'id': 2,
            'question': 'ما هي المهارات التي ستتعلمها؟',
            'options': ['مهارة 1', 'مهارة 2', 'مهارة 3', 'مهارة 4'],
            'correctAnswer': 1,
          },
        ],
      },
    };
    context.push(RouteNames.courseDetails, extra: course);
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
                  // Orange header section - matches React: bg-[var(--orange)] pt-4 pb-8 px-4
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.orange, // NOT purple!
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
                    constraints: const BoxConstraints(minHeight: 220),
                    child: Stack(
                      children: [
                        // Decorative elements - matches React
                        Positioned(
                          top: 32, // top-8
                          left: 32, // left-8
                          child: Container(
                            width: 8, // w-2
                            height: 8, // h-2
                            decoration: BoxDecoration(
                              color: AppColors.whiteOverlay40, // bg-white/40
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 80, // top-20
                          right: 48, // right-12
                          child: Text(
                            '⭐',
                            style: TextStyle(
                              fontSize: 24, // text-2xl
                              color: AppColors.whiteOverlay20, // white/20
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 80, // bottom-20
                          left: 80, // left-20
                          child: Text(
                            '✦',
                            style: TextStyle(
                              fontSize: 20, // text-xl
                              color: AppColors.whiteOverlay20, // white/20
                            ),
                          ),
                        ),

                        // Content
                        Column(
                          children: [
                            // Back button - matches React: w-10 h-10 bg-white/20 mb-6
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => context.push(RouteNames.categories),
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
                            ),
                            const SizedBox(height: 24), // mb-6

                            // Title and badges
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title - matches React: text-3xl font-bold mb-4
                                    Text(
                                      'دوراتي',
                                      style: AppTextStyles.h1(color: Colors.white),
                                    ),
                                    const SizedBox(height: 16), // mb-4
                                    // Badges - matches React: gap-2
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16, // px-4
                                            vertical: 8, // py-2
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.dark, // bg-[var(--dark)]
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.menu_book,
                                                size: 16, // w-4 h-4
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 8), // gap-2
                                              Text(
                                                '12 مادة',
                                                style: AppTextStyles.bodySmall(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8), // gap-2
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16, // px-4
                                            vertical: 8, // py-2
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteOverlay20, // bg-white/20
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.menu_book,
                                                size: 16, // w-4 h-4
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 8), // gap-2
                                              Text(
                                                '43 درس',
                                                style: AppTextStyles.bodySmall(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Graduation cap - matches React: text-6xl transform -rotate-12
                                Transform.rotate(
                                  angle: -0.2, // -rotate-12
                                  child: const Text(
                                    '🎓',
                                    style: TextStyle(fontSize: 48), // text-6xl
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Content - matches React: px-4 -mt-4
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, -16), // -mt-4 = -16px
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Subject chips - matches React: gap-3 pb-4 my-6
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24), // my-6
                              child: SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _subjects.length,
                                  itemBuilder: (context, index) {
                                    final subject = _subjects[index];
                                    final isActive = _activeSubject == subject['label'];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: index == 0 ? 0 : 12, // gap-3
                                      ),
                                      child: SubjectChip(
                                        icon: subject['icon']!,
                                        label: subject['label']!,
                                        isActive: isActive,
                                        onTap: () {
                                          setState(() {
                                            _activeSubject = subject['label']!;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Course cards - matches React: space-y-4 mt-4
                            Padding(
                              padding: const EdgeInsets.only(top: 16), // mt-4
                              child: Column(
                                children: [
                                  CourseCardCourses(
                                    category: 'الهندسة العملية',
                                    title: 'مناهج إبداعية للأشكال المستوية',
                                    participants: 43,
                                    variant: 'dark',
                                    icon: '📐',
                                    onTap: () => _handleCourseClick({
                                      'category': 'الهندسة العملية',
                                      'title': 'مناهج إبداعية للأشكال المستوية',
                                    }),
                                  ),
                                  const SizedBox(height: 16), // space-y-4
                                  CourseCardCourses(
                                    category: 'العالم المجهري حولنا',
                                    title: 'اكتشافات في علم الأحياء الخلوية',
                                    participants: 12,
                                    variant: 'light',
                                    icon: '🔬',
                                    onTap: () => _handleCourseClick({
                                      'category': 'العالم المجهري حولنا',
                                      'title': 'اكتشافات في علم الأحياء الخلوية',
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 120), // Space for bottom nav
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            const BottomNav(activeTab: 'courses'),
          ],
        ),
      ),
    );
  }
}
