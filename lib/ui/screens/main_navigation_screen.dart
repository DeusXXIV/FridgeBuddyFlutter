import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/fridge/data/fridge_item.dart';
import '../../features/fridge/data/fridge_repository.dart';

class HomeTabWrapper extends StatelessWidget {
  const HomeTabWrapper({super.key});
  @override
  Widget build(BuildContext context) => const _HomeTab();
}

class FridgeTabWrapper extends StatelessWidget {
  const FridgeTabWrapper({super.key});
  @override
  Widget build(BuildContext context) => const _FridgeTab();
}

class RemindersTabWrapper extends StatelessWidget {
  const RemindersTabWrapper({super.key});
  @override
  Widget build(BuildContext context) => const _RemindersTab();
}

class SettingsTabWrapper extends StatelessWidget {
  const SettingsTabWrapper({super.key});
  @override
  Widget build(BuildContext context) => const _SettingsTab();
}


class MainNavigationShell extends StatefulWidget {
  final Widget child;
  const MainNavigationShell({super.key, required this.child});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _index = 0;

  final tabs = [
    '/home',
    '/fridge',
    '/reminders',
    '/settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() => _index = i);
          context.go(tabs[i]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.kitchen_outlined), label: 'Fridge'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Reminders'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}


// --------------------------------------------------------
// HOME TAB
// --------------------------------------------------------

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fridgeItems = 12;
    final expiringSoon = 3;
    final reminderCount = 5;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello!",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Here’s what's happening in your fridge today.",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 30),

                _buildRoundedCard(
                  context,
                  title: "Your Fridge",
                  value: "$fridgeItems items",
                  icon: Icons.kitchen_outlined,
                  color: theme.colorScheme.primaryContainer,
                ),
                const SizedBox(height: 20),

                _buildRoundedCard(
                  context,
                  title: "Expiring Soon",
                  value: "$expiringSoon items",
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange.shade200.withOpacity(0.4),
                ),
                const SizedBox(height: 20),

                _buildRoundedCard(
                  context,
                  title: "Reminders",
                  value: "$reminderCount active",
                  icon: Icons.notifications_active_outlined,
                  color: theme.colorScheme.tertiaryContainer,
                ),

                const SizedBox(height: 30),
                Text(
                  "Quick Actions",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction(
                      context,
                      icon: Icons.add_circle_outline,
                      label: "Add Item",
                      onTap: () {
                        context.go('/add-item');
                      },
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.qr_code_scanner,
                      label: "Scan",
                      onTap: () {
                        context.go('/scan');
                      },
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.view_module_outlined,
                      label: "Sections",
                      onTap: () {
                        /* future: open compartments screen */
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedCard(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}



// --------------------------------------------------------
// OTHER TABS (placeholders for now)
// --------------------------------------------------------

class _FridgeTab extends StatelessWidget {
  const _FridgeTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final repo = FridgeRepository();
    repo.seedSampleItems(); // optional—remove later when Firestore is added

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  "Your Fridge Items",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ValueListenableBuilder<List<FridgeItem>>(
                    valueListenable: repo.itemsListenable,
                    builder: (context, items, _) {
                      if (items.isEmpty) {
                        return Center(
                          child: Text(
                            'No items yet. Add your first item!',
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          return _buildItemCard(context, items[index]);
                        },
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Detailed item card
  Widget _buildItemCard(BuildContext context, FridgeItem item) {
    final theme = Theme.of(context);
    IconData _categoryIcon(String category) {
      switch (category.toLowerCase()) {
        case 'drink':
          return Icons.local_drink;
        case 'meat':
          return Icons.restaurant;
        case 'condiment':
          return Icons.soup_kitchen_outlined;
        case 'vegetable':
          return Icons.grass;
        case 'snack':
          return Icons.fastfood;
        default:
          return Icons.inventory_2_outlined;
      }
    }
    // Compute expiry status
    final now = DateTime.now();
    final daysLeft = item.expiryDate.difference(now).inDays;
    Color statusColor;

    if (daysLeft <= 1) {
      statusColor = Colors.red;
    } else if (daysLeft <= 3) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    // Opening expiration logic
    String openingInfo = "";
    if (item.openingDate != null && item.expiryAfterOpeningDays != null) {
      final openExpiryDate =
      item.openingDate!.add(Duration(days: item.expiryAfterOpeningDays!));
      final openDaysLeft = openExpiryDate.difference(now).inDays;

      openingInfo =
      "After opening: ${openDaysLeft < 0 ? 'Expired' : '$openDaysLeft days left'}";
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.go('/item/${Uri.encodeComponent(item.name)}');
  },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(_categoryIcon(item.category), size: 26),
            ),

            const SizedBox(width: 16),

            // Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Qty: ${item.quantity}  •  Container: ${item.containerType}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Expires in $daysLeft days",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (openingInfo.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      openingInfo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Arrow
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _RemindersTab extends StatelessWidget {
  const _RemindersTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Reminders"));
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Settings"));
  }
}
