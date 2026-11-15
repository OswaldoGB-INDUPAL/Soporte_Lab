import XCTest
@testable import SoporteLab

@MainActor final class TicketDetailInteractorTests: XCTestCase {
    private let date = Date(timeIntervalSince1970: 1_700_000_000)
    private func setup() throws -> (InMemoryTicketRepository, InMemoryTechnicianRepository, TicketDetailInteractor) {
        let tickets = InMemoryTicketRepository()
        let technicians = InMemoryTechnicianRepository(tickets: tickets)
        try SampleData.seedIfNeeded(tickets: tickets, technicians: technicians, now: date)
        return (tickets, technicians, TicketDetailInteractor(tickets: tickets, technicians: technicians, now: { self.date }))
    }
    func test_changeStatusToInProgress_withoutTechnician_throwsTechnicianRequired() throws {
        let (tickets, _, interactor) = try setup()
        let ticket = try XCTUnwrap(tickets.fetchAll().first { $0.title == "Proyector no enciende" })
        XCTAssertThrowsError(try interactor.changeStatus(id: ticket.id, to: .inProgress)) {
            XCTAssertEqual($0 as? DomainError, .technicianRequired)
        }
    }
    func test_changeStatusToResolved_setsResolvedAt_andAddsFollowUp() throws {
        let (tickets, _, interactor) = try setup()
        let ticket = try XCTUnwrap(tickets.fetchAll().first { $0.status == .inProgress })
        try interactor.changeStatus(id: ticket.id, to: .resolved)
        XCTAssertEqual(try tickets.fetch(id: ticket.id)?.resolvedAt, date)
        XCTAssertTrue(try tickets.followUps(ticketId: ticket.id).contains { $0.text == "Estado cambiado a Resuelto" })
    }
    func test_reopen_clearsResolvedAt() throws {
        let (tickets, _, interactor) = try setup()
        let ticket = try XCTUnwrap(tickets.fetchAll().first { $0.status == .resolved })
        try interactor.changeStatus(id: ticket.id, to: .open)
        XCTAssertNil(try tickets.fetch(id: ticket.id)?.resolvedAt)
    }
    func test_unassignTechnician_whileInProgress_throws() throws {
        let (tickets, _, interactor) = try setup()
        let ticket = try XCTUnwrap(tickets.fetchAll().first { $0.status == .inProgress })
        XCTAssertThrowsError(try interactor.assign(ticketId: ticket.id, technicianId: nil)) {
            XCTAssertEqual($0 as? DomainError, .validation("Un ticket en proceso necesita técnico."))
        }
    }
}
