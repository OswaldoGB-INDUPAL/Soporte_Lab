import Foundation

struct Technician: Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var specialty: String
    var email: String
}
