import Foundation

enum TicketCategory: String, CaseIterable, Identifiable, Codable {
    case hardware, software, network, other
    var id: String { rawValue }
    var title: String {
        switch self {
        case .hardware: return "Hardware"
        case .software: return "Software"
        case .network: return "Red"
        case .other: return "Otro"
        }
    }
}

enum TicketPriority: String, CaseIterable, Identifiable, Codable, Comparable {
    case low, medium, high
    var id: String { rawValue }
    var title: String {
        switch self {
        case .low: return "Baja"
        case .medium: return "Media"
        case .high: return "Alta"
        }
    }
    var sortOrder: Int {
        switch self {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        }
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}

enum TicketStatus: String, CaseIterable, Identifiable, Codable {
    case open, inProgress, resolved
    var id: String { rawValue }
    var title: String {
        switch self {
        case .open: return "Abierto"
        case .inProgress: return "En proceso"
        case .resolved: return "Resuelto"
        }
    }
}
