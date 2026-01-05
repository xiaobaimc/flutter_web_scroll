import 'scroll_types.dart';

/// Configuration class for smooth scrolling behavior.
///
/// Provides comprehensive control over scroll physics, including scroll type,
/// speed, damping, momentum, and elastic effects. Use factory constructors
/// for convenient preset configurations.
///
/// Example:
/// ```dart
/// // Lenis-style scrolling (default)
/// SmoothScrollConfig.lenis(
///   scrollSpeed: 1.2,
///   damping: 0.08,
/// )
///
/// // Custom configuration
/// SmoothScrollConfig.custom(
///   scrollSpeed: 1.5,
///   damping: 0.06,
/// )
/// ```
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

  /// For native scroll type: make single scroll actions stop more definitively.
  /// When true, single scrolls will have a "hard" end (snap to position).
  /// When false, single scrolls will have a "soft" end (smooth deceleration).
  /// Default: true
  final bool singleScrollHardEnd;

  /// For native scroll type: time threshold (ms) to detect single scroll vs continuous.
  /// If time between scrolls exceeds this, it's considered a single scroll.
  /// Default: 150
  final int singleScrollThreshold;

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
    this.singleScrollHardEnd = true,
    this.singleScrollThreshold = 150,
  })  : assert(scrollSpeed > 0, 'scrollSpeed must be positive'),
        assert(
            damping > 0 && damping <= 1.0, 'damping must be between 0 and 1'),
        assert(linearDuration > 0, 'linearDuration must be positive'),
        assert(springStiffness > 0, 'springStiffness must be positive'),
        assert(springDamping > 0, 'springDamping must be positive'),
        assert(momentumFactor >= 0, 'momentumFactor must be non-negative'),
        assert(stopThreshold > 0, 'stopThreshold must be positive'),
        assert(
          singleScrollThreshold > 0,
          'singleScrollThreshold must be positive',
        );

  /// Creates a Lenis-style scroll configuration.
  ///
  /// Provides premium smooth scrolling with exponential decay interpolation.
  /// This is the recommended default for most applications.
  ///
  /// [scrollSpeed] controls how far each scroll event moves (default: 1.2).
  /// [damping] controls smoothness - lower values are smoother/heavier (default: 0.08).
  /// [enableMomentum] enables throw scrolling after drag ends (default: true).
  /// [momentumFactor] controls how far momentum carries the scroll (default: 0.5).
  ///
  /// Throws [AssertionError] if parameters are invalid.
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
  ///
  /// Provides constant-speed interpolation without acceleration curves.
  /// Useful for precise, mechanical scrolling behavior.
  ///
  /// [scrollSpeed] controls how far each scroll event moves (default: 1.2).
  /// [duration] is the animation duration in milliseconds (default: 300).
  /// [enableMomentum] enables throw scrolling after drag ends (default: true).
  /// [momentumFactor] controls how far momentum carries the scroll (default: 0.5).
  ///
  /// Throws [AssertionError] if parameters are invalid.
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
  ///
  /// Provides spring physics with bounce-back effects at scroll boundaries.
  /// Great for playful, interactive interfaces.
  ///
  /// [scrollSpeed] controls how far each scroll event moves (default: 1.2).
  /// [springStiffness] controls spring stiffness - higher = stiffer (default: 100.0).
  /// [springDamping] controls spring damping - higher = less bouncy (default: 10.0).
  /// [enableElasticOverscroll] enables bounce at boundaries (default: true).
  /// [enableMomentum] enables throw scrolling after drag ends (default: true).
  /// [momentumFactor] controls how far momentum carries the scroll (default: 0.5).
  ///
  /// Throws [AssertionError] if parameters are invalid.
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

  /// Creates a custom scroll configuration.
  ///
  /// Allows fine-tuning of scroll behavior with custom damping values.
  /// Use this when you need precise control over scroll physics.
  ///
  /// [scrollSpeed] controls how far each scroll event moves (required).
  /// [damping] controls smoothness - lower values are smoother/heavier (required).
  /// [enableMomentum] enables throw scrolling after drag ends (default: true).
  /// [momentumFactor] controls how far momentum carries the scroll (default: 0.5).
  ///
  /// Throws [AssertionError] if parameters are invalid.
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
  ///
  /// Mimics standard browser scrolling behavior with natural momentum
  /// and ease-out deceleration. Provides a familiar scrolling experience.
  ///
  /// [scrollSpeed] controls how far each scroll event moves (default: 1.0).
  /// [enableMomentum] enables throw scrolling after drag ends (default: true).
  /// [momentumFactor] controls how far momentum carries the scroll (default: 0.6).
  /// [singleScrollHardEnd] makes single scrolls stop definitively (default: true).
  /// [singleScrollThreshold] is the time threshold in ms to detect single scrolls (default: 150).
  ///
  /// Throws [AssertionError] if parameters are invalid.
  factory SmoothScrollConfig.native({
    double scrollSpeed = 1.0,
    bool enableMomentum = true,
    double momentumFactor = 0.6,
    bool singleScrollHardEnd = true,
    int singleScrollThreshold = 150,
  }) {
    return SmoothScrollConfig(
      scrollType: SmoothScrollType.native,
      scrollSpeed: scrollSpeed,
      damping: 0.15, // Medium damping for natural feel
      enableMomentum: enableMomentum,
      momentumFactor: momentumFactor,
      singleScrollHardEnd: singleScrollHardEnd,
      singleScrollThreshold: singleScrollThreshold,
    );
  }

  /// Gets the effective damping value based on scroll type.
  ///
  /// For linear scrolling, converts duration to damping based on frame time.
  /// For other types, returns the configured damping value directly.
  ///
  /// Returns the damping factor to use for interpolation calculations.
  double get effectiveDamping {
    switch (scrollType) {
      case SmoothScrollType.lenis:
        return damping;
      case SmoothScrollType.linear:
        // Convert duration (ms) to damping per frame (~60fps = 16.67ms)
        return 1.0 / linearDuration * 16.67;
      case SmoothScrollType.elastic:
        return damping;
      case SmoothScrollType.custom:
        return damping;
      case SmoothScrollType.native:
        return damping;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SmoothScrollConfig &&
        other.scrollType == scrollType &&
        other.scrollSpeed == scrollSpeed &&
        other.damping == damping &&
        other.linearDuration == linearDuration &&
        other.springStiffness == springStiffness &&
        other.springDamping == springDamping &&
        other.enableMomentum == enableMomentum &&
        other.momentumFactor == momentumFactor &&
        other.enableElasticOverscroll == enableElasticOverscroll &&
        other.stopThreshold == stopThreshold &&
        other.singleScrollHardEnd == singleScrollHardEnd &&
        other.singleScrollThreshold == singleScrollThreshold;
  }

  @override
  int get hashCode {
    return Object.hash(
      scrollType,
      scrollSpeed,
      damping,
      linearDuration,
      springStiffness,
      springDamping,
      enableMomentum,
      momentumFactor,
      enableElasticOverscroll,
      stopThreshold,
      singleScrollHardEnd,
      singleScrollThreshold,
    );
  }

  @override
  String toString() {
    return 'SmoothScrollConfig('
        'scrollType: $scrollType, '
        'scrollSpeed: $scrollSpeed, '
        'damping: $damping, '
        'linearDuration: $linearDuration, '
        'springStiffness: $springStiffness, '
        'springDamping: $springDamping, '
        'enableMomentum: $enableMomentum, '
        'momentumFactor: $momentumFactor, '
        'enableElasticOverscroll: $enableElasticOverscroll, '
        'stopThreshold: $stopThreshold, '
        'singleScrollHardEnd: $singleScrollHardEnd, '
        'singleScrollThreshold: $singleScrollThreshold'
        ')';
  }
}
