import Foundation

@MainActor
protocol TicketRepository: AnyObject {
    func fetchAll() throws -> [Ticket]
    func fetch(id: UUID) throws -> Ticket?
    func save(_ ticket: Ticket) throws
    func save(_ ticket: Ticket, with followUp: FollowUp) throws
    func delete(id: UUID) throws
    func followUps(ticketId: UUID) throws -> [FollowUp]
    func addFollowUp(_ followUp: FollowUp) throws
}
