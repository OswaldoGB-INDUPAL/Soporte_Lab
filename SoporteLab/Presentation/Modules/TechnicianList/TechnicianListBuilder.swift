import SwiftUI
enum TechnicianListBuilder {
    @MainActor static func build(container: AppContainer) -> some View {
        TechnicianListView(presenter: TechnicianListPresenter(
            interactor: TechnicianListInteractor(tickets: container.ticketRepository, technicians: container.technicianRepository),
            router: TechnicianListRouter(container: container)))
    }
}
