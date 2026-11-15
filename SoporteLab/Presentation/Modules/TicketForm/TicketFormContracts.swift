import Foundation

enum TicketFormMode: Equatable {
    case create
    case edit(UUID)
}
struct TicketFormData {
    var title = ""
    var location = ""
    var detail = ""
    var category: TicketCategory = .hardware
    var priority: TicketPriority = .medium
    var technicianId: UUID?
}
@MainActor protocol TicketFormInteractorProtocol {
    func load(mode: TicketFormMode) throws -> TicketFormData
    func technicians() throws -> [Technician]
    func validate(_ data: TicketFormData) -> [String: String]
    func save(_ data: TicketFormData, mode: TicketFormMode) throws
}
@MainActor protocol TicketFormRouterProtocol {
    func finish()
}
