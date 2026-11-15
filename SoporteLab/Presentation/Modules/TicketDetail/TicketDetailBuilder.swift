import SwiftUI
enum TicketDetailBuilder {
    @MainActor static func build(container: AppContainer, ticketId: UUID, onChange: @escaping () -> Void) -> some View {
        TicketDetailView(presenter: TicketDetailPresenter(ticketId: ticketId,
            interactor: TicketDetailInteractor(tickets: container.ticketRepository, technicians: container.technicianRepository),
            router: TicketDetailRouter(container: container), onChange: onChange))
    }
}
