import SwiftUI
import Observation

@MainActor @Observable
final class TicketListPresenter {
    var items: [TicketListItem] = []
    var filter: TicketFilter = .all { didSet { reload() } }
    var searchText = "" { didSet { reload() } }
    var pushRoute: TicketListRoute?
    var sheetRoute: TicketListRoute?
    var pendingDeletion: UUID?
    var errorMessage: String?
    private let interactor: TicketListInteractorProtocol
    private let router: TicketListRouterProtocol
    init(interactor: TicketListInteractorProtocol, router: TicketListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    func onAppear() { reload() }
    func reload() {
        do { items = try interactor.loadTickets(filter: filter, search: searchText) }
        catch { errorMessage = error.localizedDescription }
    }
    func didSelect(_ id: UUID) { pushRoute = .detail(id) }
    func didTapAdd() { sheetRoute = .create }
    func didDelete(at offsets: IndexSet) { pendingDeletion = offsets.first.map { items[$0].id } }
    func confirmDelete() {
        guard let id = pendingDeletion else { return }
        do { try interactor.deleteTicket(id: id); pendingDeletion = nil; reload() }
        catch { pendingDeletion = nil; errorMessage = error.localizedDescription }
    }
    func view(for route: TicketListRoute) -> AnyView {
        switch route {
        case .detail(let id): return router.makeDetailView(ticketId: id, onChange: { [weak self] in self?.reload() })
        case .create: return router.makeCreateView(onFinish: { [weak self] in self?.sheetRoute = nil; self?.reload() })
        }
    }
}
