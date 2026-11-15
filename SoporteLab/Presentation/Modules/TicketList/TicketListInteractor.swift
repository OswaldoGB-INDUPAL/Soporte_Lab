import Foundation

@MainActor
final class TicketListInteractor: TicketListInteractorProtocol {
    private let tickets: TicketRepository
    private let technicians: TechnicianRepository
    init(tickets: TicketRepository, technicians: TechnicianRepository) {
        self.tickets = tickets
        self.technicians = technicians
    }

    func loadTickets(filter: TicketFilter, search: String) throws -> [TicketListItem] {
        let people = Dictionary(uniqueKeysWithValues: try technicians.fetchAll().map { ($0.id, $0.name) })
        return try tickets.fetchAll().filter { ticket in
            let statusMatches = filter == .all || filter.rawValue == ticket.status.rawValue
            let searchMatches = search.isEmpty || ticket.title.localizedStandardContains(search)
                || ticket.location.localizedStandardContains(search)
            return statusMatches && searchMatches
        }.sorted {
            if $0.priority != $1.priority { return $0.priority > $1.priority }
            return $0.createdAt > $1.createdAt
        }.map {
            TicketListItem(id: $0.id, title: $0.title, location: $0.location, category: $0.category,
                           priority: $0.priority, status: $0.status,
                           technicianName: $0.technicianId.flatMap { people[$0] })
        }
    }
    func deleteTicket(id: UUID) throws { try tickets.delete(id: id) }
}
