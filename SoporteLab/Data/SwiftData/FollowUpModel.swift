import Foundation
import SwiftData

@Model
final class FollowUpModel {
    var id: UUID
    var text: String
    var createdAt: Date
    var ticket: TicketModel?

    init(id: UUID, text: String, createdAt: Date, ticket: TicketModel?) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.ticket = ticket
    }
}
