import Foundation
@MainActor final class TechnicianFormRouter: TechnicianFormRouterProtocol {
    private let onFinish: () -> Void
    init(onFinish: @escaping () -> Void) { self.onFinish = onFinish }
    func finish() { onFinish() }
}
