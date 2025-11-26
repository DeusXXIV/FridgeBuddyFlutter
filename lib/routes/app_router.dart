import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/household_select_screen.dart';
import '../ui/screens/create_household_name_screen.dart';
import '../ui/screens/household_summary_screen.dart';
import '../ui/screens/main_navigation_screen.dart';
import '../ui/screens/item_details_screen.dart';
import '../ui/screens/add_item_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ------------------
    // AUTH + ONBOARDING
    // ------------------
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // ------------------
    // HOUSEHOLD FLOW
    // ------------------
    GoRoute(
      path: '/household',
      builder: (context, state) => const HouseholdSelectScreen(),
    ),
    GoRoute(
      path: '/create-household-name',
      builder: (context, state) => const CreateHouseholdNameScreen(),
    ),
    GoRoute(
      path: '/household-summary',
      builder: (context, state) => const HouseholdSummaryScreen(),
    ),

    // ------------------
    // MAIN APP (TABS)
    // ------------------
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeTabWrapper(),
        ),
        GoRoute(
          path: '/fridge',
          builder: (context, state) => const FridgeTabWrapper(),
        ),
        GoRoute(
          path: '/reminders',
          builder: (context, state) => const RemindersTabWrapper(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsTabWrapper(),
        ),

        // ITEM DETAILS
        GoRoute(
          path: '/item/:id',
          builder: (context, state) {
            final itemId = state.pathParameters['id']!;
            return ItemDetailsScreen(itemId: itemId);
          },
        ),
        GoRoute(
          path: '/add-item',
          builder: (context, state) => const AddItemScreen(),
        ),
      ],
    ),
  ],
);
