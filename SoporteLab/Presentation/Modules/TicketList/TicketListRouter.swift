import SwiftUI

@MainActor
final class TicketListRouter: TicketListRouterProtocol {
    private let container: AppContainer
    init(container: AppContainer) { self.container = container }
    func makeDetailView(ticketId: UUID, onChange: @escaping () -> Void) -> AnyView {
        AnyView(TicketDetailBuilder.build(container: container, ticketId: ticketId, onChange: onChange))
    }
    func makeCreateView(onFinish: @escaping () -> Void) -> AnyView {
        AnyView(NavigationStack { TicketFormBuilder.build(container: container, mode: .create, onFinish: onFinish) })
    }
}
