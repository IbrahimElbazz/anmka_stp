import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_radius.dart';
import '../../data/sample_teachers.dart';
import '../../l10n/app_localizations.dart';

class TeacherDetailsScreen extends StatelessWidget {
  const TeacherDetailsScreen({super.key, this.teacher});

  final Map<String, dynamic>? teacher;

  Map<String, dynamic> get _teacher =>
      teacher ?? (kSampleTeachers.isNotEmpty ? kSampleTeachers.first : {});

  List<Map<String, dynamic>> get _courses =>
      List<Map<String, dynamic>>.from(_teacher['courses'] ?? const []);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        title: Text(
          _teacher['name']?.toString() ?? l10n.teacherFallback,
          style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.foreground,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.largeCard),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.largeCard),
                    ),
                    child: Image.network(
                      _teacher['avatar']?.toString() ?? '',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: AppColors.purple.withOpacity(0.12),
                        child: const Icon(Icons.person,
                            color: AppColors.purple, size: 64),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _teacher['name']?.toString() ?? '',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _teacher['title']?.toString() ?? '',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              (_teacher['rating'] ?? 0).toString(),
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.people_alt_rounded,
                                size: 18, color: AppColors.purple),
                            const SizedBox(width: 4),
                            Text(
                              l10n.studentsCount((_teacher['students'] as int?) ?? 0),
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _teacher['bio']?.toString() ?? '',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.teacherCoursesTitle,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 12),
            ..._courses.map(
              (course) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        course['thumbnail']?.toString() ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: AppColors.purple.withOpacity(0.1),
                          child:
                              const Icon(Icons.image, color: AppColors.purple),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course['title']?.toString() ?? '',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.foreground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded,
                                  size: 14, color: AppColors.purple),
                              const SizedBox(width: 4),
                              Text(
                                course['duration']?.toString() ?? '',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.people_rounded,
                                  size: 14, color: AppColors.purple),
                              const SizedBox(width: 4),
                              Text(
                              l10n.studentsCount((course['students'] as int?) ?? 0),
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}

