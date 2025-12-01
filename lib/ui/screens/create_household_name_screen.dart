import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/local_storage.dart';
import 'package:go_router/go_router.dart';

class CreateHouseholdScreen extends StatefulWidget {
  const CreateHouseholdScreen({super.key});

  @override
  State<CreateHouseholdScreen> createState() => _CreateHouseholdScreenState();
}

class _CreateHouseholdScreenState extends State<CreateHouseholdScreen> {
  final _nameCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _create() async {
    if (_nameCtrl.text.trim().isEmpty) return;

    setState(() => _loading = true);

    final id = "house_${DateTime.now().millisecondsSinceEpoch}";
    final doc = FirebaseFirestore.instance.collection("households").doc(id);

    await doc.set({
      "id": id,
      "name": _nameCtrl.text.trim(),
      "createdAt": DateTime.now().toIso8601String(),
    });

    // save locally
    await LocalStorage.saveHouseholdId(id);

    if (mounted) {
      context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Household")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter a name for your household:",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                label: Text("Household Name"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _create,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text("Create Household"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
