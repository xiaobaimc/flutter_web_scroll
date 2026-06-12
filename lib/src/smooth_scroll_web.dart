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
/// This widget wraps scrollable widgets (ListView, CustomScrollView, etc.)
/// and provides smooth, physics-based scrolling animations that run at 60fps.
///
/// Example:
/// ```dart
/// import 'package:flutter_web_scroll/flutter_web_scroll.dart';
///
/// SmoothScrollWeb(
///   controller: _scrollController,
///   config: SmoothScrollConfig.lenis(),
///   child: ListView(...),
/// )
/// ```
class SmoothScrollWeb extends StatefulWidget {
  /// The child widget to wrap with smooth scrolling.
  ///
  /// Typically a [ListView], [CustomScrollView], or other scrollable widget.
  final Widget child;

  /// The scroll controller to manage scroll position.
  ///
  /// Must be the same controller used by the child scrollable widget.
  final ScrollController controller;

  /// Configuration for scroll behavior.
  ///
  /// Defaults to Lenis-style scrolling with optimized parameters.
  final SmoothScrollConfig config;

  /// Creates a [SmoothScrollWeb] widget.
  ///
  /// The [controller] must be provided and should be the same instance
  /// used by the child scrollable widget.
  ///
  /// The [config] parameter allows customization of scroll behavior.
  /// If not provided, defaults to Lenis-style scrolling.
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

/// Internal state for [SmoothScrollWeb].
///
/// Manages scroll animation, velocity tracking, and gesture handling.
class _SmoothScrollWebState extends State<SmoothScrollWeb>
    with SingleTickerProviderStateMixin {
  /// Animation ticker for smooth scroll updates.
  late final Ticker _ticker;

  /// Target scroll position to animate towards.
  double _targetScroll = 0.0;

  /// Current scroll position during animation.
  double _currentScroll = 0.0;

  /// Current scroll velocity (pixels per second).
  double _velocity = 0.0;

  /// Whether scrolling animation is currently active.
  bool _isScrolling = false;

  /// Timestamp of the last scroll event for velocity calculation.
  DateTime? _lastScrollTime;

  /// Last scroll delta for momentum calculation.
  double _lastScrollDelta = 0.0;

  /// Last tick time for delta time calculation.
  Duration? _lastTickTime;

  /// Frame time in seconds (approximately 16.67ms at 60fps).
  static const double _frameTimeSeconds = 1.0 / 60.0;

  /// Velocity threshold for stopping animation (pixels per frame).
  static const double _velocityThreshold = 0.05;

  /// Distance threshold for stopping animation (pixels).
  static const double _distanceThreshold = 0.05;

  /// Minimum pixel change required to update scroll position.
  static const double _minUpdateDelta = 0.5;

  /// Deceleration distance threshold for Lenis-style scrolling.
  static const double _lenisDecelerationThreshold = 5.0;

  /// Deceleration distance threshold for linear scrolling.
  static const double _linearDecelerationThreshold = 3.0;

  /// Deceleration distance threshold for custom scrolling.
  static const double _customDecelerationThreshold = 5.0;

  /// Deceleration distance threshold for native scrolling.
  static const double _nativeDecelerationThreshold = 5.0;

  /// Minimum deceleration factor to prevent micro-stops.
  static const double _minDecelerationFactor = 0.7;

  /// Linear deceleration minimum factor.
  static const double _linearMinDecelerationFactor = 0.8;

  /// Spring velocity damping factor.
  static const double _springVelocityDamping = 0.95;

  /// Native scroll ease-out distance normalization.
  static const double _nativeEaseDistance = 50.0;

  /// Native scroll ease-out power.
  static const double _nativeEasePower = 3.0;

  /// Maximum time delta for velocity calculation (seconds).
  static const double _maxVelocityTimeDelta = 0.1;

  /// Maximum time delta for scroll velocity tracking (seconds).
  static const double _maxScrollVelocityTimeDelta = 0.2;

  /// Minimum scroll delta to consider for velocity tracking.
  static const double _minScrollDelta = 0.0;

  /// Position sync threshold (pixels).
  static const double _positionSyncThreshold = 1.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _syncScrollPosition();
  }

  /// Synchronizes the internal scroll position with the controller.
  ///
  /// Called after the first frame to ensure the controller is attached
  /// and has valid scroll extents.
  void _syncScrollPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.controller.hasClients) return;
      final double offset = widget.controller.offset;
      _targetScroll = offset;
      _currentScroll = offset;
    });
  }

  @override
  void didUpdateWidget(SmoothScrollWeb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _resyncController();
    }
  }

  /// Resynchronizes scroll position when the controller changes.
  void _resyncController() {
    if (widget.controller.hasClients) {
      final double offset = widget.controller.offset;
      _targetScroll = offset;
      _currentScroll = offset;
    }
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  /// Main animation tick callback.
  ///
  /// Updates scroll position based on the configured scroll type and
  /// applies physics-based interpolation.
  ///
  /// [elapsed] is the time elapsed since the ticker started.
  void _tick(Duration elapsed) {
    if (!mounted || !widget.controller.hasClients) return;

    final double dt = _lastTickTime != null
        ? (elapsed - _lastTickTime!).inMicroseconds / 1000000.0
        : _frameTimeSeconds;
    _lastTickTime = elapsed;
    
    // Safety check for massive frame drops (cap dt to 100ms)
    final double safeDt = dt > 0.1 ? 0.1 : dt;

    final double distance = _targetScroll - _currentScroll;
    final double previousScroll = _currentScroll;

    // Apply scroll type-specific interpolation
    _applyScrollInterpolation(distance, safeDt);

    // Clamp to scroll bounds (unless elastic overscroll is enabled)
    _clampScrollPosition();

    if (widget.controller.hasClients) {
      final double controllerOffset = widget.controller.offset;
      // Detect if scroll position was changed externally (e.g., by native scrollbar drag)
      if ((controllerOffset - previousScroll.roundToDouble()).abs() > 5.0) {
        _currentScroll = controllerOffset;
        _targetScroll = controllerOffset;
        _stopAnimation();
        return;
      }
    }

    // Check if animation should stop
    if (_shouldStopAnimation(previousScroll)) {
      widget.controller.jumpTo(_targetScroll.roundToDouble());
      _stopAnimation();
      return;
    }

    // Update controller if change is significant
    _updateControllerIfNeeded();
  }

  /// Applies scroll interpolation based on the configured scroll type.
  ///
  /// [distance] is the distance to the target position.
  /// [frameTime] is the time elapsed since last frame in seconds.
  void _applyScrollInterpolation(double distance, double frameTime) {
    switch (widget.config.scrollType) {
      case SmoothScrollType.lenis:
        _updateLenis(distance, frameTime);
        break;
      case SmoothScrollType.linear:
        _updateLinear(distance, frameTime);
        break;
      case SmoothScrollType.elastic:
        _updateElastic(distance, frameTime);
        break;
      case SmoothScrollType.custom:
        _updateCustom(distance, frameTime);
        break;
      case SmoothScrollType.native:
        _updateNative(distance, frameTime);
        break;
    }
  }

  /// Clamps scroll position to valid bounds.
  ///
  /// Allows temporary overscroll for elastic effects if enabled.
  void _clampScrollPosition() {
    if (!widget.controller.hasClients) return;

    final double maxExtent = widget.controller.position.maxScrollExtent;
    final double minExtent = widget.controller.position.minScrollExtent;

    final bool allowOverscroll =
        widget.config.scrollType == SmoothScrollType.elastic &&
        widget.config.enableElasticOverscroll;

    if (!allowOverscroll) {
      if (_currentScroll < minExtent) _currentScroll = minExtent;
      if (_currentScroll > maxExtent) _currentScroll = maxExtent;
    }
  }

  /// Determines if the animation should stop.
  ///
  /// Returns true when velocity and distance are below thresholds,
  /// indicating the scroll has reached rest.
  bool _shouldStopAnimation(double previousScroll) {
    final double currentVelocity = (_currentScroll - previousScroll).abs();
    final double newDistance = (_targetScroll - _currentScroll).abs();

    final bool isNearTarget = newDistance < _distanceThreshold;
    final bool isLowVelocity = currentVelocity < _velocityThreshold;

    return isNearTarget && isLowVelocity;
  }

  /// Stops the animation and settles to final position.
  void _stopAnimation() {
    final double finalPosition = _targetScroll.roundToDouble();
    _currentScroll = finalPosition;
    _targetScroll = finalPosition;

    if (widget.controller.hasClients) {
      widget.controller.jumpTo(finalPosition);
    }

    _ticker.stop();
    _lastTickTime = null;
    _isScrolling = false;
    _velocity = 0.0;
  }

  /// Updates the scroll controller if the change is significant.
  ///
  /// Prevents micro-updates that can cause visual vibration.
  void _updateControllerIfNeeded() {
    if (!widget.controller.hasClients) return;

    final double roundedScroll = _currentScroll.roundToDouble();
    final double currentOffset = widget.controller.offset;
    final double delta = (roundedScroll - currentOffset).abs();

    if (delta >= _minUpdateDelta) {
      widget.controller.jumpTo(roundedScroll);
    }
  }

  /// Updates scroll position using Lenis-style exponential decay.
  ///
  /// Provides smooth, continuous deceleration with exponential interpolation.
  /// Applies gentle deceleration near the target to prevent micro-stops.
  ///
  /// [distance] is the distance to the target position.
  void _updateLenis(double distance, double dt) {
    final double absDistance = distance.abs();
    final double decelerationFactor = absDistance < _lenisDecelerationThreshold
        ? math.max(
            _minDecelerationFactor,
            absDistance / _lenisDecelerationThreshold,
          )
        : 1.0;

    final double lerpFactor = 1.0 - math.pow(1.0 - widget.config.damping, dt * 60.0).toDouble();
    _currentScroll += distance * lerpFactor * decelerationFactor;
  }

  /// Updates scroll position using linear interpolation.
  ///
  /// Provides constant-speed interpolation with smooth deceleration near target.
  ///
  /// [distance] is the distance to the target position.
  void _updateLinear(double distance, double dt) {
    final double absDistance = distance.abs();
    final double decelerationFactor = absDistance < _linearDecelerationThreshold
        ? math.max(
            _linearMinDecelerationFactor,
            absDistance / _linearDecelerationThreshold,
          )
        : 1.0;

    final double lerpFactor = 1.0 - math.pow(1.0 - widget.config.effectiveDamping, dt * 60.0).toDouble();
    final double step =
        distance * lerpFactor * decelerationFactor;
    if (step.abs() > distance.abs()) {
      _currentScroll = _targetScroll;
    } else {
      _currentScroll += step;
    }
  }

  /// Updates scroll position using elastic spring physics.
  ///
  /// Simulates spring-mass-damper system for bouncy, elastic scrolling.
  ///
  /// [distance] is the distance to the target position.
  /// [frameTime] is the time elapsed since last frame in seconds.
  void _updateElastic(double distance, double frameTime) {
    final double springForce = distance * widget.config.springStiffness;
    _velocity += springForce * frameTime;
    _velocity *= (1.0 - widget.config.springDamping * frameTime);
    _currentScroll += _velocity * frameTime;

    // Apply additional velocity damping for stability
    _velocity *= math.pow(_springVelocityDamping, frameTime * 60.0).toDouble();
  }

  /// Updates scroll position using custom damping.
  ///
  /// Applies user-defined damping with smooth deceleration near target.
  ///
  /// [distance] is the distance to the target position.
  void _updateCustom(double distance, double dt) {
    final double absDistance = distance.abs();
    final double decelerationFactor = absDistance < _customDecelerationThreshold
        ? math.max(
            _minDecelerationFactor,
            absDistance / _customDecelerationThreshold,
          )
        : 1.0;

    final double lerpFactor = 1.0 - math.pow(1.0 - widget.config.damping, dt * 60.0).toDouble();
    _currentScroll += distance * lerpFactor * decelerationFactor;
  }

  /// Updates scroll position using native browser-style scrolling.
  ///
  /// Mimics standard browser scrolling with ease-out deceleration curve.
  ///
  /// [distance] is the distance to the target position.
  void _updateNative(double distance, double dt) {
    final double absDistance = distance.abs();

    // Smooth ease-out curve for natural deceleration
    final double t = math.min(absDistance / _nativeEaseDistance, 1.0);
    final double easeFactor = 1.0 - math.pow(1.0 - t, _nativeEasePower).toDouble();

    // Apply gentle deceleration when very close to target
    final double smoothFactor = absDistance < _nativeDecelerationThreshold
        ? math.max(
            _minDecelerationFactor,
            absDistance / _nativeDecelerationThreshold,
          )
        : 1.0;

    // Apply damping with ease factor and smooth factor for natural feel
    final double lerpFactor = 1.0 - math.pow(1.0 - widget.config.damping, dt * 60.0).toDouble();
    final double step =
        distance *
        lerpFactor *
        (0.5 + easeFactor * 0.5) *
        smoothFactor;
    _currentScroll += step;
  }

  /// Handles pointer scroll events (mouse wheel, trackpad).
  ///
  /// Updates target scroll position and calculates velocity for momentum.
  ///
  /// [event] contains scroll delta and timing information.
  void _onScroll(PointerScrollEvent event) {
    if (!mounted || !widget.controller.hasClients) return;

    _syncPositionIfNeeded();
    _updateScrollVelocity(event);
    _updateTargetScroll(event);

    if (!_isScrolling) {
      _isScrolling = true;
      _lastTickTime = null;
      _ticker.start();
    } else {
      if (!_ticker.isTicking) {
        _lastTickTime = null;
        _ticker.start();
      }
    }
  }

  /// Synchronizes position if there's a significant discrepancy.
  ///
  /// Handles cases where native scrolling may have occurred externally.
  void _syncPositionIfNeeded() {
    if (!_isScrolling &&
        (widget.controller.offset - _currentScroll).abs() >
            _positionSyncThreshold) {
      final double offset = widget.controller.offset;
      _currentScroll = offset;
      _targetScroll = offset;
    }
  }

  /// Updates scroll velocity based on recent scroll events.
  ///
  /// Calculates velocity in pixels per second for momentum scrolling.
  ///
  /// [event] contains the scroll delta information.
  void _updateScrollVelocity(PointerScrollEvent event) {
    final DateTime now = DateTime.now();

    if (_lastScrollTime != null) {
      final int timeSinceLastScroll = now
          .difference(_lastScrollTime!)
          .inMilliseconds;
      final double dt = timeSinceLastScroll / 1000.0; // Convert to seconds

      if (dt > 0 && dt < _maxVelocityTimeDelta) {
        // Calculate velocity (pixels per second)
        _velocity = event.scrollDelta.dy / dt;
      }
    }

    _lastScrollTime = now;
    _lastScrollDelta = event.scrollDelta.dy;
  }

  /// Updates the target scroll position based on scroll event.
  ///
  /// Applies scroll speed multiplier and clamps to valid bounds.
  ///
  /// [event] contains the scroll delta information.
  void _updateTargetScroll(PointerScrollEvent event) {
    if (!widget.controller.hasClients) return;

    final double maxExtent = widget.controller.position.maxScrollExtent;
    final double minExtent = widget.controller.position.minScrollExtent;

    // Accumulate the target scroll with speed multiplier
    _targetScroll += event.scrollDelta.dy * widget.config.scrollSpeed;

    // Clamp target to prevent infinite "catch up" if user scrolls past bounds
    if (_targetScroll < minExtent) _targetScroll = minExtent;
    if (_targetScroll > maxExtent) _targetScroll = maxExtent;
  }

  /// Starts the scrolling animation if not already active.
  void _startScrollingIfNeeded() {
    if (!_isScrolling) {
      _isScrolling = true;
      _lastTickTime = null;
      _ticker.start();
    }
  }

  /// Handles vertical drag update events (touch/mouse drag).
  ///
  /// Provides 1:1 tracking of drag position for immediate responsiveness.
  ///
  /// [details] contains drag delta and position information.
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!widget.controller.hasClients) return;

    // Update both target and current to track finger exactly during drag
    // (1:1 tracking for best UX)
    _targetScroll -= details.delta.dy;
    _currentScroll = _targetScroll;

    // Clamp to valid scroll bounds
    _clampDragPosition();

    // Round to avoid sub-pixel jitter during drag
    widget.controller.jumpTo(_currentScroll.roundToDouble());

    // Stop interpolation while dragging
    _stopDragInterpolation();
  }

  /// Clamps drag position to valid scroll bounds.
  void _clampDragPosition() {
    if (!widget.controller.hasClients) return;

    final double maxExtent = widget.controller.position.maxScrollExtent;
    final double minExtent = widget.controller.position.minScrollExtent;

    if (_targetScroll < minExtent) _targetScroll = minExtent;
    if (_targetScroll > maxExtent) _targetScroll = maxExtent;
    if (_currentScroll < minExtent) _currentScroll = minExtent;
    if (_currentScroll > maxExtent) _currentScroll = maxExtent;
  }

  /// Stops interpolation during drag for immediate response.
  void _stopDragInterpolation() {
    _isScrolling = false;
    _ticker.stop();
    _lastTickTime = null;
    _velocity = 0.0;
  }

  /// Handles vertical drag end events (touch/mouse release).
  ///
  /// Applies momentum scrolling if enabled, projecting velocity forward.
  ///
  /// [details] contains velocity and drag end information.
  void _onVerticalDragEnd(DragEndDetails details) {
    if (!widget.config.enableMomentum) {
      _isScrolling = false;
      _ticker.stop();
      _lastTickTime = null;
      return;
    }

    final double velocity = _calculateMomentumVelocity(details);
    _applyMomentum(velocity);
    _startScrollingIfNeeded();
  }

  /// Calculates momentum velocity from drag end or recent scroll events.
  ///
  /// Prefers tracked scroll velocity if recent, otherwise uses drag velocity.
  ///
  /// [details] contains drag end velocity information.
  /// Returns velocity in pixels per second.
  double _calculateMomentumVelocity(DragEndDetails details) {
    double velocity = details.primaryVelocity ?? 0.0;

    // If we have tracked velocity from recent scroll events, use that
    if (_lastScrollTime != null) {
      final DateTime now = DateTime.now();
      final int timeSinceLastScroll = now
          .difference(_lastScrollTime!)
          .inMilliseconds;
      final double dt = timeSinceLastScroll / 1000.0;

      if (dt < _maxScrollVelocityTimeDelta &&
          _lastScrollDelta.abs() > _minScrollDelta) {
        // Use recent scroll velocity (convert to pixels per second)
        velocity = -_lastScrollDelta * 1000.0 / dt;
      }
    }

    return velocity;
  }

  /// Applies momentum to target scroll position.
  ///
  /// Projects velocity forward using momentum factor and clamps to bounds.
  ///
  /// [velocity] is the velocity in pixels per second.
  void _applyMomentum(double velocity) {
    // Apply momentum factor to project velocity forward
    _targetScroll -= velocity * widget.config.momentumFactor;

    // Clamp target to valid bounds
    if (widget.controller.hasClients) {
      final double maxExtent = widget.controller.position.maxScrollExtent;
      final double minExtent = widget.controller.position.minScrollExtent;
      if (_targetScroll < minExtent) _targetScroll = minExtent;
      if (_targetScroll > maxExtent) _targetScroll = maxExtent;
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
