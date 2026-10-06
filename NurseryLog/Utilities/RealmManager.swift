import RealmSwift

enum RealmManager {
    private static let version: UInt64 = 1

    static func configure() {
        let configuration = Realm.Configuration(
            schemaVersion: version,
            migrationBlock: { _, _ in }
        )
        Realm.Configuration.defaultConfiguration = configuration
    }
}
