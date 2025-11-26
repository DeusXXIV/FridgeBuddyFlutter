import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/fridge/data/fridge_item.dart';
import '../../features/fridge/data/fridge_repository.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailsScreen({
    super.key,
    required this.itemId,
  });

  // --------------------------------------------------------
  // HELPERS
  // --------------------------------------------------------
  String _monthName(int m) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[m - 1];
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final repo = FridgeRepository();
    final items = repo.items;

    FridgeItem? item;

// Try find by ID
    item = items.where((x) => x.id == itemId).firstOrNull;

// If not found, try by encoded name
    item ??= items.where((x) =>
    Uri.encodeComponent(x.name) == itemId ||
        x.name == itemId
    ).firstOrNull;

// If still not found → show a graceful error screen
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Item Not Found")),
        body: const Center(
          child: Text(
            "This item no longer exists.\nIt may have been deleted or expired.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final daysLeft = item.expiryDate.difference(DateTime.now()).inDays;
    final isOpened = item.openingDate != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [

                // ---------------------------------------
                // BASIC INFORMATION
                // ---------------------------------------
                _sectionHeader("Basic Information"),
                _settingsTile(
                  context,
                  title: "Item Name",
                  value: item.name,
                ),
                _settingsTile(
                  context,
                  title: "Category",
                  value: item.category,
                ),
                _settingsTile(
                  context,
                  title: "Container Type",
                  value: item.containerType,
                ),

                const SizedBox(height: 28),

                // ---------------------------------------
                // QUANTITY
                // ---------------------------------------
                _sectionHeader("Quantity"),
                _settingsTile(
                  context,
                  title: "Quantity",
                  value: item.quantity.toString(),
                  trailing: const Icon(Icons.add_circle_outline),
                ),

                const SizedBox(height: 28),

                // ---------------------------------------
                // DATES
                // ---------------------------------------
                _sectionHeader("Dates"),
                _settingsTile(
                  context,
                  title: "Expiration Date",
                  value: _formatDate(item.expiryDate),
                  valueColor:
                  _expiryColor(context, daysLeft: daysLeft),
                ),

                if (isOpened)
                  _settingsTile(
                    context,
                    title: "Opening Date",
                    value: _formatDate(item.openingDate!),
                  ),

                if (isOpened)
                  _settingsTile(
                    context,
                    title: "Expires After Opening",
                    value: "${item.expiryAfterOpeningDays} days",
                  ),

                const SizedBox(height: 28),

                // ---------------------------------------
                // REMINDERS
                // ---------------------------------------
                _sectionHeader("Reminders"),
                _settingsTile(
                  context,
                  title: "Reminder Count",
                  value: "${item.reminderCount} active",
                ),

                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 14),
                        const Text("Manage Reminders"),
                        const Spacer(),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ---------------------------------------
                // NOTES
                // ---------------------------------------
                _sectionHeader("Notes"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.notes ?? "No notes provided.",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------
  // Widgets
  // --------------------------------------------------------

  Widget _settingsTile(
      BuildContext context, {
        required String title,
        required String value,
        Color? valueColor,
        Widget? trailing,
      }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.bodyLarge),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ??
                  theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing,
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: Colors.grey,
        ),
      ),
    );
  }

  Color _expiryColor(BuildContext context, {required int daysLeft}) {
    if (daysLeft <= 1) return Colors.red;
    if (daysLeft <= 3) return Colors.orange;
    return Colors.green;
  }
}

extension FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}