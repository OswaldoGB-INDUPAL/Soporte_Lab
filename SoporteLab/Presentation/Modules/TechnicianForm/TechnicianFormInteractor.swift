import Foundation
@MainActor final class TechnicianFormInteractor: TechnicianFormInteractorProtocol {
    private let people: TechnicianRepository
    init(technicians: TechnicianRepository) { self.people = technicians }
    func load(mode: TechnicianFormMode) throws -> TechnicianFormData {
        guard case .edit(let id) = mode else { return TechnicianFormData() }
        guard let person = try people.fetch(id: id) else { throw DomainError.notFound }
        return TechnicianFormData(name: person.name, specialty: person.specialty, email: person.email)
    }
    func validate(_ data: TechnicianFormData) -> [String: String] {
        var errors: [String: String] = [:]
        if data.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors["name"] = "El nombre es obligatorio." }
        if data.specialty.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors["specialty"] = "La especialidad es obligatoria." }
        let email = data.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        if email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) == nil {
            errors["email"] = "Formato de correo no válido"
        }
        return errors
    }
    func save(_ data: TechnicianFormData, mode: TechnicianFormMode) throws {
        let errors = validate(data)
        if let error = errors["name"] ?? errors["specialty"] ?? errors["email"] { throw DomainError.validation(error) }
        let id: UUID
        switch mode {
        case .create: id = UUID()
        case .edit(let existing):
            guard try people.fetch(id: existing) != nil else { throw DomainError.notFound }
            id = existing
        }
        try people.save(Technician(id: id,
            name: data.name.trimmingCharacters(in: .whitespacesAndNewlines),
            specialty: data.specialty.trimmingCharacters(in: .whitespacesAndNewlines),
            email: data.email.trimmingCharacters(in: .whitespacesAndNewlines)))
    }
}
