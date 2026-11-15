import Foundation
import Observation
@MainActor @Observable final class DashboardPresenter {
    var summary: DashboardSummary?
    var errorMessage: String?
    private let interactor: DashboardInteractorProtocol
    init(interactor: DashboardInteractorProtocol) { self.interactor = interactor }
    func onAppear() {
        do { summary = try interactor.loadSummary() }
        catch { errorMessage = error.localizedDescription }
    }
}
