import SwiftUI
enum DashboardBuilder {
    @MainActor static func build(container: AppContainer) -> some View {
        DashboardView(presenter: DashboardPresenter(interactor: DashboardInteractor(tickets: container.ticketRepository)))
    }
}
