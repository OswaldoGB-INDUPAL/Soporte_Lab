import SwiftUI

enum TicketFilter: String, CaseIterable, Identifiable {
    case all, open, inProgress, resolved
    var id: String { rawValue }
    var title: String {
        switch self {
        case .all: return "Todos"
        case .open: return "Abiertos"
        case .inProgress: return "En proceso"
        case .resolved: return "Resueltos"
        }
    }
}

enum TicketListRoute: Identifiable, Hashable {
    case detail(UUID), create
    var id: String {
        switch self { case .detail(let id): return "detail-\(id)"; case .create: return "create" }
    }
}

struct TicketListItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let location: String
    let category: TicketCategory
    let priority: TicketPriority
    let status: TicketStatus
    let technicianName: String?
}

@MainActor protocol TicketListInteractorProtocol {
    func loadTickets(filter: TicketFilter, search: String) throws -> [TicketListItem]
    func deleteTicket(id: UUID) throws
}
@MainActor protocol TicketListRouterProtocol {
    func makeDetailView(ticketId: UUID, onChange: @escaping () -> Void) -> AnyView
    func makeCreateView(onFinish: @escaping () -> Void) -> AnyView
}
