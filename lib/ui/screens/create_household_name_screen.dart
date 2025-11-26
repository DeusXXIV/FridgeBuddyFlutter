import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateHouseholdNameScreen extends StatefulWidget {
  const CreateHouseholdNameScreen({super.key});

  @override
  State<CreateHouseholdNameScreen> createState() => _CreateHouseholdNameScreenState();
}

class _CreateHouseholdNameScreenState extends State<CreateHouseholdNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _isValid = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Household"),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Name Your Household",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "You can always change this later. Choose something simple like “Family Fridge” or “Dorm A Refrigerator”.",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),

                  // Text field
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Household Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Continue button
                  ElevatedButton(
                    onPressed: _isValid
                        ? () {
                      // TODO: Save household name in backend later
                      context.go('/household-summary');
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Continue"),
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
