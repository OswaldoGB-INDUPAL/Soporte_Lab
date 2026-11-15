import Foundation
import SwiftData

@Model
final class TechnicianModel {
    var id: UUID
    var name: String
    var specialty: String
    var email: String
    @Relationship(deleteRule: .nullify, inverse: \TicketModel.technician)
    var tickets: [TicketModel] = []

    init(id: UUID, name: String, specialty: String, email: String) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.email = email
    }
}
