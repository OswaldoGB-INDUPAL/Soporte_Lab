import Foundation

@MainActor
final class TicketFormInteractor: TicketFormInteractorProtocol {
    private let tickets: TicketRepository
    private let people: TechnicianRepository
    private let now: () -> Date

    init(tickets: TicketRepository, technicians: TechnicianRepository, now: @escaping () -> Date = Date.init) {
        self.tickets = tickets
        self.people = technicians
        self.now = now
    }

    func technicians() throws -> [Technician] { try people.fetchAll() }

    func load(mode: TicketFormMode) throws -> TicketFormData {
        guard case .edit(let id) = mode else { return TicketFormData() }
        guard let ticket = try tickets.fetch(id: id) else { throw DomainError.notFound }
        return TicketFormData(title: ticket.title, location: ticket.location, detail: ticket.detail,
                              category: ticket.category, priority: ticket.priority, technicianId: ticket.technicianId)
    }

    func validate(_ data: TicketFormData) -> [String: String] {
        var errors: [String: String] = [:]
        let title = data.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !(3...80).contains(title.count) { errors["title"] = "El título debe tener entre 3 y 80 caracteres." }
        if data.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors["location"] = "La ubicación es obligatoria." }
        if data.detail.count > 500 { errors["detail"] = "La descripción no puede pasar de 500 caracteres." }
        return errors
    }

    func save(_ data: TicketFormData, mode: TicketFormMode) throws {
        let errors = validate(data)
        if let error = errors["title"] ?? errors["location"] ?? errors["detail"] {
            throw DomainError.validation(error)
        }
        let selectedTechnician: Technician?
        if let id = data.technicianId {
            guard let person = try people.fetch(id: id) else { throw DomainError.notFound }
            selectedTechnician = person
        } else {
            selectedTechnician = nil
        }
        let date = now()
        var ticket: Ticket
        switch mode {
        case .create:
            ticket = Ticket(id: UUID(), title: "", detail: "", category: data.category, priority: data.priority,
                            status: .open, location: "", technicianId: nil,
                            createdAt: date, updatedAt: date, resolvedAt: nil)
        case .edit(let id):
            guard let existing = try tickets.fetch(id: id) else { throw DomainError.notFound }
            ticket = existing
            if ticket.status == .inProgress && data.technicianId == nil {
                throw DomainError.validation("Un ticket en proceso necesita técnico.")
            }
        }
        let previousTechnicianId = ticket.technicianId
        ticket.title = data.title.trimmingCharacters(in: .whitespacesAndNewlines)
        ticket.location = data.location.trimmingCharacters(in: .whitespacesAndNewlines)
        ticket.detail = data.detail
        ticket.category = data.category
        ticket.priority = data.priority
        ticket.technicianId = data.technicianId
        ticket.updatedAt = date
        if case .create = mode {
            try tickets.save(ticket, with: FollowUp(id: UUID(), ticketId: ticket.id,
                                                    text: "Ticket creado", createdAt: date))
        } else if previousTechnicianId != ticket.technicianId {
            let text = selectedTechnician.map { "Asignado a \($0.name)" } ?? "Técnico removido"
            try tickets.save(ticket, with: FollowUp(id: UUID(), ticketId: ticket.id, text: text, createdAt: date))
        } else {
            try tickets.save(ticket)
        }
    }
}
