import Foundation

struct Ticket: Identifiable, Equatable, Hashable {
    let id: UUID
    var title: String
    var detail: String
    var category: TicketCategory
    var priority: TicketPriority
    var status: TicketStatus
    var location: String
    var technicianId: UUID?
    var createdAt: Date
    var updatedAt: Date
    var resolvedAt: Date?
}
