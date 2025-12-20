import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/startup/splash_screen.dart';
import '../../screens/startup/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/main/home_screen.dart';
import '../../screens/main/courses_screen.dart';
import '../../screens/main/progress_screen.dart';
import '../../screens/main/student_dashboard_screen.dart';
import '../../screens/secondary/categories_screen.dart';
import '../../screens/secondary/course_details_screen.dart';
import '../../screens/secondary/lesson_viewer_screen.dart';
import '../../screens/secondary/exams_screen.dart';
import '../../screens/secondary/my_exams_screen.dart';
import '../../screens/secondary/notifications_screen.dart';
import '../../screens/secondary/checkout_screen.dart';
import '../../screens/secondary/live_courses_screen.dart';
import '../../screens/secondary/downloads_screen.dart';
import '../../screens/secondary/certificates_screen.dart';
import '../../screens/secondary/enrolled_screen.dart';
import '../../screens/secondary/settings_screen.dart';
import '../../screens/secondary/all_courses_screen.dart';
import 'route_names.dart';

// Custom page with transition
class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final String? name;
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) transitionsBuilder;

  const CustomTransitionPage({
    required LocalKey key,
    required this.child,
    this.name,
    required this.transitionsBuilder,
  }) : super(key: key, name: name);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class AppRouter {
  // Custom page transitions
  static Page<T> _buildPageWithTransition<T extends Object?>({
    required Widget child,
    required GoRouterState state,
    String? name,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      name: name,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Elegant slide and fade transition
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      // Check if user has launched before
      return null; // Will be handled in splash screen
    },
    routes: [
      // Startup flow
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding1,
        builder: (context, state) => const OnboardingScreen(step: 1),
      ),
      GoRoute(
        path: RouteNames.onboarding2,
        builder: (context, state) => const OnboardingScreen(step: 2),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app screens (with bottom nav)
      GoRoute(
        path: RouteNames.home,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const HomeScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.courses,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const CoursesScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.progress,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const ProgressScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const StudentDashboardScreen(),
          state: state,
        ),
      ),

      // Secondary screens
      GoRoute(
        path: RouteNames.categories,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const CategoriesScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.courseDetails,
        pageBuilder: (context, state) {
          final course = state.extra as Map<String, dynamic>?;
          return _buildPageWithTransition(
            child: CourseDetailsScreen(course: course),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RouteNames.lessonViewer,
        pageBuilder: (context, state) {
          final lesson = state.extra as Map<String, dynamic>?;
          return _buildPageWithTransition(
            child: LessonViewerScreen(lesson: lesson),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RouteNames.exams,
        builder: (context, state) => const ExamsScreen(),
      ),
      GoRoute(
        path: RouteNames.myExams,
        builder: (context, state) => const MyExamsScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.checkout,
        builder: (context, state) {
          final course = state.extra as Map<String, dynamic>?;
          return CheckoutScreen(course: course);
        },
      ),
      GoRoute(
        path: RouteNames.liveCourses,
        builder: (context, state) => const LiveCoursesScreen(),
      ),
      GoRoute(
        path: RouteNames.downloads,
        builder: (context, state) => const DownloadsScreen(),
      ),
      GoRoute(
        path: RouteNames.certificates,
        builder: (context, state) => const CertificatesScreen(),
      ),
      GoRoute(
        path: RouteNames.enrolled,
        builder: (context, state) => const EnrolledScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.allCourses,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const AllCoursesScreen(),
          state: state,
        ),
      ),
    ],
  );
}

