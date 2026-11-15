import SwiftUI
struct TechnicianListItem: Identifiable {
    let technician: Technician
    let activeCount: Int
    var id: UUID { technician.id }
}
enum TechnicianListRoute: Identifiable {
    case create, edit(UUID)
    var id: String {
        switch self { case .create: return "create"; case .edit(let id): return id.uuidString }
    }
}
@MainActor protocol TechnicianListInteractorProtocol {
    func load() throws -> [TechnicianListItem]
    func delete(id: UUID) throws
}
@MainActor protocol TechnicianListRouterProtocol {
    func view(for route: TechnicianListRoute, onFinish: @escaping () -> Void) -> AnyView
}
