import SwiftUI
enum TicketFormBuilder {
    @MainActor static func build(container: AppContainer, mode: TicketFormMode, onFinish: @escaping () -> Void) -> some View {
        TicketFormView(presenter: TicketFormPresenter(
            mode: mode,
            interactor: TicketFormInteractor(tickets: container.ticketRepository, technicians: container.technicianRepository),
            router: TicketFormRouter(onFinish: onFinish)))
    }
}
