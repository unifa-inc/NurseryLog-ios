import RxBlocking
import RxTest
import XCTest
@testable import NurseryLog

final class ActivityDetailViewModelTests: XCTestCase {

    // MARK: - Utility Methods

    private func makeSUT(
        date: String = "2024-06-10",
        time: String = "09:00",
        category: Activity.Category = .indoor,
        title: String = "Test Activity",
        notes: String? = nil
    ) -> ActivityDetailViewModel {
        ActivityDetailViewModel(activity: Activity.stub(
            date: date,
            time: time,
            category: category,
            title: title,
            notes: notes
        ))
    }

    // MARK: - Tests - title

    func test_title_matchesActivity() throws {
        let sut = makeSUT(title: "昼食")
        let output = try sut.transform(.init())

        let result = try output.title.toBlocking().first()

        XCTAssertEqual(result, "昼食")
    }

    // MARK: - Tests - category

    func test_category_matchesActivity() throws {
        let sut = makeSUT(category: .meal)
        let output = try sut.transform(.init())

        let result = try output.category.toBlocking().first()

        XCTAssertEqual(result, .meal)
    }

    // MARK: - Tests - notes

    func test_notes_isNil_whenNotProvided() throws {
        let sut = makeSUT(notes: nil)
        let output = try sut.transform(.init())

        let result = try output.notes.toBlocking().first()

        XCTAssertNil(result as? String)
    }

    func test_notes_matchesActivity_whenProvided() throws {
        let sut = makeSUT(notes: "メモ内容")
        let output = try sut.transform(.init())

        let result = try output.notes.toBlocking().first()

        XCTAssertEqual(result as? String, "メモ内容")
    }

    // MARK: - Tests - dateTime

    func test_dateTime_formattedCorrectly_forValidInput() throws {
        let sut = makeSUT(date: "2024-06-10", time: "09:30")
        let output = try sut.transform(.init())

        let result = try output.dateTime.toBlocking().first()

        XCTAssertNotNil(result)
        XCTAssertTrue(result?.contains("2024") == true)
        XCTAssertTrue(result?.contains("09:30") == true)
    }

    func test_dateTime_fallbackToRaw_forInvalidInput() throws {
        let sut = makeSUT(date: "invalid-date", time: "bad-time")
        let output = try sut.transform(.init())

        let result = try output.dateTime.toBlocking().first()

        XCTAssertEqual(result, "invalid-date bad-time")
    }

    // MARK: - Tests - output completeness

    func test_allOutputs_emitExactlyOneEvent() throws {
        let sut = makeSUT(category: .outdoor, title: "朝食", notes: "公園")
        let output = try sut.transform(.init())

        let titles = try output.title.toBlocking().toArray()
        let categories = try output.category.toBlocking().toArray()
        let notesList = try output.notes.toBlocking().toArray()
        let dateTimes = try output.dateTime.toBlocking().toArray()

        XCTAssertEqual(titles.count, 1)
        XCTAssertEqual(categories.count, 1)
        XCTAssertEqual(notesList.count, 1)
        XCTAssertEqual(dateTimes.count, 1)
    }
}

/*
 ActivityDetailViewModel Output Test Coverage

 [✓] title: Driver<String>
      [✓] matches activity title
 [✓] category: Driver<Activity.Category>
      [✓] matches activity category
 [✓] notes: Driver<String?>
      [✓] nil when activity has no notes
      [✓] matches activity notes when present
 [✓] dateTime: Driver<String>
      [✓] formatted as Japanese date string for valid date/time
      [✓] falls back to raw "date time" string for unparseable input
 [✓] all outputs emit exactly one event (Driver.just semantics)
 */
