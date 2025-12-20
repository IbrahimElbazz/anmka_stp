import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';
import '../../core/navigation/route_names.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/premium_course_card.dart';

/// Home Screen - Enhanced with 3D Banner & Modern Design
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  bool _showSearchResults = false;
  String _searchQuery = '';
  late AnimationController _bannerController;
  late Animation<double> _bannerAnimation;

  final _featuredCourses = [
    {
      'id': 1,
      'title': 'أساسيات تصميم واجهات المستخدم',
      'instructor': 'أحمد محمد',
      'rating': 4.8,
      'hours': 72,
      'price': 0.0,
      'isFree': true,
      'lessons': 22,
      'students': 1250,
      'image': 'assets/images/motion-graphics-course-in-mumbai.png',
      'category': 'التصميم',
      'youtubeVideoId': 'AevtORdu4pc',
    },
    {
      'id': 2,
      'title': 'البرمجة بلغة بايثون للمبتدئين',
      'instructor': 'سارة أحمد',
      'rating': 4.9,
      'hours': 48,
      'price': 500.0,
      'isFree': false,
      'lessons': 30,
      'students': 2340,
      'image': 'assets/images/motion-pro-thumbnail.jpg',
      'category': 'البرمجة',
      'youtubeVideoId': 'AevtORdu4pc',
    },
    {
      'id': 3,
      'title': 'الذكاء الاصطناعي والتعلم الآلي',
      'instructor': 'محمد علي',
      'rating': 4.7,
      'hours': 56,
      'price': 0.0,
      'isFree': true,
      'lessons': 28,
      'students': 890,
      'image': 'assets/images/Full_HD_Cover_2d_to_3d.png',
      'category': 'التقنية',
      'youtubeVideoId': 'AevtORdu4pc',
    },
  ];

  final _recommendedCourses = [
    {
      'id': 4,
      'title': 'تطوير تطبيقات الويب',
      'instructor': 'خالد سعيد',
      'rating': 4.6,
      'hours': 40,
      'price': 750.0,
      'isFree': false,
      'lessons': 18,
      'students': 567,
      'image': 'assets/images/promo_page_v1.jpg',
      'category': 'البرمجة',
      'youtubeVideoId': 'AevtORdu4pc',
    },
    {
      'id': 5,
      'title': 'التسويق الرقمي',
      'instructor': 'نورة محمد',
      'rating': 4.8,
      'hours': 25,
      'price': 0.0,
      'isFree': true,
      'lessons': 15,
      'students': 1890,
      'image':
          'assets/images/6553876359f5b6249adec0e5_617c40ade6a8b58e1ac21506_SOM_Brand-Manifesto_Featured-Image.png',
      'category': 'التسويق',
      'youtubeVideoId': 'AevtORdu4pc',
    },
    {
      'id': 6,
      'title': 'تحليل البيانات',
      'instructor': 'أحمد خالد',
      'rating': 4.7,
      'hours': 35,
      'price': 0.0,
      'isFree': true,
      'lessons': 20,
      'students': 756,
      'image': 'assets/images/motion-graphics-course-in-mumbai.png',
      'category': 'التقنية',
      'youtubeVideoId': 'AevtORdu4pc',
    },
  ];

  final _categories = [
    {
      'icon': Icons.design_services,
      'label': 'التصميم',
      'color': const Color(0xFF6366F1),
      'count': 45
    },
    {
      'icon': Icons.code,
      'label': 'البرمجة',
      'color': const Color(0xFF10B981),
      'count': 78
    },
    {
      'icon': Icons.trending_up,
      'label': 'التسويق',
      'color': const Color(0xFFF59E0B),
      'count': 32
    },
    {
      'icon': Icons.analytics,
      'label': 'البيانات',
      'color': const Color(0xFFEC4899),
      'count': 28
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _bannerAnimation = CurvedAnimation(
      parent: _bannerController,
      curve: Curves.easeOutBack,
    );
    _bannerController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _allCourses =>
      [..._featuredCourses, ..._recommendedCourses];

  List<Map<String, dynamic>> get _filteredCourses {
    if (_searchQuery.isEmpty) return [];
    return _allCourses.where((course) {
      return course['title'].toString().contains(_searchQuery) ||
          course['instructor'].toString().contains(_searchQuery) ||
          course['category'].toString().contains(_searchQuery);
    }).toList();
  }

  void _handleCourseClick(Map<String, dynamic> course) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('hasLaunched') ?? false;
    final isFree = course['isFree'] == true;

    if (!isFree && !isLoggedIn) {
      if (mounted) {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('تسجيل الدخول مطلوب'),
            content: const Text('يجب تسجيل الدخول للوصول إلى هذا الكورس'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
                child: const Text('تسجيل الدخول',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        if (result == true && mounted) {
          context.push(RouteNames.login);
        }
      }
      return;
    }

    final courseData = {
      ...course,
      'lessons': [
        {
          'id': 1,
          'title': 'المقدمة',
          'duration': '2 دقيقة 18 ثانية',
          'completed': true,
          'locked': false,
          'youtubeVideoId': course['youtubeVideoId'] ?? 'AevtORdu4pc'
        },
        {
          'id': 2,
          'title': 'الدرس الأول',
          'duration': '18 دقيقة 46 ثانية',
          'completed': false,
          'locked': false,
          'youtubeVideoId': course['youtubeVideoId'] ?? 'AevtORdu4pc'
        },
        {
          'id': 3,
          'title': 'الدرس الثاني',
          'duration': '20 دقيقة 58 ثانية',
          'completed': false,
          'locked': !isFree,
          'youtubeVideoId': course['youtubeVideoId'] ?? 'AevtORdu4pc'
        },
        {
          'id': 4,
          'title': 'اختبار الفصل الأول',
          'duration': '15 دقيقة',
          'completed': false,
          'locked': !isFree,
          'isExam': true
        },
      ],
    };
    if (mounted) {
      context.push(RouteNames.courseDetails, extra: courseData);
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

    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 430),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 430
                  ? (MediaQuery.of(context).size.width - 430) / 2
                  : 0,
            ),
            child: Column(
              children: [
                // Enhanced Header
                _buildHeader(statusBarHeight),

                // Content
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),

                          // 3D Banner
                          _build3DBanner(),

                          const SizedBox(height: 24),

                          // Quick Stats Row
                          _buildQuickStats(),

                          const SizedBox(height: 28),

                          // Featured Courses
                          _buildSectionHeader('الدورات المميزة', () {
                            context.push(RouteNames.allCourses);
                          }),
                          const SizedBox(height: 16),
                          _buildFeaturedCourses(),

                          const SizedBox(height: 28),

                          // Categories
                          _buildSectionHeader('التصنيفات', () {
                            context.push(RouteNames.categories);
                          }),
                          const SizedBox(height: 16),
                          _buildCategories(),

                          const SizedBox(height: 28),

                          // Recommended Courses
                          _buildSectionHeader('دورات موصى بها', () {
                            context.push(RouteNames.allCourses);
                          }),
                          const SizedBox(height: 16),
                          _buildRecommendedCourses(),

                          const SizedBox(height: 140),
                        ],
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
    );
  }

  Widget _buildHeader(double statusBarHeight) {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative educational icons - transparent
          Positioned(
            top: statusBarHeight + 60,
            right: 20,
            child: Icon(
              Icons.menu_book_rounded,
              size: 40,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned(
            top: statusBarHeight + 30,
            left: 40,
            child: Icon(
              Icons.lightbulb_outline_rounded,
              size: 30,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 60,
            child: Icon(
              Icons.science_outlined,
              size: 35,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: Icon(
              Icons.calculate_outlined,
              size: 28,
              color: Colors.white.withOpacity(0.06),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: statusBarHeight + 16,
              left: 20,
              right: 20,
              bottom: 56,
            ),
            child: Column(
              children: [
                // Top Row - Student Avatar, User & Notifications
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Student Avatar and welcome
                    Row(
                      children: [
                        // Student Avatar instead of logo
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/student-avatar.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.white,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.purple,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً، يعقوب 👋',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        'طالب متميز',
                                        style: GoogleFonts.cairo(
                                          fontSize: 11,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Actions
                    Row(
                      children: [
                        // Settings
                        _buildHeaderButton(
                          icon: Icons.settings_outlined,
                          onTap: () => context.push(RouteNames.settings),
                        ),
                        const SizedBox(width: 8),
                        // Notifications with badge
                        _buildHeaderButton(
                          icon: Icons.notifications_none_rounded,
                          badge: '3',
                          onTap: () => context.push(RouteNames.notifications),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Enhanced Oval Search Bar
                _buildSearchBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(
      {required IconData icon, String? badge, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            if (badge != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.cairo(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Oval shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.cairo(
          fontSize: 15,
          color: AppColors.foreground,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن دورة، مدرب، أو موضوع...',
          hintStyle: GoogleFonts.cairo(
            fontSize: 14,
            color: AppColors.mutedForeground,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(right: 20, left: 12),
            child:
                Icon(Icons.search_rounded, color: AppColors.purple, size: 24),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
              ),
              borderRadius: BorderRadius.circular(20), // Oval suffix
            ),
            child:
                const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        onTap: () {
          // Show search overlay
          _showSearchOverlay(context);
        },
        readOnly: true,
      ),
    );
  }

  void _showSearchOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchOverlay(
        allCourses: _allCourses,
        onCourseSelected: (course) {
          Navigator.pop(context);
          _handleCourseClick(course);
        },
      ),
    );
  }

  Widget _build3DBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _bannerAnimation,
        builder: (context, child) {
          // Clamp animation value to ensure it stays within 0.0-1.0 range
          // Use max/min to ensure safety even if value is NaN or Infinity
          final rawValue = _bannerAnimation.value;
          final animationValue = (rawValue.isNaN || rawValue.isInfinite)
              ? 1.0
              : rawValue.clamp(0.0, 1.0);
          return Transform.scale(
            scale: 0.9 + (animationValue * 0.1),
            child: Opacity(
              opacity: animationValue,
              child: child,
            ),
          );
        },
        child: Container(
          height: 165,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7C3AED),
                Color(0xFF5B21B6),
                Color(0xFF4C1D95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: 60,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),

                // Main Row - Text on right, Character on left
                Row(
                  children: [
                    // 3D Character - Inside banner on left
                    Expanded(
                      flex: 4,
                      child: Transform.translate(
                        offset: const Offset(-10, 10),
                        child: Image.asset(
                          'assets/images/student-character.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 60,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Content on right
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.local_fire_department,
                                      color: Colors.orange, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'عرض خاص',
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ابدأ رحلة التعلم',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'خصم 50% على جميع الدورات',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'اشترك الآن',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF7C3AED),
                                ),
                              ),
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
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.play_circle_fill_rounded,
            value: '12',
            label: 'كورس مشترك',
            color: const Color(0xFF10B981),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            icon: Icons.emoji_events_rounded,
            value: '5',
            label: 'شهادة',
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            icon: Icons.access_time_filled_rounded,
            value: '48',
            label: 'ساعة تعلم',
            color: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            Text(
              label,
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

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'عرض المزيد',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios,
                      size: 12, color: AppColors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCourses() {
    return SizedBox(
      height: 285,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 8),
        itemCount: _featuredCourses.length,
        itemBuilder: (context, index) {
          final course = _featuredCourses[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PremiumCourseCard(
              course: course,
              onTap: () => _handleCourseClick(course),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _categories.map((cat) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: cat == _categories.last ? 0 : 10),
              child: GestureDetector(
                onTap: () => context.push(RouteNames.categories),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(cat['icon'] as IconData,
                            color: cat['color'] as Color, size: 26),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat['label'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      Text(
                        '${cat['count']} دورة',
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedCourses() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _recommendedCourses.take(4).map((course) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildHorizontalCourseCard(course),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalCourseCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () => _handleCourseClick(course),
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Row(
          children: [
            // Image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  course['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.purple.withOpacity(0.1),
                    child: const Icon(Icons.image,
                        color: AppColors.purple, size: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          course['category'] as String,
                          style: GoogleFonts.cairo(
                              fontSize: 10,
                              color: AppColors.purple,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Spacer(),
                      if (course['isFree'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'مجاني',
                            style: GoogleFonts.cairo(
                                fontSize: 10,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course['title'] as String,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course['instructor'] as String,
                    style: GoogleFonts.cairo(
                        fontSize: 12, color: AppColors.mutedForeground),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${course['rating']}',
                        style: GoogleFonts.cairo(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time_rounded,
                          size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        '${course['hours']}س',
                        style: GoogleFonts.cairo(
                            fontSize: 11, color: AppColors.mutedForeground),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.people_rounded,
                          size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        '${course['students']}',
                        style: GoogleFonts.cairo(
                            fontSize: 11, color: AppColors.mutedForeground),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Overlay Widget
class _SearchOverlay extends StatefulWidget {
  final List<Map<String, dynamic>> allCourses;
  final Function(Map<String, dynamic>) onCourseSelected;

  const _SearchOverlay({
    required this.allCourses,
    required this.onCourseSelected,
  });

  @override
  State<_SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<_SearchOverlay> {
  final _searchController = TextEditingController();
  String _query = '';

  List<Map<String, dynamic>> get _filteredCourses {
    if (_query.isEmpty) return widget.allCourses;
    return widget.allCourses.where((course) {
      return course['title'].toString().contains(_query) ||
          course['instructor'].toString().contains(_query) ||
          course['category'].toString().contains(_query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.cairo(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'ابحث عن دورة، مدرب، أو موضوع...',
                  hintStyle: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(right: 16, left: 12),
                    child: Icon(Icons.search_rounded, color: AppColors.purple),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
          ),

          // Results
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد نتائج',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return GestureDetector(
                        onTap: () => widget.onCourseSelected(course),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.beige,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  course['image'] as String,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: AppColors.purple.withOpacity(0.1),
                                    child: const Icon(Icons.image,
                                        color: AppColors.purple),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course['title'] as String,
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      course['instructor'] as String,
                                      style: GoogleFonts.cairo(
                                        fontSize: 12,
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (course['isFree'] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'مجاني',
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
