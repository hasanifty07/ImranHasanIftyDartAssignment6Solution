import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _search = TextEditingController();
  int _tab = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final showRail = w >= 900;
        final wide = w >= 1100;
        final medium = w >= 720;

        return Scaffold(
          key: _scaffoldKey,
          drawer: showRail ? null : Drawer(
            child: SafeArea(
              child: _DrawerMenu(
                selected: _tab,
                onTap: (i) {
                  setState(() => _tab = i);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: showRail
                ? null
                : IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
            titleSpacing: 12,
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  isDense: true,
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.6),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              IconButton(
                tooltip: 'Settings',
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.person, size: 18),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: Row(
            children: [
              if (showRail)
                _SideRail(
                  selected: _tab,
                  onSelect: (i) => setState(() => _tab = i),
                ),
              Expanded(
                child: _ContentArea(index: _tab, wide: wide, medium: medium),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SideRail extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _SideRail({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return NavigationRail(
      selectedIndex: selected,
      onDestinationSelected: onSelect,
      backgroundColor: cs.surfaceContainerLowest,
      labelType: NavigationRailLabelType.all,
      groupAlignment: -0.9,
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('New'),
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.widgets_outlined),
          selectedIcon: Icon(Icons.widgets),
          label: Text('Items'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people_rounded),
          label: Text('People'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.checklist_outlined),
          selectedIcon: Icon(Icons.checklist_rounded),
          label: Text('Tasks'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.insights_outlined),
          selectedIcon: Icon(Icons.insights_rounded),
          label: Text('Insights'),
        ),
      ],
    );
  }
}

class _DrawerMenu extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _DrawerMenu({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.dashboard_rounded, 'Dashboard'),
      (Icons.widgets_rounded, 'Items'),
      (Icons.people_rounded, 'People'),
      (Icons.checklist_rounded, 'Tasks'),
      (Icons.insights_rounded, 'Insights'),
    ];
    return ListView(
      children: [
        const ListTile(
          title: Text('App Menu', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const Divider(height: 1),
        for (int i = 0; i < items.length; i++)
          ListTile(
            leading: Icon(items[i].$1),
            title: Text(items[i].$2),
            selected: selected == i,
            onTap: () => onTap(i),
          ),
      ],
    );
  }
}

class _ContentArea extends StatelessWidget {
  final int index;
  final bool wide;
  final bool medium;
  const _ContentArea({required this.index, required this.wide, required this.medium});

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return _Section(
          title: 'Dashboard',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  _StatCard(icon: Icons.widgets_rounded, label: 'Active', value: '12'),
                  _StatCard(icon: Icons.people_rounded, label: 'Users', value: '356'),
                  _StatCard(icon: Icons.check_circle, label: 'Open Tasks', value: '18'),
                  _StatCard(icon: Icons.trending_up, label: 'Score', value: '92'),
                ],
              ),
              const SizedBox(height: 16),
              _ResponsiveGrid(
                count: 8,
                wide: wide,
                medium: medium,
                builder: (c, i) => _ItemCard(i: i),
              ),
            ],
          ),
        );
      case 1:
        return _Section(
          title: 'Items',
          child: _ResponsiveGrid(
            count: 12,
            wide: wide,
            medium: medium,
            builder: (c, i) => _ItemCard(i: i),
          ),
        );
      case 2:
        return _Section(
          title: 'People',
          child: _ResponsiveGrid(
            count: 24,
            wide: wide,
            medium: medium,
            builder: (c, i) => _PersonCard(i: i),
          ),
        );
      case 3:
        return _Section(
          title: 'Tasks',
          child: _ResponsiveGrid(
            count: 10,
            wide: wide,
            medium: medium,
            builder: (c, i) => _TaskCard(i: i),
          ),
        );
      case 4:
        return _Section(
          title: 'Insights',
          child: _ResponsiveGrid(
            count: 6,
            wide: wide,
            medium: medium,
            builder: (c, i) => _InsightCard(i: i),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Import'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: child,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final int count;
  final bool wide;
  final bool medium;
  final IndexedWidgetBuilder builder;
  const _ResponsiveGrid({
    required this.count,
    required this.wide,
    required this.medium,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    int columns = 1;
    if (wide) {
      columns = 4;
    } else if (medium) {
      columns = 3;
    } else {
      columns = 2;
    }
    return GridView.builder(
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.35,
      ),
      itemBuilder: builder,
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: cs.primaryContainer,
            foregroundColor: cs.onPrimaryContainer,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final int i;
  const _ItemCard({required this.i});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Item ${i + 1}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  'Short description and recent activity.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.label_important_outline, size: 18),
                  const SizedBox(width: 6),
                  const Text('Category A'),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Open'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final int i;
  const _PersonCard({required this.i});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Text('${i + 1}')),
          const SizedBox(height: 12),
          Text('Person ${i + 1}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text('Role • ID ${100 + i}', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('View'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final int i;
  const _TaskCard({required this.i});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task ${i + 1}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text('Due: 25 Nov', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.playlist_add_check, size: 18),
              const SizedBox(width: 6),
              const Text('3 steps'),
              const Spacer(),
              FilledButton.tonal(onPressed: () {}, child: const Text('Review')),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final int i;
  const _InsightCard({required this.i});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insight ${i + 1}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text('Key metric snapshot', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: OutlinedButton(onPressed: () {}, child: const Text('Open')),
          ),
        ],
      ),
    );
  }
}
