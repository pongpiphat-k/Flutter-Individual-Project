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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
