import Foundation
@MainActor final class TechnicianListInteractor: TechnicianListInteractorProtocol {
    private let tickets: TicketRepository
    private let people: TechnicianRepository
    init(tickets: TicketRepository, technicians: TechnicianRepository) {
        self.tickets = tickets; self.people = technicians
    }
    func load() throws -> [TechnicianListItem] {
        let tickets = try tickets.fetchAll()
        return try people.fetchAll().map { person in
            TechnicianListItem(technician: person,
                activeCount: tickets.filter { $0.technicianId == person.id && $0.status == .inProgress }.count)
        }
    }
    func delete(id: UUID) throws {
        let active = try tickets.fetchAll().filter { $0.technicianId == id && $0.status == .inProgress }.count
        guard active == 0 else { throw DomainError.technicianHasActiveTickets(active) }
        try people.delete(id: id)
    }
}
