import Foundation
import SwiftData

@MainActor
final class SwiftDataTechnicianRepository: TechnicianRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }

    func fetchAll() throws -> [Technician] {
        do {
            return try context.fetch(FetchDescriptor<TechnicianModel>())
                .map { $0.toEntity() }
                .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        } catch { throw DomainError.persistence(error.localizedDescription) }
    }

    func fetch(id: UUID) throws -> Technician? {
        try fetchAll().first { $0.id == id }
    }

    func save(_ technician: Technician) throws {
        do {
            if let model = try context.fetch(FetchDescriptor<TechnicianModel>()).first(where: { $0.id == technician.id }) {
                model.name = technician.name
                model.specialty = technician.specialty
                model.email = technician.email
            } else {
                context.insert(TechnicianModel(id: technician.id, name: technician.name,
                                               specialty: technician.specialty, email: technician.email))
            }
            try context.save()
        } catch {
            context.rollback()
            throw DomainError.persistence(error.localizedDescription)
        }
    }

    func delete(id: UUID) throws {
        do {
            guard let model = try context.fetch(FetchDescriptor<TechnicianModel>()).first(where: { $0.id == id }) else { throw DomainError.notFound }
            context.delete(model)
            try context.save()
        } catch {
            context.rollback()
            if let error = error as? DomainError { throw error }
            throw DomainError.persistence(error.localizedDescription)
        }
    }
}
