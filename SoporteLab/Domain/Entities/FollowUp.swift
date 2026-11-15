import Foundation

struct FollowUp: Identifiable, Equatable, Hashable {
    let id: UUID
    let ticketId: UUID
    var text: String
    let createdAt: Date
}
