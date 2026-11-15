import Foundation
import Observation

@MainActor @Observable
final class TicketFormPresenter {
    var data = TicketFormData()
    var technicians: [Technician] = []
    var errorMessage: String?
    var hasAppeared = false
    let mode: TicketFormMode
    private let interactor: TicketFormInteractorProtocol
    private let router: TicketFormRouterProtocol

    init(mode: TicketFormMode, interactor: TicketFormInteractorProtocol, router: TicketFormRouterProtocol) {
        self.mode = mode
        self.interactor = interactor
        self.router = router
    }
    var title: String { mode == .create ? "Nuevo ticket" : "Editar ticket" }
    var errors: [String: String] { interactor.validate(data) }
    var canSave: Bool { errors.isEmpty }
    func onAppear() {
        guard !hasAppeared else { return }
        hasAppeared = true
        do {
            data = try interactor.load(mode: mode)
            technicians = try interactor.technicians()
        } catch { errorMessage = error.localizedDescription }
    }
    func didCancel() { router.finish() }
    func didSave() {
        do { try interactor.save(data, mode: mode); router.finish() }
        catch { errorMessage = error.localizedDescription }
    }
}
