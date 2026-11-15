import XCTest
import SwiftData
@testable import SoporteLab

@MainActor final class SwiftDataRepositoryTests: XCTestCase {
    func test_ticketAndFollowUpPersistAcrossContainers() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("test.store")
        let schema = Schema([TicketModel.self, TechnicianModel.self, FollowUpModel.self])
        let config = ModelConfiguration(schema: schema, url: url)
        let id = UUID()
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        do {
            let container = try ModelContainer(for: schema, configurations: config)
            let repository = SwiftDataTicketRepository(context: container.mainContext)
            let ticket = Ticket(id: id, title: "Falla de red", detail: "", category: .network,
                                priority: .high, status: .open, location: "Lab",
                                technicianId: nil, createdAt: date, updatedAt: date, resolvedAt: nil)
            try repository.save(ticket, with: FollowUp(id: UUID(), ticketId: id,
                                                       text: "Ticket creado", createdAt: date))
        }
        let reopened = try ModelContainer(for: schema, configurations: config)
        let repository = SwiftDataTicketRepository(context: reopened.mainContext)
        XCTAssertEqual(try repository.fetch(id: id)?.title, "Falla de red")
        XCTAssertEqual(try repository.followUps(ticketId: id).map(\.text), ["Ticket creado"])
    }
    func test_deletingTechnicianUnassignsTicketAndDeletingTicketCascades() throws {
        let schema = Schema([TicketModel.self, TechnicianModel.self, FollowUpModel.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)
        let tickets = SwiftDataTicketRepository(context: container.mainContext)
        let people = SwiftDataTechnicianRepository(context: container.mainContext)
        let technician = Technician(id: UUID(), name: "Ana", specialty: "Redes", email: "ana@empresa.com")
        try people.save(technician)
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let ticket = Ticket(id: UUID(), title: "Falla de red", detail: "", category: .network,
                            priority: .high, status: .open, location: "Lab",
                            technicianId: technician.id, createdAt: date, updatedAt: date, resolvedAt: nil)
        try tickets.save(ticket, with: FollowUp(id: UUID(), ticketId: ticket.id,
                                                text: "Ticket creado", createdAt: date))
        try people.delete(id: technician.id)
        XCTAssertNil(try tickets.fetch(id: ticket.id)?.technicianId)
        try tickets.delete(id: ticket.id)
        XCTAssertTrue(try tickets.followUps(ticketId: ticket.id).isEmpty)
        XCTAssertTrue(try container.mainContext.fetch(FetchDescriptor<FollowUpModel>()).isEmpty)
    }

}
