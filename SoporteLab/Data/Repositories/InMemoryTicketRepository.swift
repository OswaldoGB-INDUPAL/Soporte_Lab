import Foundation

@MainActor
final class InMemoryTicketRepository: TicketRepository {
    private var tickets: [UUID: Ticket] = [:]
    private var history: [UUID: [FollowUp]] = [:]

    func fetchAll() throws -> [Ticket] { Array(tickets.values) }
    func fetch(id: UUID) throws -> Ticket? { tickets[id] }
    func save(_ ticket: Ticket) throws { tickets[ticket.id] = ticket }
    func save(_ ticket: Ticket, with followUp: FollowUp) throws {
        guard followUp.ticketId == ticket.id else { throw DomainError.validation("El seguimiento no corresponde al ticket.") }
        tickets[ticket.id] = ticket
        history[ticket.id, default: []].append(followUp)
    }
    func delete(id: UUID) throws {
        guard tickets.removeValue(forKey: id) != nil else { throw DomainError.notFound }
        history.removeValue(forKey: id)
    }
    func followUps(ticketId: UUID) throws -> [FollowUp] {
        (history[ticketId] ?? []).sorted { $0.createdAt < $1.createdAt }
    }
    func addFollowUp(_ followUp: FollowUp) throws {
        guard tickets[followUp.ticketId] != nil else { throw DomainError.notFound }
        history[followUp.ticketId, default: []].append(followUp)
    }
    func unassign(technicianId: UUID) {
        for (id, var ticket) in tickets where ticket.technicianId == technicianId {
            ticket.technicianId = nil
            tickets[id] = ticket
        }
    }
}
