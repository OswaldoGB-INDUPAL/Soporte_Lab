import SwiftUI

struct TicketDetailData {
    let ticket: Ticket
    let technicianName: String?
    let technicians: [Technician]
    let followUps: [FollowUp]
}
enum TicketDetailRoute: Identifiable {
    case edit(UUID)
    var id: UUID { switch self { case .edit(let id): return id } }
}
@MainActor protocol TicketDetailInteractorProtocol {
    func load(id: UUID) throws -> TicketDetailData
    func changeStatus(id: UUID, to status: TicketStatus) throws
    func assign(ticketId: UUID, technicianId: UUID?) throws
    func addFollowUp(ticketId: UUID, text: String) throws
}
@MainActor protocol TicketDetailRouterProtocol {
    func edit(ticketId: UUID, onFinish: @escaping () -> Void) -> AnyView
}
