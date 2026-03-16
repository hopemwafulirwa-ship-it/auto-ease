import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/auth/presentation/splash_screen.dart';
import 'package:auto_ease/src/features/auth/presentation/login_screen.dart';
import 'package:auto_ease/src/features/auth/presentation/register_screen.dart';
import 'package:auto_ease/src/features/auth/presentation/role_selection_screen.dart';
import 'package:auto_ease/src/features/auth/presentation/forgot_password_screen.dart';
import 'package:auto_ease/src/features/home/presentation/main_scaffold.dart';
import 'package:auto_ease/src/features/booking/presentation/service_selection_screen.dart';
import 'package:auto_ease/src/features/booking/presentation/date_time_picker_screen.dart';
import 'package:auto_ease/src/features/booking/presentation/booking_confirmation_screen.dart';
import 'package:auto_ease/src/features/booking/presentation/booking_success_screen.dart';
import 'package:auto_ease/src/features/chat/presentation/chat_detail_screen.dart';
import 'package:auto_ease/src/features/chat/domain/chat_room.dart';
import 'package:auto_ease/src/features/home/presentation/service_finder_screen.dart';
import 'package:auto_ease/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:auto_ease/src/features/tracking/presentation/service_tracking_screen.dart';
import 'package:auto_ease/src/features/reviews/presentation/review_screen.dart';
import 'package:auto_ease/src/features/mechanic/presentation/mechanic_home_screen.dart';
import 'package:auto_ease/src/features/mechanic/presentation/job_requests_screen.dart';
import 'package:auto_ease/src/features/mechanic/presentation/job_details_screen.dart';
import 'package:auto_ease/src/features/mechanic/presentation/earnings_screen.dart';
import 'package:auto_ease/src/features/mechanic/domain/job_request.dart';
import 'package:auto_ease/src/features/profile/presentation/edit_profile_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: '/booking/services/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServiceSelectionScreen(serviceCenterId: id);
        },
      ),
      GoRoute(
        path: '/booking/datetime',
        builder: (context, state) => const DateTimePickerScreen(),
      ),
      GoRoute(
        path: '/booking/confirm',
        builder: (context, state) => const BookingConfirmationScreen(),
      ),
      GoRoute(
        path: '/booking/success',
        builder: (context, state) => const BookingSuccessScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final chatRoom = state.extra as ChatRoom;
          return ChatDetailScreen(chatRoom: chatRoom);
        },
      ),
      GoRoute(
        path: '/service-finder',
        builder: (context, state) => const ServiceFinderScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/tracking',
        builder: (context, state) => const ServiceTrackingScreen(),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: '/mechanic/home',
        builder: (context, state) => const MechanicHomeScreen(),
      ),
      GoRoute(
        path: '/mechanic/jobs',
        builder: (context, state) => const JobRequestsScreen(),
      ),
      GoRoute(
        path: '/mechanic/job/:id',
        builder: (context, state) {
          final job = state.extra as JobRequest;
          return JobDetailsScreen(job: job);
        },
      ),
      GoRoute(
        path: '/mechanic/earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}
