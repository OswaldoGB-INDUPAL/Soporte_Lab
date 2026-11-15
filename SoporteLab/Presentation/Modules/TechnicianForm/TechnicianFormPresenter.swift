import Foundation
import Observation
@MainActor @Observable final class TechnicianFormPresenter {
    var data = TechnicianFormData()
    var errorMessage: String?
    private var loaded = false
    private let mode: TechnicianFormMode
    private let interactor: TechnicianFormInteractorProtocol
    private let router: TechnicianFormRouterProtocol
    init(mode: TechnicianFormMode, interactor: TechnicianFormInteractorProtocol, router: TechnicianFormRouterProtocol) {
        self.mode = mode; self.interactor = interactor; self.router = router
    }
    var title: String { mode == .create ? "Nuevo técnico" : "Editar técnico" }
    var errors: [String: String] { interactor.validate(data) }
    var canSave: Bool { errors.isEmpty }
    func onAppear() {
        guard !loaded else { return }
        loaded = true
        do { data = try interactor.load(mode: mode) } catch { errorMessage = error.localizedDescription }
    }
    func didCancel() { router.finish() }
    func didSave() {
        do { try interactor.save(data, mode: mode); router.finish() }
        catch { errorMessage = error.localizedDescription }
    }
}
