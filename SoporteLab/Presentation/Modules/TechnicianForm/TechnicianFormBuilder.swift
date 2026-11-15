import SwiftUI
enum TechnicianFormBuilder {
    @MainActor static func build(container: AppContainer, mode: TechnicianFormMode, onFinish: @escaping () -> Void) -> some View {
        TechnicianFormView(presenter: TechnicianFormPresenter(mode: mode,
            interactor: TechnicianFormInteractor(technicians: container.technicianRepository),
            router: TechnicianFormRouter(onFinish: onFinish)))
    }
}
