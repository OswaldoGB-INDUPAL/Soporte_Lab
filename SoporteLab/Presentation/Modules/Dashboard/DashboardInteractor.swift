import Foundation
@MainActor final class DashboardInteractor: DashboardInteractorProtocol {
    private let tickets: TicketRepository
    init(tickets: TicketRepository) { self.tickets = tickets }
    func loadSummary() throws -> DashboardSummary {
        let all = try tickets.fetchAll()
        return DashboardSummary(total: all.count,
            open: all.filter { $0.status == .open }.count,
            inProgress: all.filter { $0.status == .inProgress }.count,
            resolved: all.filter { $0.status == .resolved }.count,
            highPriority: all.filter { $0.priority == .high }.count,
            categories: Dictionary(uniqueKeysWithValues: TicketCategory.allCases.map { category in
                (category, all.filter { $0.category == category }.count)
            }))
    }
}
