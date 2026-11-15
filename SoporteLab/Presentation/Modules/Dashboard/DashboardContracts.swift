import Foundation
struct DashboardSummary {
    let total: Int
    let open: Int
    let inProgress: Int
    let resolved: Int
    let highPriority: Int
    let categories: [TicketCategory: Int]
}
@MainActor protocol DashboardInteractorProtocol { func loadSummary() throws -> DashboardSummary }
