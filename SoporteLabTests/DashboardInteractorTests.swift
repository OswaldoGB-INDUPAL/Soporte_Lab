import XCTest
@testable import SoporteLab

@MainActor final class DashboardInteractorTests: XCTestCase {
    func test_summary_matchesSeedData() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        try SampleData.seedIfNeeded(tickets: tickets, technicians: people,
                                    now: Date(timeIntervalSince1970: 1_700_000_000))
        let result = try DashboardInteractor(tickets: tickets).loadSummary()
        XCTAssertEqual(result.total, 10)
        XCTAssertEqual(result.open, 4)
        XCTAssertEqual(result.inProgress, 3)
        XCTAssertEqual(result.resolved, 3)
        XCTAssertEqual(result.highPriority, 3)
        XCTAssertEqual(result.categories[.hardware], 4)
        XCTAssertEqual(result.categories[.software], 3)
        XCTAssertEqual(result.categories[.network], 2)
        XCTAssertEqual(result.categories[.other], 1)
    }
}
