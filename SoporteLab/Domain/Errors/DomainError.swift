import Foundation

enum DomainError: LocalizedError, Equatable {
    case validation(String)
    case technicianRequired
    case technicianHasActiveTickets(Int)
    case notFound
    case persistence(String)

    var errorDescription: String? {
        switch self {
        case .validation(let message): return message
        case .technicianRequired: return "Asigna un técnico antes de iniciar la atención."
        case .technicianHasActiveTickets(let count): return "No se puede eliminar: tiene \(count) ticket(s) en proceso."
        case .notFound: return "El registro ya no existe."
        case .persistence(let message): return "Error al guardar: \(message)"
        }
    }
}
