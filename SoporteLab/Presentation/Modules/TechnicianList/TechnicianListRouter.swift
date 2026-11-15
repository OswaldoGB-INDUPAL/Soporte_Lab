import SwiftUI
@MainActor final class TechnicianListRouter: TechnicianListRouterProtocol {
    private let container: AppContainer
    init(container: AppContainer) { self.container = container }
    func view(for route: TechnicianListRoute, onFinish: @escaping () -> Void) -> AnyView {
        let mode: TechnicianFormMode
        switch route { case .create: mode = .create; case .edit(let id): mode = .edit(id) }
        return AnyView(NavigationStack { TechnicianFormBuilder.build(container: container, mode: mode, onFinish: onFinish) })
    }
}
