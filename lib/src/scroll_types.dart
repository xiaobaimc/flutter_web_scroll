/// Enum defining different types of smooth scrolling behaviors.
///
/// Each type provides a distinct scrolling experience with different
/// physics characteristics. Choose based on your application's needs:
///
/// - [lenis]: Premium smooth scrolling (recommended for most cases)
/// - [linear]: Predictable constant-speed scrolling
/// - [elastic]: Bouncy spring physics for playful UIs
/// - [custom]: Fine-tuned user-defined behavior
/// - [native]: Standard browser scrolling feel
enum SmoothScrollType {
  /// Lenis-style scrolling with exponential decay and natural momentum.
  ///
  /// Provides a premium, smooth scrolling experience similar to Lenis.js.
  /// Features exponential decay interpolation that creates a natural,
  /// fluid scrolling feel. This is the default and recommended option
  /// for most applications.
  lenis,

  /// Linear interpolation scrolling with constant speed.
  ///
  /// Simple and predictable scrolling behavior with constant interpolation
  /// speed. Useful when you need precise, mechanical scrolling without
  /// acceleration or deceleration curves.
  linear,

  /// Elastic scrolling with bounce-back effect at boundaries.
  ///
  /// Provides a spring-like feel when reaching scroll limits. Uses
  /// spring-mass-damper physics simulation for bouncy, playful scrolling.
  /// Great for interactive or game-like interfaces.
  elastic,

  /// Custom scrolling with user-defined damping and speed.
  ///
  /// Allows fine-tuning of scroll behavior with custom damping values.
  /// Use this when you need precise control over scroll physics that
  /// doesn't fit the other predefined types.
  custom,

  /// Native HTML web scrolling behavior.
  ///
  /// Mimics standard browser scrolling with natural momentum and
  /// ease-out deceleration. Provides a familiar scrolling experience
  /// that matches what users expect from web browsers.
  native,
}
