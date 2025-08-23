/// Defines the animation style for the blinking border.
enum BlinkStyle {
  /// Standard blinking animation - fades in and out
  normal,

  /// Sweeps around the border from corner to corner
  cornerSweep,

  /// Rainbow color animation cycling through spectrum
  rainbow,

  /// Pulsing animation with scale effect
  pulsing,

  /// Glowing effect with soft light emanation
  glowing,
}

/// Defines the stroke style of the border.
enum StrokeStyle {
  /// Solid continuous line
  solid,

  /// Dotted line pattern
  dotted,

  /// Dashed line pattern
  dashed,
}
