import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pod_player/pod_player.dart';
import '../../core/design/app_colors.dart';

/// Lesson Viewer Screen - Modern & Eye-Friendly Design
class LessonViewerScreen extends StatefulWidget {
  final Map<String, dynamic>? lesson;

  const LessonViewerScreen({super.key, this.lesson});

  @override
  State<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends State<LessonViewerScreen> {
  PodPlayerController? _controller;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final videoId = widget.lesson?['youtubeVideoId'] ?? 'AevtORdu4pc';

    try {
      _controller = PodPlayerController(
        playVideoFrom:
            PlayVideoFrom.youtube('https://www.youtube.com/watch?v=$videoId'),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ),
      )..initialise().then((_) {
          if (mounted) {
            setState(() => _isVideoLoading = false);
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() => _isVideoLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final lesson = widget.lesson;
    if (lesson == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0F1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                'لا يوجد درس',
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Video Player Section
            _buildVideoSection(lesson),

            // Lesson Info Section
            Expanded(
              child: _buildLessonInfo(lesson),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection(Map<String, dynamic> lesson) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson['title'] as String? ?? 'عنوان الدرس',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'المدة: ${lesson['duration'] ?? 'غير محدد'}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildHeaderAction(Icons.bookmark_border_rounded, () {}),
                const SizedBox(width: 8),
                _buildHeaderAction(Icons.share_rounded, () {}),
              ],
            ),
          ),

          // Video Player
          SizedBox(
            height: 220,
            child: _controller != null && !_isVideoLoading
                ? PodVideoPlayer(
                    controller: _controller!,
                    videoAspectRatio: 16 / 9,
                    podProgressBarConfig: const PodProgressBarConfig(
                      playingBarColor: AppColors.purple,
                      circleHandlerColor: AppColors.purple,
                      bufferedBarColor: Colors.white30,
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.purple,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildLessonInfo(Map<String, dynamic> lesson) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Lesson Title & Stats
            Text(
              lesson['title'] as String? ?? 'عنوان الدرس',
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 12),

            // Stats Row
            Row(
              children: [
                _buildStatBadge(Icons.access_time_rounded,
                    lesson['duration'] ?? '15 دقيقة'),
                const SizedBox(width: 12),
                _buildStatBadge(Icons.visibility_rounded, '1,234 مشاهدة'),
                const SizedBox(width: 12),
                _buildStatBadge(Icons.thumb_up_rounded, '98%'),
              ],
            ),
            const SizedBox(height: 24),

            // Description Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description_rounded,
                            color: AppColors.purple, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'وصف الدرس',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'في هذا الدرس سنتعلم المفاهيم الأساسية والتطبيقات العملية. سنغطي جميع النقاط المهمة بطريقة مبسطة وسهلة الفهم مع أمثلة تطبيقية.',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Resources Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.folder_rounded,
                            color: Colors.orange, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ملفات الدرس',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildResourceItem(
                      'ملف PDF - ملخص الدرس', '2.5 MB', Icons.picture_as_pdf),
                  const SizedBox(height: 10),
                  _buildResourceItem('ملف المشروع', '15 MB', Icons.folder_zip),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: _buildNavButton(
                    'الدرس السابق',
                    Icons.arrow_forward_rounded,
                    false,
                    () => context.pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildNavButton(
                    'الدرس التالي',
                    Icons.arrow_back_rounded,
                    true,
                    () => context.pop(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.purple),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.cairo(fontSize: 12, color: AppColors.foreground),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String title, String size, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.red, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground),
                ),
                Text(
                  size,
                  style: GoogleFonts.cairo(
                      fontSize: 11, color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.download_rounded,
                color: AppColors.purple, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
      String text, IconData icon, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)])
              : null,
          color: isPrimary ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary ? null : Border.all(color: Colors.grey[200]!),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPrimary) Icon(icon, size: 18, color: AppColors.foreground),
            if (!isPrimary) const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : AppColors.foreground,
              ),
            ),
            if (isPrimary) const SizedBox(width: 8),
            if (isPrimary) Icon(icon, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
