import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // APP ICON
                  Icon(
                    Icons.kitchen_outlined,
                    size: 90,
                    color: isDark ? Colors.white70 : Colors.blue,
                  ),
                  const SizedBox(height: 20),

                  // TITLE
                  Text(
                    "Welcome to FridgeBuddy",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // SUBTITLE
                  Text(
                    "Track your fridge items effortlessly.\nStay organized. Reduce waste.",
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // GOOGLE SIGN-IN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon( //tempo household, change to google later
                      onPressed: () {
                        context.go('/household');
                      },
                      icon: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                        width: 24,
                        height: 24,
                      ),
                      label: const Text(
                        "Continue with Google",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // EMAIL LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement email login later
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isDark ? Colors.white70 : Colors.blue,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Continue with Email",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // GUEST MODE
                  TextButton(
                    onPressed: () {
                      // TODO: Implement guest mode (optional)
                    },
                    child: const Text("Continue as Guest"),
                  ),

                  const SizedBox(height: 20),

                  // TERMS AND PRIVACY POLICY
                  Text(
                    "By continuing, you agree to our Terms and Privacy Policy.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
