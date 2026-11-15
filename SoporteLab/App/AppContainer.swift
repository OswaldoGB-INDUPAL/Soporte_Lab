import Foundation
import SwiftData

enum StorageKind: Sendable { case swiftData, inMemory }

@MainActor
final class AppContainer {
    nonisolated static let storage: StorageKind = .swiftData
    let ticketRepository: TicketRepository
    let technicianRepository: TechnicianRepository
    private let modelContainer: ModelContainer?

    init(storage: StorageKind = AppContainer.storage) throws {
        switch storage {
        case .swiftData:
            let container = try ModelContainer(for: TicketModel.self, TechnicianModel.self, FollowUpModel.self)
            let context = container.mainContext
            modelContainer = container
            ticketRepository = SwiftDataTicketRepository(context: context)
            technicianRepository = SwiftDataTechnicianRepository(context: context)
        case .inMemory:
            let tickets = InMemoryTicketRepository()
            modelContainer = nil
            ticketRepository = tickets
            technicianRepository = InMemoryTechnicianRepository(tickets: tickets)
        }
        try SampleData.seedIfNeeded(tickets: ticketRepository, technicians: technicianRepository)
    }
}
