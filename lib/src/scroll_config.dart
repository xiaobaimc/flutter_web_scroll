import 'scroll_types.dart';

/// Configuration class for smooth scrolling behavior.
class SmoothScrollConfig {
  /// The type of scrolling behavior to use.
  final SmoothScrollType scrollType;

  /// Multiplier for scroll distance (how far each scroll event moves).
  /// Higher values = more distance per scroll.
  /// Default: 1.2
  final double scrollSpeed;

  /// Damping factor for smooth interpolation (0.0 to 1.0).
  /// Lower values = smoother/heavier feel (more inertia).
  /// Higher values = snappier/more responsive.
  /// Default varies by scroll type.
  final double damping;

  /// Duration for linear scrolling (in milliseconds).
  /// Only used for [SmoothScrollType.linear].
  final int linearDuration;

  /// Spring stiffness for elastic scrolling (higher = stiffer).
  /// Only used for [SmoothScrollType.elastic].
  final double springStiffness;

  /// Spring damping for elastic scrolling (higher = less bouncy).
  /// Only used for [SmoothScrollType.elastic].
  final double springDamping;

  /// Enable momentum scrolling after drag ends.
  /// Default: true
  final bool enableMomentum;

  /// Momentum factor for throw scrolling (how far it slides).
  /// Only used when [enableMomentum] is true.
  /// Default: 0.5
  final double momentumFactor;

  /// Enable elastic overscroll at boundaries.
  /// Only used for [SmoothScrollType.elastic].
  /// Default: true
  final bool enableElasticOverscroll;

  /// Threshold distance to stop scrolling (in pixels).
  /// When distance to target is less than this, scrolling stops.
  /// Default: 0.1
  final double stopThreshold;

  const SmoothScrollConfig({
    this.scrollType = SmoothScrollType.lenis,
    this.scrollSpeed = 1.2,
    this.damping = 0.08,
    this.linearDuration = 300,
    this.springStiffness = 100.0,
    this.springDamping = 10.0,
    this.enableMomentum = true,
    this.momentumFactor = 0.5,
    this.enableElasticOverscroll = true,
    this.stopThreshold = 0.1,
  })  : assert(scrollSpeed > 0, 'scrollSpeed must be positive'),
        assert(damping > 0 && damping <= 1.0, 'damping must be between 0 and 1'),
        assert(linearDuration > 0, 'linearDuration must be positive'),
        assert(springStiffness > 0, 'springStiffness must be positive'),
        assert(springDamping > 0, 'springDamping must be positive'),
        assert(momentumFactor >= 0, 'momentumFactor must be non-negative'),
        assert(stopThreshold > 0, 'stopThreshold must be positive');

  /// Creates a Lenis-style scroll configuration.
  factory SmoothScrollConfig.lenis({
    double scrollSpeed = 1.2,
    double damping = 0.08,
    bool enableMomentum = true,
    double momentumFactor = 0.5,
  }) {
    return SmoothScrollConfig(
      scrollType: SmoothScrollType.lenis,
      scrollSpeed: scrollSpeed,
      damping: damping,
      enableMomentum: enableMomentum,
      momentumFactor: momentumFactor,
    );
  }

  /// Creates a linear scroll configuration.
  factory SmoothScrollConfig.linear({
    double scrollSpeed = 1.2,
    int duration = 300,
    bool enableMomentum = true,
    double momentumFactor = 0.5,
  }) {
    return SmoothScrollConfig(
      scrollType: SmoothScrollType.linear,
      scrollSpeed: scrollSpeed,
      damping: 1.0 / duration * 16.67, // Convert duration to damping
      linearDuration: duration,
      enableMomentum: enableMomentum,
      momentumFactor: momentumFactor,
    );
  }

  /// Creates an elastic scroll configuration.
  factory SmoothScrollConfig.elastic({
    double scrollSpeed = 1.2,
    double springStiffness = 100.0,
    double springDamping = 10.0,
    bool enableElasticOverscroll = true,
    bool enableMomentum = true,
    double momentumFactor = 0.5,
  }) {
    return SmoothScrollConfig(
      scrollType: SmoothScrollType.elastic,
      scrollSpeed: scrollSpeed,
      damping: 0.1,
      springStiffness: springStiffness,
      springDamping: springDamping,
      enableElasticOverscroll: enableElasticOverscroll,
      enableMomentum: enableMomentum,
      momentumFactor: momentumFactor,
    );
  }

  /// Creates an ease-out scroll configuration.
  factory SmoothScrollConfig.easeOut({
    double scrollSpeed = 1.2,
    double damping = 0.12,
    bool enableMomentum = true,
    double momentumFactor = 0.5,
  }) {
    return SmoothScrollConfig(
      scrollType: SmoothScrollType.easeOut,
      scrollSpeed: scrollSpeed,
      damping: damping,
      enableMomentum: enableMomentum,
      momentumFactor: momentumFactor,
    );
  }

  /// Creates a custom scroll configuration.
  factory SmoothScrollConfig.custom({
    required double scrollSpeed,
    required double damping,
    bool enableMomentum = true,
    double momentumFactor = 0.5,
  }) {
    return SmoothScrollConfig(
      scrollType: SmoothScrollType.custom,
      scrollSpeed: scrollSpeed,
      damping: damping,
      enableMomentum: enableMomentum,
      momentumFactor: momentumFactor,
    );
  }

  /// Creates a native HTML web scroll configuration.
  /// Mimics standard browser scrolling behavior with natural momentum.
  factory SmoothScrollConfig.native({
    double scrollSpeed = 1.0,
    bool enableMomentum = true,
    double momentumFactor = 0.6,
  }) {
    return SmoothScrollConfig(
      scrollType: SmoothScrollType.native,
      scrollSpeed: scrollSpeed,
      damping: 0.15, // Medium damping for natural feel
      enableMomentum: enableMomentum,
      momentumFactor: momentumFactor,
    );
  }

  /// Gets the effective damping value based on scroll type.
  double get effectiveDamping {
    switch (scrollType) {
      case SmoothScrollType.lenis:
        return damping;
      case SmoothScrollType.linear:
        return 1.0 / linearDuration * 16.67; // ~60fps frame time
      case SmoothScrollType.elastic:
        return damping;
      case SmoothScrollType.easeOut:
        return damping;
      case SmoothScrollType.custom:
        return damping;
      case SmoothScrollType.native:
        return damping;
    }
  }
}

