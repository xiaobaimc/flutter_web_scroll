/// Enum defining different types of smooth scrolling behaviors.
enum SmoothScrollType {
  /// Lenis-style scrolling with exponential decay and natural momentum.
  /// Provides a premium, smooth scrolling experience similar to Lenis.js.
  lenis,

  /// Linear interpolation scrolling with constant speed.
  /// Simple and predictable scrolling behavior.
  linear,

  /// Elastic scrolling with bounce-back effect at boundaries.
  /// Provides a spring-like feel when reaching scroll limits.
  elastic,

  /// Ease-out scrolling with deceleration curve.
  /// Starts fast and gradually slows down.
  easeOut,

  /// Ease-in-out scrolling with acceleration and deceleration.
  /// Smooth acceleration and deceleration for natural feel.
  easeInOut,

  /// Custom scrolling with user-defined damping and speed.
  /// Allows fine-tuning of scroll behavior.
  custom,

  /// Native HTML web scrolling behavior.
  /// Mimics standard browser scrolling with natural momentum and deceleration.
  native,
}

