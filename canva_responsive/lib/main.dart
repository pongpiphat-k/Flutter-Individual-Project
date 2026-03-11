import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const CanvaResponsiveApp());
}

class CanvaResponsiveApp extends StatelessWidget {
  const CanvaResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Canva Responsive',
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFF05060A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A63F5),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CanvaHomeScreen(),
    );
  }
}

class CanvaHomeScreen extends StatefulWidget {
  const CanvaHomeScreen({super.key});

  @override
  State<CanvaHomeScreen> createState() => _CanvaHomeScreenState();
}

class _CanvaHomeScreenState extends State<CanvaHomeScreen> {
  int _selectedDestination = 0;

  final _destinations = const [
    NavigationDestination(icon: Icon(Icons.add), label: 'สร้าง'),
    NavigationDestination(icon: Icon(Icons.folder_special_outlined), label: 'โฟลเดอร์ของคุณ'),
    NavigationDestination(icon: Icon(Icons.upload_file_outlined), label: 'อัปโหลด'),
    NavigationDestination(icon: Icon(Icons.more_horiz), label: 'เพิ่มเติม'),
  ];

  final List<FolderItem> _folders = const [
    FolderItem(title: '3', itemCount: 0),
    FolderItem(title: '2', itemCount: 0),
    FolderItem(title: '1', itemCount: 0),
    FolderItem(title: 'Software Testing', itemCount: 1, thumbColor: Color(0xFFFFC857)),
    FolderItem(title: 'Mobile presentation', itemCount: 1, thumbColor: Color(0xFF7FDBFF)),
    FolderItem(title: 'อัปโหลด', itemCount: 0, thumbColor: Color(0xFF666B7D)),
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 1200;
        final isTablet = width >= 700 && width < 1200;
        final showRail = isTablet || isDesktop;

        return Scaffold(
          backgroundColor: const Color(0xFF05060A),
          extendBody: true,
          bottomNavigationBar: !showRail
              ? NavigationBar(
                  height: 72,
                  selectedIndex: _selectedDestination,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: _destinations,
                  onDestinationSelected: (index) {
                    setState(() => _selectedDestination = index);
                  },
                )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                if (showRail)
                  _SideNavigationRail(
                    isDesktop: isDesktop,
                    selectedIndex: _selectedDestination,
                    onSelected: (index) => setState(() => _selectedDestination = index),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 24, vertical: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0D1F3D),
                              Color(0xFF080A16),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            _HeaderSection(isDesktop: isDesktop),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B0D14),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 24, vertical: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _SearchBar(),
                                    const SizedBox(height: 16),
                                    _FilterRow(isCompact: !isDesktop && !isTablet),
                                    const SizedBox(height: 24),
                                    Text(
                                      'โฟลเดอร์',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: _FolderArea(
                                        folders: _folders,
                                        useGrid: isTablet || isDesktop || isLandscape,
                                        hoverActions: isDesktop,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 32, vertical: isDesktop ? 40 : 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C99C6),
            Color(0xFF8340E9),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(.2),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              IconButton.filledTonal(
                style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(.2)),
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'โปรเจ็กต์ทั้งหมด',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF10131F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.4),
            blurRadius: 12,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white.withOpacity(.9)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ค้นหาในคอนเทนต์ทั้งหมด',
              style: TextStyle(color: Colors.white.withOpacity(.7)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final filters = [
      _FilterChipData('โฟลเดอร์', true),
      _FilterChipData('เจ้าของ', false),
      _FilterChipData('วันที่แก้ไข', false),
    ];

    final spacing = isCompact ? 8.0 : 12.0;
    final padding = isCompact ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8) : const EdgeInsets.symmetric(horizontal: 18, vertical: 10);

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final chip = filters[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: padding,
            decoration: BoxDecoration(
              color: chip.isActive ? const Color(0xFF7F4FF8) : const Color(0xFF181C2C),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Row(
              children: [
                Text(
                  chip.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: chip.isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.white.withOpacity(.8)),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: spacing),
      ),
    );
  }
}

class _FolderArea extends StatelessWidget {
  const _FolderArea({
    required this.folders,
    required this.useGrid,
    required this.hoverActions,
  });

  final List<FolderItem> folders;
  final bool useGrid;
  final bool hoverActions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!useGrid) {
          return ListView.separated(
            itemCount: folders.length,
            itemBuilder: (context, index) => _FolderTile(
              item: folders[index],
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          );
        }

        final width = constraints.maxWidth;
        final crossAxisCount = math.max(2, width ~/ 200);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) => _FolderCard(
            item: folders[index],
          ),
        );
      },
    );
  }
}

class _FolderTile extends StatelessWidget {
  const _FolderTile({required this.item});

  final FolderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF11141F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.05)),
      ),
      child: Row(
        children: [
          _FolderIcon(color: item.thumbColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'ส่วนตัว · ${item.itemCount} รายการ',
                  style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({required this.item});

  final FolderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11141F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FolderIcon(color: item.thumbColor),
          const Spacer(),
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            '${item.itemCount} รายการ',
            style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _FolderIcon extends StatelessWidget {
  const _FolderIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const Positioned(
          bottom: 4,
          right: 4,
          child: Icon(
            Icons.lock_outline,
            size: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _SideNavigationRail extends StatelessWidget {
  const _SideNavigationRail({
    required this.isDesktop,
    required this.selectedIndex,
    required this.onSelected,
  });

  final bool isDesktop;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: isDesktop,
      minExtendedWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: isDesktop
            ? Text(
                'Canva',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              )
            : const Icon(Icons.blur_on),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
            const SizedBox(height: 12),
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(.2),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      labelType: isDesktop ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      indicatorColor: const Color(0xFF7F4FF8),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.add), label: Text('สร้าง')),
        NavigationRailDestination(icon: Icon(Icons.folder_special_outlined), label: Text('โฟลเดอร์ของคุณ')),
        NavigationRailDestination(icon: Icon(Icons.upload_file_outlined), label: Text('อัปโหลด')),
        NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text('เพิ่มเติม')),
      ],
    );
  }
}

class FolderItem {
  final String title;
  final int itemCount;
  final Color thumbColor;

  const FolderItem({
    required this.title,
    required this.itemCount,
    this.thumbColor = const Color(0xFF5B5E69),
  });
}

class _FilterChipData {
  final String label;
  final bool isActive;

  _FilterChipData(this.label, this.isActive);
}
