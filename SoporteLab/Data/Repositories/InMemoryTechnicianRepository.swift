import Foundation

@MainActor
final class InMemoryTechnicianRepository: TechnicianRepository {
    private var technicians: [UUID: Technician] = [:]
    private weak var tickets: InMemoryTicketRepository?

    init(tickets: InMemoryTicketRepository) { self.tickets = tickets }
    func fetchAll() throws -> [Technician] {
        technicians.values.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
    func fetch(id: UUID) throws -> Technician? { technicians[id] }
    func save(_ technician: Technician) throws { technicians[technician.id] = technician }
    func delete(id: UUID) throws {
        guard technicians.removeValue(forKey: id) != nil else { throw DomainError.notFound }
        tickets?.unassign(technicianId: id)
    }
}
