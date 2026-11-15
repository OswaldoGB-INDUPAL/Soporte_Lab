import XCTest
@testable import SoporteLab

@MainActor final class TicketFormInteractorTests: XCTestCase {
    func test_validate_shortTitle_returnsError() {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        let interactor = TicketFormInteractor(tickets: tickets, technicians: people)
        let result = interactor.validate(TicketFormData(title: "a", location: "Lab"))
        XCTAssertEqual(result["title"], "El título debe tener entre 3 y 80 caracteres.")
    }
    func test_save_newTicket_isOpen_withCreatedFollowUp() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let person = Technician(id: UUID(), name: "Ana", specialty: "Redes", email: "ana@empresa.com")
        try people.save(person)
        let interactor = TicketFormInteractor(tickets: tickets, technicians: people, now: { date })
        try interactor.save(TicketFormData(title: "Falla de red", location: "Lab", technicianId: person.id), mode: .create)
        let ticket = try XCTUnwrap(tickets.fetchAll().first)
        XCTAssertEqual(ticket.status, .open)
        XCTAssertEqual(ticket.technicianId, person.id)
        XCTAssertEqual(ticket.createdAt, date)
        XCTAssertEqual(try tickets.followUps(ticketId: ticket.id).map(\.text), ["Ticket creado"])
    }
    func test_edit_assigningTechnician_addsFollowUp() throws {
        let tickets = InMemoryTicketRepository()
        let people = InMemoryTechnicianRepository(tickets: tickets)
        let person = Technician(id: UUID(), name: "Ana", specialty: "Redes", email: "ana@empresa.com")
        try people.save(person)
        let interactor = TicketFormInteractor(tickets: tickets, technicians: people)
        try interactor.save(TicketFormData(title: "Falla de red", location: "Lab"), mode: .create)
        let ticket = try XCTUnwrap(tickets.fetchAll().first)
        try interactor.save(TicketFormData(title: ticket.title, location: ticket.location,
                                          technicianId: person.id), mode: .edit(ticket.id))
        XCTAssertTrue(try tickets.followUps(ticketId: ticket.id).contains { $0.text == "Asignado a Ana" })
    }

}
