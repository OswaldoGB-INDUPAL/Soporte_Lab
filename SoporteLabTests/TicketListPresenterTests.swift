import XCTest
import SwiftUI
@testable import SoporteLab

@MainActor final class TicketListPresenterTests: XCTestCase {
    func test_onAppear_loadsItems() {
        let interactor = MockTicketListInteractor()
        let presenter = TicketListPresenter(interactor: interactor, router: MockTicketListRouter())
        presenter.onAppear()
        XCTAssertEqual(interactor.calls, 1)
        XCTAssertEqual(presenter.items.count, 1)
    }
    func test_changeFilter_reloadsWithFilter() {
        let interactor = MockTicketListInteractor()
        let presenter = TicketListPresenter(interactor: interactor, router: MockTicketListRouter())
        presenter.filter = .resolved
        XCTAssertEqual(interactor.lastFilter, .resolved)
    }
    func test_didTapAdd_setsCreateSheetRoute() {
        let presenter = TicketListPresenter(interactor: MockTicketListInteractor(), router: MockTicketListRouter())
        presenter.didTapAdd()
        XCTAssertEqual(presenter.sheetRoute, .create)
    }
    func test_interactorError_setsErrorMessage() {
        let interactor = MockTicketListInteractor()
        interactor.shouldFail = true
        let presenter = TicketListPresenter(interactor: interactor, router: MockTicketListRouter())
        presenter.onAppear()
        XCTAssertNotNil(presenter.errorMessage)
    }
}
@MainActor private final class MockTicketListInteractor: TicketListInteractorProtocol {
    var calls = 0
    var lastFilter: TicketFilter?
    var shouldFail = false
    func loadTickets(filter: TicketFilter, search: String) throws -> [TicketListItem] {
        calls += 1; lastFilter = filter
        if shouldFail { throw DomainError.notFound }
        return [TicketListItem(id: UUID(), title: "Falla", location: "Lab", category: .hardware,
                               priority: .high, status: .open, technicianName: nil)]
    }
    func deleteTicket(id: UUID) throws {}
}
@MainActor private final class MockTicketListRouter: TicketListRouterProtocol {
    func makeDetailView(ticketId: UUID, onChange: @escaping () -> Void) -> AnyView { AnyView(EmptyView()) }
    func makeCreateView(onFinish: @escaping () -> Void) -> AnyView { AnyView(EmptyView()) }
}
