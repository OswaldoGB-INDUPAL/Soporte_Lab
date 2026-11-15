import XCTest
@testable import SoporteLab

@MainActor final class AdditionalInteractorTests: XCTestCase {
    func test_ticketList_sortsPriorityThenDateDescending() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        let earlier = Date(timeIntervalSince1970: 100)
        let later = Date(timeIntervalSince1970: 200)
        func ticket(_ title: String, _ priority: TicketPriority, _ date: Date) -> Ticket {
            Ticket(id: UUID(), title: title, detail: "", category: .hardware, priority: priority,
                   status: .open, location: "Lab", technicianId: nil,
                   createdAt: date, updatedAt: date, resolvedAt: nil)
        }
        try tickets.save(ticket("Baja reciente", .low, later))
        try tickets.save(ticket("Alta antigua", .high, earlier))
        try tickets.save(ticket("Alta reciente", .high, later))
        let interactor = TicketListInteractor(tickets: tickets, technicians: people)
        XCTAssertEqual(try interactor.loadTickets(filter: .all, search: "").map(\.title),
                       ["Alta reciente", "Alta antigua", "Baja reciente"])
    }

    func test_ticketList_searchIgnoresAccentsAndCase() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        try SampleData.seedIfNeeded(tickets: tickets, technicians: people)
        let interactor = TicketListInteractor(tickets: tickets, technicians: people)
        XCTAssertEqual(try interactor.loadTickets(filter: .all, search: "PROYECCIÓN").count, 0)
        XCTAssertEqual(try interactor.loadTickets(filter: .all, search: "ADMINISTRACION").map(\.title),
                       ["Licencia de Office vencida"])
    }

    func test_technicianForm_validatesAndTrimsEmail() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        let interactor = TechnicianFormInteractor(technicians: people)
        let invalid = TechnicianFormData(name: "Ana", specialty: "Redes", email: "sin-arroba")
        XCTAssertEqual(interactor.validate(invalid)["email"], "Formato de correo no válido")
        let valid = TechnicianFormData(name: " Ana ", specialty: " Redes ", email: " ANA@EMPRESA.COM ")
        XCTAssertTrue(interactor.validate(valid).isEmpty)
        try interactor.save(valid, mode: .create)
        let saved = try XCTUnwrap(people.fetchAll().first)
        XCTAssertEqual(saved.name, "Ana")
        XCTAssertEqual(saved.email, "ANA@EMPRESA.COM")
    }
}
