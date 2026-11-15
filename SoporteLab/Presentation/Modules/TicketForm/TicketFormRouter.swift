import Foundation
@MainActor final class TicketFormRouter: TicketFormRouterProtocol {
    private let onFinish: () -> Void
    init(onFinish: @escaping () -> Void) { self.onFinish = onFinish }
    func finish() { onFinish() }
}
