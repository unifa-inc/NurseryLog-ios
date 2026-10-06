import MaterialComponents.MaterialColorScheme

extension MDCSemanticColorScheme {
    static var defaultScheme: MDCSemanticColorScheme {
        let scheme = MDCSemanticColorScheme()
        scheme.primaryColor = DesignSystem.Color.primary
        scheme.primaryColorVariant = DesignSystem.Color.primary.withAlphaComponent(0.7)
        scheme.secondaryColor = DesignSystem.Color.primary
        scheme.backgroundColor = DesignSystem.Color.background
        scheme.surfaceColor = DesignSystem.Color.surface
        scheme.errorColor = .systemRed
        scheme.onPrimaryColor = DesignSystem.Color.primaryText
        scheme.onSecondaryColor = DesignSystem.Color.primaryText
        scheme.onBackgroundColor = DesignSystem.Color.textPrimary
        scheme.onSurfaceColor = DesignSystem.Color.textPrimary
        return scheme
    }
}
