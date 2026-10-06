import RealmSwift

class RMActivity: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var date: String = ""
    @Persisted var time: String = ""
    @Persisted var category: String = ""
    @Persisted var title: String = ""
    @Persisted var notes: String? = nil
    @Persisted var createdAt: String = ""

    static func getAll(for date: String) -> [RMActivity] {
        guard let realm = try? Realm() else { return [] }
        return Array(realm.objects(RMActivity.self)
            .filter("%K = %@", "date", date))
    }

    static func insert(_ activity: Activity) throws {
        let realm = try Realm()
        let object = RMActivity()
        object.id = activity.id
        object.date = activity.date
        object.time = activity.time
        object.category = activity.category.rawValue
        object.title = activity.title
        object.notes = activity.notes
        object.createdAt = activity.createdAt
        try realm.write {
            realm.add(object, update: .modified)
        }
    }

    func toDomain() -> Activity? {
        guard let category = Activity.Category(rawValue: category) else { return nil }
        return Activity(
            id: id,
            date: date,
            time: time,
            category: category,
            title: title,
            notes: notes,
            createdAt: createdAt
        )
    }
}
