import MaterialComponents.MDCTypographyScheme

extension MDCTypographyScheme {
    static var defaultScheme: MDCTypographyScheme {
        let scheme = MDCTypographyScheme()
        scheme.body1 = DesignSystem.Font.label
        scheme.body2 = DesignSystem.Font.cellNote
        scheme.button = DesignSystem.Font.buttonTitle
        scheme.caption = DesignSystem.Font.notesCounter
        scheme.subtitle1 = DesignSystem.Font.sectionHeader
        scheme.subtitle2 = DesignSystem.Font.label
        return scheme
    }
}
