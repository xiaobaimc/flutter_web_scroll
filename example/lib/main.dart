import 'package:flutter/material.dart';
import 'package:smooth_scroll_web/smooth_scroll_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smooth Scroll Web Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ScrollTypeSelector(),
    );
  }
}

class ScrollTypeSelector extends StatelessWidget {
  const ScrollTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smooth Scroll Web Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildScrollTypeCard(
            context,
            'Lenis-style Scrolling',
            'Premium exponential decay scrolling (default)',
            SmoothScrollType.lenis,
            Colors.deepPurple,
          ),
          _buildScrollTypeCard(
            context,
            'Linear Scrolling',
            'Constant speed interpolation',
            SmoothScrollType.linear,
            Colors.blue,
          ),
          _buildScrollTypeCard(
            context,
            'Elastic Scrolling',
            'Spring physics with bounce-back effect',
            SmoothScrollType.elastic,
            Colors.green,
          ),
          _buildScrollTypeCard(
            context,
            'Ease-out Scrolling',
            'Fast start, gradual deceleration',
            SmoothScrollType.easeOut,
            Colors.orange,
          ),
          _buildScrollTypeCard(
            context,
            'Ease-in-out Scrolling',
            'Smooth acceleration and deceleration',
            SmoothScrollType.easeInOut,
            Colors.pink,
          ),
          _buildScrollTypeCard(
            context,
            'Custom Scrolling',
            'Fine-tuned custom behavior',
            SmoothScrollType.custom,
            Colors.teal,
          ),
          _buildScrollTypeCard(
            context,
            'Native HTML Web Scroll',
            'Standard browser scrolling behavior',
            SmoothScrollType.native,
            Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildScrollTypeCard(
    BuildContext context,
    String title,
    String description,
    SmoothScrollType scrollType,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScrollDemoPage(
                scrollType: scrollType,
                title: title,
                color: color,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.swap_vert, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class ScrollDemoPage extends StatefulWidget {
  final SmoothScrollType scrollType;
  final String title;
  final Color color;

  const ScrollDemoPage({
    super.key,
    required this.scrollType,
    required this.title,
    required this.color,
  });

  @override
  State<ScrollDemoPage> createState() => _ScrollDemoPageState();
}

class _ScrollDemoPageState extends State<ScrollDemoPage> {
  late ScrollController _scrollController;
  late SmoothScrollConfig _config;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _config = _getConfigForType(widget.scrollType);
  }

  SmoothScrollConfig _getConfigForType(SmoothScrollType type) {
    switch (type) {
      case SmoothScrollType.lenis:
        return SmoothScrollConfig.lenis(scrollSpeed: 1.2, damping: 0.08);
      case SmoothScrollType.linear:
        return SmoothScrollConfig.linear(scrollSpeed: 1.2, duration: 300);
      case SmoothScrollType.elastic:
        return SmoothScrollConfig.elastic(
          scrollSpeed: 1.2,
          springStiffness: 100.0,
          springDamping: 10.0,
        );
      case SmoothScrollType.easeOut:
        return SmoothScrollConfig.easeOut(scrollSpeed: 1.2, damping: 0.12);
      case SmoothScrollType.easeInOut:
        return SmoothScrollConfig.easeInOut(scrollSpeed: 1.2, damping: 0.1);
      case SmoothScrollType.custom:
        return SmoothScrollConfig.custom(scrollSpeed: 1.5, damping: 0.06);
      case SmoothScrollType.native:
        return SmoothScrollConfig.native(scrollSpeed: 1.0, momentumFactor: 0.6);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color.withOpacity(0.2),
        foregroundColor: widget.color,
      ),
      body: SmoothScrollWeb(
        controller: _scrollController,
        config: _config,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: 50,
          itemBuilder: (context, index) {
            return Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withOpacity(0.3),
                    widget.color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article, size: 48, color: widget.color),
                    const SizedBox(height: 8),
                    Text(
                      'Item ${index + 1}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scroll type: ${widget.scrollType.name}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        backgroundColor: widget.color,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
