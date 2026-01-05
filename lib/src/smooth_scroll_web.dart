import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'scroll_config.dart';
import 'scroll_types.dart';

/// A high-performance smooth scrolling widget for Flutter web applications.
///
/// Provides multiple scroll types including Lenis-style scrolling, linear,
/// elastic, and custom behaviors. Designed to replace native scrolling with
/// smooth, customizable scroll experiences.
///
/// Example:
/// ```dart
/// SmoothScrollWeb(
///   controller: _scrollController,
///   config: SmoothScrollConfig.lenis(),
///   child: ListView(...),
/// )
/// ```
class SmoothScrollWeb extends StatefulWidget {
  /// The child widget to wrap with smooth scrolling.
  final Widget child;

  /// The scroll controller to manage scroll position.
  final ScrollController controller;

  /// Configuration for scroll behavior.
  /// Defaults to Lenis-style scrolling.
  final SmoothScrollConfig config;

  const SmoothScrollWeb({
    super.key,
    required this.child,
    required this.controller,
    this.config = const SmoothScrollConfig(
      scrollType: SmoothScrollType.lenis,
      scrollSpeed: 1.2,
      damping: 0.08,
    ),
  });

  @override
  State<SmoothScrollWeb> createState() => _SmoothScrollWebState();
}

class _SmoothScrollWebState extends State<SmoothScrollWeb>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _targetScroll = 0.0;
  double _currentScroll = 0.0;
  double _velocity = 0.0;
  bool _isScrolling = false;
  DateTime? _lastScrollTime;
  double _lastScrollDelta = 0.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);

    // Sync initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.controller.hasClients) {
        _targetScroll = widget.controller.offset;
        _currentScroll = widget.controller.offset;
      }
    });
  }

  @override
  void didUpdateWidget(SmoothScrollWeb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Controller changed, resync
      if (widget.controller.hasClients) {
        _targetScroll = widget.controller.offset;
        _currentScroll = widget.controller.offset;
      }
    }
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    if (!mounted || !widget.controller.hasClients) return;

    final double distance = _targetScroll - _currentScroll;

    // Calculate velocity magnitude for smooth stopping
    final double previousScroll = _currentScroll;

    // Apply scroll type-specific interpolation
    switch (widget.config.scrollType) {
      case SmoothScrollType.lenis:
        _updateLenis(distance);
        break;
      case SmoothScrollType.linear:
        _updateLinear(distance);
        break;
      case SmoothScrollType.elastic:
        _updateElastic(distance);
        break;
      case SmoothScrollType.custom:
        _updateCustom(distance);
        break;
      case SmoothScrollType.native:
        _updateNative(distance);
        break;
    }

    // Clamp to scroll bounds (unless elastic overscroll is enabled)
    final double maxExtent = widget.controller.position.maxScrollExtent;
    final double minExtent = widget.controller.position.minScrollExtent;

    if (widget.config.scrollType == SmoothScrollType.elastic &&
        widget.config.enableElasticOverscroll) {
      // Allow temporary overscroll for elastic effect
      // Will be pulled back by spring physics
    } else {
      if (_currentScroll < minExtent) _currentScroll = minExtent;
      if (_currentScroll > maxExtent) _currentScroll = maxExtent;
    }

    // Calculate current velocity (pixels per frame, ~16.67ms at 60fps)
    final double currentVelocity = (_currentScroll - previousScroll).abs();
    final double newDistance = _targetScroll - _currentScroll;
    final double roundedScroll = _currentScroll.roundToDouble();
    final double roundedTargetAfter = _targetScroll.roundToDouble();
    final double currentOffset = widget.controller.offset;

    // Smooth stop: only stop when velocity is essentially zero AND we're very close
    // Use more lenient thresholds to prevent premature stops during deceleration
    final double velocityThreshold = 0.00001; // Extremely low velocity threshold
    final double distanceThreshold = 0.00000001; // Very small distance threshold

    // Check if we should stop: velocity is essentially zero AND distance is tiny
    // This ensures we only stop when truly at rest, not during smooth deceleration
    if (currentVelocity < velocityThreshold &&
        newDistance.abs() < distanceThreshold) {
      // Smoothly settle to final position
      final double finalPosition = roundedTargetAfter;
      _currentScroll = finalPosition;
      _targetScroll = finalPosition;
      widget.controller.jumpTo(finalPosition);
      _ticker.stop();
      _isScrolling = false;
      _velocity = 0.0;
      return;
    }

    // Only update if the change is significant (more than 0.5 pixels)
    // This prevents micro-updates that cause vibration
    if ((roundedScroll - currentOffset).abs() >= 0.5) {
      widget.controller.jumpTo(roundedScroll);
    }
  }

  void _updateLenis(double distance) {
    // Exponential decay (Lenis-style) with smooth, continuous deceleration
    final double absDistance = distance.abs();

    // Only apply gentle deceleration when very close to target
    // This ensures smooth, continuous motion without micro-stops
    final double decelerationFactor = absDistance < 5.0
        ? math.max(0.7, absDistance / 5.0)
        : 1.0;

    _currentScroll += distance * widget.config.damping * decelerationFactor;
  }

  void _updateLinear(double distance) {
    // Linear interpolation with smooth, continuous motion
    final double absDistance = distance.abs();

    // Only apply gentle deceleration when very close to target
    final double decelerationFactor = absDistance < 3.0
        ? math.max(0.8, absDistance / 3.0)
        : 1.0;

    final double step =
        distance * widget.config.effectiveDamping * decelerationFactor;
    if (step.abs() > distance.abs()) {
      _currentScroll = _targetScroll;
    } else {
      _currentScroll += step;
    }
  }

  void _updateElastic(double distance) {
    // Spring physics simulation
    final double springForce = distance * widget.config.springStiffness;
    _velocity += springForce * 0.016; // ~60fps
    _velocity *= (1.0 - widget.config.springDamping * 0.016);
    _currentScroll += _velocity * 0.016;

    // Apply damping to velocity
    _velocity *= 0.95;
  }

  void _updateCustom(double distance) {
    // Custom damping with smooth, continuous motion
    final double absDistance = distance.abs();

    // Only apply gentle deceleration when very close to target
    final double decelerationFactor = absDistance < 5.0
        ? math.max(0.7, absDistance / 5.0)
        : 1.0;

    _currentScroll += distance * widget.config.damping * decelerationFactor;
  }

  void _updateNative(double distance) {
    // Native browser-style scrolling with natural smooth deceleration
    final double absDistance = distance.abs();

    // Smooth ease-out curve for natural deceleration
    final double t = math.min(absDistance / 50.0, 1.0);
    final double easeFactor = 1.0 - math.pow(1.0 - t, 3);

    // Only apply gentle deceleration when very close to target
    // This ensures continuous smooth motion without micro-stops
    final double smoothFactor = absDistance < 5.0
        ? math.max(0.7, absDistance / 5.0)
        : 1.0;

    // Apply damping with ease factor and smooth factor for natural feel
    final double step =
        distance *
        widget.config.damping *
        (0.5 + easeFactor * 0.5) *
        smoothFactor;
    _currentScroll += step;
  }

  void _onScroll(PointerScrollEvent event) {
    if (!mounted || !widget.controller.hasClients) return;

    final double maxExtent = widget.controller.position.maxScrollExtent;
    final double minExtent = widget.controller.position.minScrollExtent;

    // Initialize if needed (in case of manual native scrolling mixed in)
    if (!_isScrolling &&
        (widget.controller.offset - _currentScroll).abs() > 1.0) {
      _currentScroll = widget.controller.offset;
      _targetScroll = widget.controller.offset;
    }

    // Track velocity for momentum
    final DateTime now = DateTime.now();

    // Track velocity for momentum
    if (_lastScrollTime != null) {
      final int timeSinceLastScroll = now
          .difference(_lastScrollTime!)
          .inMilliseconds;

      final double dt = timeSinceLastScroll / 1000.0; // Convert to seconds
      if (dt > 0 && dt < 0.1) {
        // Calculate velocity (pixels per second)
        _velocity = event.scrollDelta.dy / dt;
      }
    }

    _lastScrollTime = now;
    _lastScrollDelta = event.scrollDelta.dy;

    // Accumulate the target scroll
    _targetScroll += event.scrollDelta.dy * widget.config.scrollSpeed;

    // Clamp target to prevent infinite "catch up" if user scrolls wildly past bounds
    if (_targetScroll < minExtent) _targetScroll = minExtent;
    if (_targetScroll > maxExtent) _targetScroll = maxExtent;

    if (!_isScrolling) {
      _isScrolling = true;
      _ticker.start();
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!widget.controller.hasClients) return;

    // Update both target and current to track finger exactly during drag
    // (1:1 tracking for best UX)
    _targetScroll -= details.delta.dy;
    _currentScroll = _targetScroll;

    // Clamp
    final double maxExtent = widget.controller.position.maxScrollExtent;
    final double minExtent = widget.controller.position.minScrollExtent;
    if (_targetScroll < minExtent) _targetScroll = minExtent;
    if (_targetScroll > maxExtent) _targetScroll = maxExtent;
    if (_currentScroll < minExtent) _currentScroll = minExtent;
    if (_currentScroll > maxExtent) _currentScroll = maxExtent;

    // Round to avoid sub-pixel jitter during drag
    widget.controller.jumpTo(_currentScroll.roundToDouble());

    // Stop interpolation while dragging
    _isScrolling = false;
    _ticker.stop();
    _velocity = 0.0;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (!widget.config.enableMomentum) {
      _isScrolling = false;
      _ticker.stop();
      return;
    }

    // Project momentum based on velocity
    double velocity = details.primaryVelocity ?? 0;

    // If we have tracked velocity from scroll events, use that
    if (_lastScrollTime != null) {
      final DateTime now = DateTime.now();
      final double dt =
          (now.difference(_lastScrollTime!).inMilliseconds) / 1000.0;
      if (dt < 0.2 && _lastScrollDelta.abs() > 0) {
        // Use recent scroll velocity
        velocity = -_lastScrollDelta * 1000.0 / dt;
      }
    }

    // Apply momentum factor
    _targetScroll -= velocity * widget.config.momentumFactor;

    // Clamp target
    if (widget.controller.hasClients) {
      final double maxExtent = widget.controller.position.maxScrollExtent;
      final double minExtent = widget.controller.position.minScrollExtent;
      if (_targetScroll < minExtent) _targetScroll = minExtent;
      if (_targetScroll > maxExtent) _targetScroll = maxExtent;
    }

    // Start the interpolation to the new target
    if (!_isScrolling) {
      _isScrolling = true;
      _ticker.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            _onScroll(pointerSignal);
          }
        },
        child: widget.child,
      ),
    );
  }
}
