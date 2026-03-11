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
    FolderItem(title: 'Software Testing', itemCount: 1,),
    FolderItem(title: 'Mobile presentation', itemCount: 1,),
    FolderItem(title: 'อัปโหลด', itemCount: 0, thumbColor: Color(0xFF666B7D)),
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 1280;
        final isTablet = width >= 769 && width < 1280;
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
    final width = MediaQuery.of(context).size.width;
    final isLarge = isDesktop || width >= 700;
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
        crossAxisAlignment: isLarge ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          SizedBox(height: isLarge ? 32 : 16),
          Text(
            'โปรเจ็กต์ทั้งหมด',
            textAlign: isLarge ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isLarge ? 36 : 24,
                ),
          ),
          const SizedBox(height: 20),
          if (isLarge)
            Align(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                ),
                child: const _SearchBar(),
              ),
            )
          else
            const _SearchBar(),
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
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF10131F),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
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
        separatorBuilder: (_, _) => SizedBox(width: spacing),
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
              hoverActions: hoverActions,
            ),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
          );
        }

        final width = constraints.maxWidth;
        final crossAxisCount = math.max(1, width ~/ 380);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) => _FolderCard(
            hoverActions: hoverActions,
            item: folders[index],
          ),
        );
      },
    );
  }
}

class _FolderTile extends StatefulWidget {
  const _FolderTile({required this.item, required this.hoverActions});

  final FolderItem item;
  final bool hoverActions;

  @override
  State<_FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<_FolderTile> {
  bool _hovered = false;

  void _handleHover(bool hover) {
    if (!widget.hoverActions) return;
    setState(() => _hovered = hover);
  }

  Widget _buildActions(BuildContext context) {
    final group = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: Colors.white.withOpacity(.08),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            _ActionPill(
              icon: Icons.star_border,
              hoverEnabled: widget.hoverActions,
              margin: EdgeInsets.zero,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            _ActionPill(
              icon: Icons.more_horiz,
              hoverEnabled: widget.hoverActions,
              margin: EdgeInsets.zero,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.hoverActions) return group;

    return AnimatedOpacity(
      opacity: _hovered ? 1 : 0,
      duration: const Duration(milliseconds: 180),
      child: IgnorePointer(
        ignoring: !_hovered,
        child: group,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF11141F),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.05)),
        ),
        child: Row(
          children: [
            _FolderIcon(color: widget.item.thumbColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'ส่วนตัว · ${widget.item.itemCount} รายการ',
                    style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }
}

class _FolderCard extends StatefulWidget {
  const _FolderCard({required this.item, required this.hoverActions});

  final FolderItem item;
  final bool hoverActions;

  @override
  State<_FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<_FolderCard> {
  bool _hovered = false;

  void _handleHover(bool hover) {
    if (!widget.hoverActions) return;
    setState(() => _hovered = hover);
  }

  Widget _buildActions(BuildContext context) {
    final group = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.white.withOpacity(.08),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionPill(
              icon: Icons.star_border,
              hoverEnabled: widget.hoverActions,
              margin: EdgeInsets.zero,
              size: 40,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            _ActionPill(
              icon: Icons.more_horiz,
              hoverEnabled: widget.hoverActions,
              margin: EdgeInsets.zero,
              size: 40,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.hoverActions) return group;

    return AnimatedOpacity(
      opacity: _hovered ? 1 : 0,
      duration: const Duration(milliseconds: 180),
      child: IgnorePointer(
        ignoring: !_hovered,
        child: group,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showChrome = !widget.hoverActions || _hovered;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: showChrome ? const Color(0xFF11141F) : const Color.fromARGB(0, 0, 0, 0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: showChrome ? Colors.white.withOpacity(.05) : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FolderIcon(color: widget.item.thumbColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF191C28),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'ส่วนตัว',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.item.itemCount} รายการ',
                        style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildActions(context),
          ],
        ),
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
          width: 70,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class _ActionPill extends StatefulWidget {
  const _ActionPill({
    required this.icon,
    required this.hoverEnabled,
    this.margin = const EdgeInsets.only(left: 8),
    this.size = 36,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final IconData icon;
  final bool hoverEnabled;
  final EdgeInsets margin;
  final double size;
  final BorderRadiusGeometry borderRadius;

  @override
  State<_ActionPill> createState() => _ActionPillState();
}

class _ActionPillState extends State<_ActionPill> {
  bool _hovered = false;

  void _setHover(bool value) {
    if (!widget.hoverEnabled) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final isHover = widget.hoverEnabled && _hovered;
    const hoverColor = Color(0xFF7F4FF8);
    final hoverRadius = BorderRadius.circular(widget.size * .2);

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: widget.margin,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: isHover ? hoverColor : const Color(0x12131A28),
            borderRadius: isHover ? hoverRadius : widget.borderRadius,
            border: Border.all(
              color: isHover ? hoverColor : Colors.transparent,
            ),
          ),
          child: Icon(
            widget.icon,
            size: widget.size * .5,
            color: Colors.white,
          ),
        ),
      ),
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
        child:
             Text(
                'Canva',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              )
      ),
      
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      labelType: isDesktop ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      indicatorColor: const Color(0xFF7F4FF8),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.add), label: Text('สร้าง')),
        NavigationRailDestination(icon: Icon(Icons.folder_special_outlined), label: Text('โฟลเดอร์ของคุณ')),
        NavigationRailDestination(icon: Icon(Icons.upload_file_outlined), label: Text('อัปโหลด')),
        NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text('เพิ่มเติม')),
        NavigationRailDestination(icon: Icon(Icons.notifications_outlined), label: Text('การแจ้งเตือน')),
        NavigationRailDestination(icon: Icon(Icons.person, color: Colors.white), label: Text('โปรไฟล์'))
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
