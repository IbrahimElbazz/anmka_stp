import 'package:go_router/go_router.dart';
import '../../screens/startup/splash_screen.dart';
import '../../screens/startup/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
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
import '../../screens/secondary/edit_profile_screen.dart';
import '../../screens/secondary/change_password_screen.dart';
import 'route_names.dart';

class AppRouter {
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
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main app screens (with bottom nav)
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.courses,
        builder: (context, state) => const CoursesScreen(),
      ),
      GoRoute(
        path: RouteNames.progress,
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const StudentDashboardScreen(),
      ),

      // Secondary screens
      GoRoute(
        path: RouteNames.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: RouteNames.courseDetails,
        builder: (context, state) {
          final course = state.extra as Map<String, dynamic>?;
          return CourseDetailsScreen(course: course);
        },
      ),
      GoRoute(
        path: RouteNames.lessonViewer,
        builder: (context, state) {
          final lesson = state.extra as Map<String, dynamic>?;
          return LessonViewerScreen(lesson: lesson);
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
        builder: (context, state) => const AllCoursesScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => EditProfileScreen(
          initialProfile: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
    ],
  );
}
