import XCTest
@testable import SoporteLab

@MainActor final class TechnicianListInteractorTests: XCTestCase {
    func test_deleteTechnician_withActiveTickets_throws() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        try SampleData.seedIfNeeded(tickets: tickets, technicians: people)
        let ana = try XCTUnwrap(people.fetchAll().first { $0.name == "Ana López" })
        let interactor = TechnicianListInteractor(tickets: tickets, technicians: people)
        XCTAssertThrowsError(try interactor.delete(id: ana.id)) {
            XCTAssertEqual($0 as? DomainError, .technicianHasActiveTickets(2))
        }
    }
    func test_deleteTechnician_withoutActiveTickets_unassignsTickets() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        try SampleData.seedIfNeeded(tickets: tickets, technicians: people)
        let maria = try XCTUnwrap(people.fetchAll().first { $0.name == "María Rivas" })
        let assigned = try tickets.fetchAll().filter { $0.technicianId == maria.id }
        XCTAssertFalse(assigned.isEmpty)
        try TechnicianListInteractor(tickets: tickets, technicians: people).delete(id: maria.id)
        for ticket in assigned { XCTAssertNil(try tickets.fetch(id: ticket.id)?.technicianId) }
    }
}
