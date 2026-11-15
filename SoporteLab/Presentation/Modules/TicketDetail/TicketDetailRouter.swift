import SwiftUI
@MainActor final class TicketDetailRouter: TicketDetailRouterProtocol {
    private let container: AppContainer
    init(container: AppContainer) { self.container = container }
    func edit(ticketId: UUID, onFinish: @escaping () -> Void) -> AnyView {
        AnyView(NavigationStack { TicketFormBuilder.build(container: container, mode: .edit(ticketId), onFinish: onFinish) })
    }
}
