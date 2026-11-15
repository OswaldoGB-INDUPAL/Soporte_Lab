import Foundation

@MainActor
protocol TechnicianRepository: AnyObject {
    func fetchAll() throws -> [Technician]
    func fetch(id: UUID) throws -> Technician?
    func save(_ technician: Technician) throws
    func delete(id: UUID) throws
}
