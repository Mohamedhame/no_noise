int opacityToAlpha(double opacity) {
  return (opacity.clamp(0.0, 1.0) * 255).round();
}
