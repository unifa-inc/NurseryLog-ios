import MaterialComponents.MaterialBanner_Theming

extension MDCContainerScheme {
    static var defaultScheme: MDCContainerScheme {
        let scheme = MDCContainerScheme()
        scheme.colorScheme = MDCSemanticColorScheme.defaultScheme
        scheme.typographyScheme = MDCTypographyScheme.defaultScheme
        return scheme
    }
}
