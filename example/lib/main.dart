import 'package:flutter/material.dart';
import 'package:flutter_web_scroll/flutter_web_scroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smooth Scroll Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF333333),
          surface: Color(0xFF111111),
          background: Colors.black,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w900,
            letterSpacing: -2.0,
            color: Colors.white,
            height: 1.0,
          ),
          displayMedium: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFFAAAAAA),
            height: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
      home: const PremiumHomePage(),
    );
  }
}

class PremiumHomePage extends StatefulWidget {
  const PremiumHomePage({super.key});

  @override
  State<PremiumHomePage> createState() => _PremiumHomePageState();
}

class _PremiumHomePageState extends State<PremiumHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmoothScrollWeb(
        controller: _scrollController,
        config: SmoothScrollConfig.lenis(scrollSpeed: 1.2, damping: 0.1),
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          children: [
            const _HeroSection(),
            const SizedBox(height: 100),
            _SectionHeader(
              title: "SELECT SCROLL TYPE",
              subtitle: "Experience different physics",
            ),
            const SizedBox(height: 40),
            const _ScrollTypeGrid(),
            const SizedBox(height: 100),
            _SectionHeader(
              title: "NATIVE COMPARISON",
              subtitle: "See the difference",
            ),
            const SizedBox(height: 40),
            const _NativeComparisonSection(),
            const SizedBox(height: 100),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "FLUTTER WEB PACKAGE",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "SILKY\nSMOOTH\nIS HERE.",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 500,
            child: Text(
              "High-performance smooth scrolling for Flutter web. "
              "Includes Lenis-style, linear, elastic, custom, and native physics "
              "to make your web apps feel premium.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 48),
          const _ScrollIndicator(),
        ],
      ),
    );
  }
}

class _ScrollIndicator extends StatelessWidget {
  const _ScrollIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 1, height: 60, color: Colors.white24),
        const SizedBox(height: 16),
        Text(
          "SCROLL DOWN",
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontSize: 10, color: Colors.white30),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.white54),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 32),
          ),
        ],
      ),
    );
  }
}

class _ScrollTypeGrid extends StatelessWidget {
  const _ScrollTypeGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _ScrollCard(
            title: "Lenis Style",
            description: "Premium exponential decay. The gold standard.",
            type: SmoothScrollType.lenis,
            color: const Color(0xFF6E56CF),
          ),
          _ScrollCard(
            title: "Linear",
            description: "Constant speed. Precise and mechanical.",
            type: SmoothScrollType.linear,
            color: const Color(0xFF0091FF),
          ),
          _ScrollCard(
            title: "Elastic",
            description: "Bouncy spring physics for playful UIs.",
            type: SmoothScrollType.elastic,
            color: const Color(0xFF34C759),
          ),
          _ScrollCard(
            title: "Custom",
            description: "Fully configurable parameters.",
            type: SmoothScrollType.custom,
            color: const Color(0xFFFF2D55),
          ),
          _ScrollCard(
            title: "Native (Web)",
            description: "Standard browser behavior wrapped.",
            type: SmoothScrollType.native,
            color: const Color(0xFF8E8E93),
          ),
        ],
      ),
    );
  }
}

class _NativeComparisonSection extends StatelessWidget {
  const _NativeComparisonSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: _ScrollCard(
        title: "Default Browser Scroll",
        description:
            "The raw default scrolling experience without this package. Feel the difference.",
        type: null, // Indicates native/no-package
        color: const Color(0xFFE5E5EA),
        isDarkHost: false,
        width: double.infinity,
      ),
    );
  }
}

class _ScrollCard extends StatefulWidget {
  final String title;
  final String description;
  final SmoothScrollType? type;
  final Color color;
  final bool isDarkHost;
  final double width;

  const _ScrollCard({
    required this.title,
    required this.description,
    required this.type,
    required this.color,
    this.isDarkHost = true,
    this.width = 350,
  });

  @override
  State<_ScrollCard> createState() => _ScrollCardState();
}

class _ScrollCardState extends State<_ScrollCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.type != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScrollDemoPage(
                  type: widget.type!,
                  title: widget.title,
                  color: widget.color,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NativeScrollDemoPage(),
              ),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: widget.isDarkHost
                ? const Color(0xFF111111)
                : const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(0), // Sharp, brutalist
            border: Border.all(
              color: _isHovered ? widget.color : Colors.white10,
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.title.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: widget.isDarkHost ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.isDarkHost ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    "TRY DEMO",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: widget.isDarkHost ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: widget.isDarkHost ? Colors.white : Colors.black,
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

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Center(
        child: Text(
          "BUILT WITH SMOOTH_SCROLL_WEB",
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white24),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DEMO PAGES
// -----------------------------------------------------------------------------

class ScrollDemoPage extends StatefulWidget {
  final SmoothScrollType type;
  final String title;
  final Color color;

  const ScrollDemoPage({
    super.key,
    required this.type,
    required this.title,
    required this.color,
  });

  @override
  State<ScrollDemoPage> createState() => _ScrollDemoPageState();
}

class _ScrollDemoPageState extends State<ScrollDemoPage> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SmoothScrollWeb(
        controller: _controller,
        config: _getConfig(),
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.black.withValues(alpha: 0.8),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 16,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: Colors.white12, height: 1),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _DemoContentCard(index: index, color: widget.color),
                  );
                }, childCount: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SmoothScrollConfig _getConfig() {
    switch (widget.type) {
      case SmoothScrollType.lenis:
        return SmoothScrollConfig.lenis();
      case SmoothScrollType.linear:
        return SmoothScrollConfig.linear();
      case SmoothScrollType.elastic:
        return SmoothScrollConfig.elastic();
      case SmoothScrollType.custom:
        return SmoothScrollConfig.custom(scrollSpeed: 1.5, damping: 0.05);
      case SmoothScrollType.native:
        return SmoothScrollConfig.native();
    }
  }
}

class NativeScrollDemoPage extends StatefulWidget {
  const NativeScrollDemoPage({super.key});

  @override
  State<NativeScrollDemoPage> createState() => _NativeScrollDemoPageState();
}

class _NativeScrollDemoPageState extends State<NativeScrollDemoPage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "NATIVE BROWSER SCROLL",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 16,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: Colors.black12, height: 1),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _DemoContentCard(
                    index: index,
                    color: Colors.black,
                    isDark: false,
                  ),
                );
              }, childCount: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoContentCard extends StatelessWidget {
  final int index;
  final Color color;
  final bool isDark;

  const _DemoContentCard({
    required this.index,
    required this.color,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "0${index + 1}",
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: color.withValues(alpha: 0.3),
                  height: 1.0,
                ),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_outward, color: color),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "SCROLL CONTENT TITLE ${index + 1}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Experience the physics and smoothness of this scrolling behavior. "
            "Notice how it reacts to your input momentum.",
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
