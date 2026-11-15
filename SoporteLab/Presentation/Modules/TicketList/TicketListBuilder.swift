import SwiftUI

enum TicketListBuilder {
    @MainActor static func build(container: AppContainer) -> some View {
        TicketListView(presenter: TicketListPresenter(
            interactor: TicketListInteractor(tickets: container.ticketRepository, technicians: container.technicianRepository),
            router: TicketListRouter(container: container)))
    }
}
