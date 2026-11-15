import Foundation
import SwiftData

@Model
final class TicketModel {
    var id: UUID
    var title: String
    var detail: String
    var categoryRaw: String
    var priorityRaw: String
    var statusRaw: String
    var location: String
    var createdAt: Date
    var updatedAt: Date
    var resolvedAt: Date?
    var technician: TechnicianModel?
    @Relationship(deleteRule: .cascade, inverse: \FollowUpModel.ticket)
    var followUps: [FollowUpModel] = []

    init(id: UUID, title: String, detail: String, categoryRaw: String,
         priorityRaw: String, statusRaw: String, location: String,
         createdAt: Date, updatedAt: Date, resolvedAt: Date?,
         technician: TechnicianModel?) {
        self.id = id
        self.title = title
        self.detail = detail
        self.categoryRaw = categoryRaw
        self.priorityRaw = priorityRaw
        self.statusRaw = statusRaw
        self.location = location
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.resolvedAt = resolvedAt
        self.technician = technician
    }
}
