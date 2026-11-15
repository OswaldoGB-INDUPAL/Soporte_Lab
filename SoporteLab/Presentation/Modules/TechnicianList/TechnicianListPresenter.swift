import SwiftUI
import Observation
@MainActor @Observable final class TechnicianListPresenter {
    var items: [TechnicianListItem] = []
    var route: TechnicianListRoute?
    var pendingDeletion: UUID?
    var errorMessage: String?
    private let interactor: TechnicianListInteractorProtocol
    private let router: TechnicianListRouterProtocol
    init(interactor: TechnicianListInteractorProtocol, router: TechnicianListRouterProtocol) {
        self.interactor = interactor; self.router = router
    }
    func onAppear() { reload() }
    func reload() {
        do { items = try interactor.load() } catch { errorMessage = error.localizedDescription }
    }
    func didAdd() { route = .create }
    func didSelect(_ id: UUID) { route = .edit(id) }
    func didDelete(at offsets: IndexSet) { pendingDeletion = offsets.first.map { items[$0].id } }
    func confirmDelete() {
        guard let id = pendingDeletion else { return }
        do { try interactor.delete(id: id); pendingDeletion = nil; reload() }
        catch { pendingDeletion = nil; errorMessage = error.localizedDescription }
    }
    func view(for route: TechnicianListRoute) -> AnyView {
        router.view(for: route, onFinish: { [weak self] in self?.route = nil; self?.reload() })
    }
}
