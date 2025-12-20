import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_radius.dart';
import '../../core/navigation/route_names.dart';
import '../../widgets/bottom_nav.dart';

/// All Courses Screen - With Filters & Modern Card Design
class AllCoursesScreen extends StatefulWidget {
  const AllCoursesScreen({super.key});

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  String _selectedCategory = 'الكل';
  String _selectedPrice = 'الكل';
  String _sortBy = 'الأحدث';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final _categories = [
    'الكل',
    'التصميم',
    'البرمجة',
    'التسويق',
    'التقنية',
    'الإدارة'
  ];
  final _priceFilters = ['الكل', 'مجاني', 'مدفوع'];
  final _sortOptions = ['الأحدث', 'الأعلى تقييماً', 'الأكثر مبيعاً'];

  final _allCourses = [
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
    },
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
    },
    {
      'id': 7,
      'title': 'إدارة المشاريع الاحترافية',
      'instructor': 'فاطمة علي',
      'rating': 4.9,
      'hours': 30,
      'price': 850.0,
      'isFree': false,
      'lessons': 24,
      'students': 432,
      'image': 'assets/images/motion-pro-thumbnail.jpg',
      'category': 'الإدارة',
    },
    {
      'id': 8,
      'title': 'تصميم الجرافيك للمبتدئين',
      'instructor': 'ليلى أحمد',
      'rating': 4.5,
      'hours': 20,
      'price': 0.0,
      'isFree': true,
      'lessons': 16,
      'students': 980,
      'image': 'assets/images/Full_HD_Cover_2d_to_3d.png',
      'category': 'التصميم',
    },
  ];

  List<Map<String, dynamic>> get _filteredCourses {
    return _allCourses.where((course) {
      // Category filter
      if (_selectedCategory != 'الكل' &&
          course['category'] != _selectedCategory) {
        return false;
      }
      // Price filter
      if (_selectedPrice == 'مجاني' && course['isFree'] != true) return false;
      if (_selectedPrice == 'مدفوع' && course['isFree'] == true) return false;
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final title = (course['title'] as String).toLowerCase();
        final instructor = (course['instructor'] as String).toLowerCase();
        if (!title.contains(query) && !instructor.contains(query)) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'الأعلى تقييماً') {
          return (b['rating'] as num).compareTo(a['rating'] as num);
        } else if (_sortBy == 'الأكثر مبيعاً') {
          return (b['students'] as num).compareTo(a['students'] as num);
        }
        return 0;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              _buildHeader(context),

              // Filters
              _buildFilters(),

              // Courses Grid
              Expanded(
                child: _filteredCourses.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: _filteredCourses.length,
                        itemBuilder: (context, index) {
                          return _buildCourseCard(_filteredCourses[index]);
                        },
                      ),
              ),
            ],
          ),
          // Bottom Navigation
          const BottomNav(activeTab: 'courses'),
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
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: [
          // Title Row
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go(RouteNames.home),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جميع الدورات',
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${_filteredCourses.length} دورة متاحة',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar - Oval like Home
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
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
              style: GoogleFonts.cairo(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ابحث عن دورة...',
                hintStyle: GoogleFonts.cairo(
                    color: AppColors.mutedForeground, fontSize: 14),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(right: 16, left: 12),
                  child: Icon(Icons.search_rounded,
                      color: AppColors.purple, size: 24),
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)])
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppColors.purple.withOpacity(0.3)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.foreground,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Price & Sort Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Price Filter
                Expanded(
                  child: _buildDropdownFilter(
                    value: _selectedPrice,
                    items: _priceFilters,
                    icon: Icons.attach_money_rounded,
                    onChanged: (value) =>
                        setState(() => _selectedPrice = value!),
                  ),
                ),
                const SizedBox(width: 12),
                // Sort Filter
                Expanded(
                  child: _buildDropdownFilter(
                    value: _sortBy,
                    items: _sortOptions,
                    icon: Icons.sort_rounded,
                    onChanged: (value) => setState(() => _sortBy = value!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.purple),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              style:
                  GoogleFonts.cairo(fontSize: 13, color: AppColors.foreground),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
              items: items
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final isFree = course['isFree'] == true;

    return GestureDetector(
      onTap: () {
        final courseData = {
          ...course,
          'lessons': [
            {
              'id': 1,
              'title': 'المقدمة',
              'duration': '5 دقائق',
              'completed': false,
              'locked': false
            },
            {
              'id': 2,
              'title': 'الدرس الأول',
              'duration': '15 دقيقة',
              'completed': false,
              'locked': !isFree
            },
          ],
        };
        context.push(RouteNames.courseDetails, extra: courseData);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage(course['image'] as String),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.2)
                        ],
                      ),
                    ),
                  ),
                ),
                // Price Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: isFree
                          ? const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF059669)])
                          : const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isFree
                          ? 'مجاني'
                          : '${(course['price'] as num).toInt()} ج.م',
                      style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course['category'] as String,
                        style: GoogleFonts.cairo(
                            fontSize: 9,
                            color: AppColors.purple,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      course['title'] as String,
                      style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Instructor
                    Text(
                      course['instructor'] as String,
                      style: GoogleFonts.cairo(
                          fontSize: 10, color: AppColors.mutedForeground),
                    ),
                    const Spacer(),
                    // Stats
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${course['rating']}',
                          style: GoogleFonts.cairo(
                              fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Icon(Icons.people_rounded,
                            size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 2),
                        Text(
                          '${course['students']}',
                          style: GoogleFonts.cairo(
                              fontSize: 10, color: AppColors.mutedForeground),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                size: 50, color: AppColors.purple),
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد نتائج',
            style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مختلفة أو تغيير الفلاتر',
            style: GoogleFonts.cairo(
                fontSize: 14, color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
