import SwiftUI
import Observation

@MainActor @Observable
final class TicketDetailPresenter {
    var data: TicketDetailData?
    var route: TicketDetailRoute?
    var message = ""
    var errorMessage: String?
    private let ticketId: UUID
    private let interactor: TicketDetailInteractorProtocol
    private let router: TicketDetailRouterProtocol
    private let onChange: () -> Void
    init(ticketId: UUID, interactor: TicketDetailInteractorProtocol,
         router: TicketDetailRouterProtocol, onChange: @escaping () -> Void) {
        self.ticketId = ticketId; self.interactor = interactor; self.router = router; self.onChange = onChange
    }
    func onAppear() { reload() }
    func reload() {
        do { data = try interactor.load(id: ticketId) }
        catch { data = nil; errorMessage = error.localizedDescription }
    }
    var actionTitle: String {
        switch data?.ticket.status {
        case .open: return "Iniciar atención"
        case .inProgress: return "Marcar como resuelto"
        case .resolved: return "Reabrir"
        case nil: return ""
        }
    }
    func didChangeStatus() {
        guard let status = data?.ticket.status else { return }
        let next: TicketStatus
        switch status { case .open: next = .inProgress; case .inProgress: next = .resolved; case .resolved: next = .open }
        do { try interactor.changeStatus(id: ticketId, to: next); reload(); onChange() }
        catch { errorMessage = error.localizedDescription }
    }
    func didAssign(_ id: UUID?) {
        do { try interactor.assign(ticketId: ticketId, technicianId: id); reload(); onChange() }
        catch { errorMessage = error.localizedDescription }
    }
    func didAddFollowUp() {
        do { try interactor.addFollowUp(ticketId: ticketId, text: message); message = ""; reload(); onChange() }
        catch { errorMessage = error.localizedDescription }
    }
    func didEdit() { route = .edit(ticketId) }
    func view(for route: TicketDetailRoute) -> AnyView {
        router.edit(ticketId: route.id, onFinish: { [weak self] in
            self?.route = nil; self?.reload(); self?.onChange()
        })
    }
}
