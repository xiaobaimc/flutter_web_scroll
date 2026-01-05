# Flutter Web Scroll

A high-performance, professional smooth scrolling package for Flutter web applications. Provides multiple scroll types including Lenis-style scrolling, linear interpolation, elastic spring physics, custom behaviors, and native browser scrolling.

## Preview

### Without flutter_web_scroll
![Without smooth scroll](https://github.com/zenithsyntax/flutter_web_scroll/raw/main/assets/without_smooth_scroll_web.gif)

### With flutter_web_scroll
![With smooth scroll](https://github.com/zenithsyntax/flutter_web_scroll/raw/main/assets/with_smooth_scroll_web.gif)

## Features

✨ **Multiple Scroll Types**
- **Lenis-style**: Premium exponential decay scrolling (default)
- **Linear**: Constant speed interpolation
- **Elastic**: Spring physics with bounce-back effect
- **Custom**: Fine-tune your own scroll behavior
- **Native**: Standard HTML web browser scrolling behavior

🎯 **Key Features**
- Smooth, native-like scrolling experience
- Momentum scrolling with configurable throw distance
- Drag-to-scroll with 1:1 finger tracking
- Configurable scroll speed and damping
- Elastic overscroll support
- High-performance 60fps animation
- Zero dependencies (Flutter SDK only)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_web_scroll: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:flutter_web_scroll/flutter_web_scroll.dart';

final _scrollController = ScrollController();

SmoothScrollWeb(
  controller: _scrollController,
  config: SmoothScrollConfig.lenis(),
  child: ListView(
    controller: _scrollController,
    children: [
      // Your widgets here
    ],
  ),
)
```

## Usage

### Basic Usage

Wrap your scrollable widget with `SmoothScrollWeb`:

```dart
SmoothScrollWeb(
  controller: _scrollController,
  child: ListView(
    controller: _scrollController,
    children: [...],
  ),
)
```

### Scroll Types

#### Lenis-style Scrolling (Default)

Premium smooth scrolling with exponential decay:

```dart
SmoothScrollWeb(
  controller: _scrollController,
  config: SmoothScrollConfig.lenis(
    scrollSpeed: 1.2,      // Distance multiplier
    damping: 0.08,         // Lower = smoother/heavier
    enableMomentum: true,  // Enable throw scrolling
    momentumFactor: 0.5,   // Throw distance factor
  ),
  child: ListView(...),
)
```

#### Linear Scrolling

Constant speed interpolation:

```dart
SmoothScrollWeb(
  controller: _scrollController,
  config: SmoothScrollConfig.linear(
    scrollSpeed: 1.2,
    duration: 300,         // Animation duration in ms
    enableMomentum: true,
  ),
  child: ListView(...),
)
```

#### Elastic Scrolling

Spring physics with bounce-back:

```dart
SmoothScrollWeb(
  controller: _scrollController,
  config: SmoothScrollConfig.elastic(
    scrollSpeed: 1.2,
    springStiffness: 100.0,  // Higher = stiffer
    springDamping: 10.0,     // Higher = less bouncy
    enableElasticOverscroll: true,
    enableMomentum: true,
  ),
  child: ListView(...),
)
```

#### Custom Scrolling

Fine-tune your own behavior:

```dart
SmoothScrollWeb(
  controller: _scrollController,
  config: SmoothScrollConfig.custom(
    scrollSpeed: 1.5,
    damping: 0.06,         // Your custom damping
    enableMomentum: true,
    momentumFactor: 0.7,
  ),
  child: ListView(...),
)
```

#### Native HTML Web Scroll

Mimics standard browser scrolling behavior:

```dart
SmoothScrollWeb(
  controller: _scrollController,
  config: SmoothScrollConfig.native(
    scrollSpeed: 1.0,      // Standard browser speed
    enableMomentum: true,
    momentumFactor: 0.6,   // Natural momentum
  ),
  child: ListView(...),
)
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_web_scroll/flutter_web_scroll.dart';

class MyScrollablePage extends StatefulWidget {
  @override
  State<MyScrollablePage> createState() => _MyScrollablePageState();
}

class _MyScrollablePageState extends State<MyScrollablePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmoothScrollWeb(
        controller: _scrollController,
        config: SmoothScrollConfig.lenis(
          scrollSpeed: 1.2,
          damping: 0.08,
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 100,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('Item $index'),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## Configuration Options

### SmoothScrollConfig Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `scrollType` | `SmoothScrollType` | `lenis` | Type of scrolling behavior |
| `scrollSpeed` | `double` | `1.2` | Multiplier for scroll distance |
| `damping` | `double` | `0.08` | Damping factor (0.0-1.0, lower = smoother) |
| `linearDuration` | `int` | `300` | Duration for linear scrolling (ms) |
| `springStiffness` | `double` | `100.0` | Spring stiffness for elastic scrolling |
| `springDamping` | `double` | `10.0` | Spring damping for elastic scrolling |
| `enableMomentum` | `bool` | `true` | Enable momentum scrolling after drag |
| `momentumFactor` | `double` | `0.5` | Momentum throw distance factor |
| `enableElasticOverscroll` | `bool` | `true` | Enable elastic overscroll at boundaries |
| `stopThreshold` | `double` | `0.1` | Distance threshold to stop scrolling (px) |

## Performance

- Runs at 60fps using Flutter's `Ticker`
- Efficient interpolation calculations
- Minimal memory footprint
- Zero external dependencies

## Platform Support

- ✅ Flutter Web
- ✅ Flutter Desktop (Windows, macOS, Linux)
- ⚠️ Flutter Mobile (works but native scrolling is recommended)

## Best Practices

1. **Use appropriate scroll types**: Lenis-style is great for most cases, elastic for playful UIs, linear for predictable behavior, custom for fine-tuned control, and native for standard browser feel.

2. **Tune damping values**: Lower damping (0.05-0.08) = smoother/heavier feel. Higher damping (0.12-0.2) = snappier/more responsive.

3. **Adjust scroll speed**: Higher values (1.5-2.0) for faster scrolling, lower (0.8-1.0) for slower, more controlled scrolling.

4. **Disable momentum if needed**: Set `enableMomentum: false` for precise, controlled scrolling without throw effects.

5. **Use elastic overscroll sparingly**: Can be distracting in professional applications but great for playful interfaces.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

Inspired by [Lenis](https://github.com/studio-freight/lenis) - a smooth scroll library for the web.
