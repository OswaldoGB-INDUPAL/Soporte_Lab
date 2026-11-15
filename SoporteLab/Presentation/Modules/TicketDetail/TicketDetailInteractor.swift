import Foundation

@MainActor
final class TicketDetailInteractor: TicketDetailInteractorProtocol {
    private let tickets: TicketRepository
    private let people: TechnicianRepository
    private let now: () -> Date
    init(tickets: TicketRepository, technicians: TechnicianRepository, now: @escaping () -> Date = Date.init) {
        self.tickets = tickets; self.people = technicians; self.now = now
    }
    func load(id: UUID) throws -> TicketDetailData {
        guard let ticket = try tickets.fetch(id: id) else { throw DomainError.notFound }
        let technicians = try people.fetchAll()
        return TicketDetailData(ticket: ticket,
            technicianName: technicians.first { $0.id == ticket.technicianId }?.name,
            technicians: technicians, followUps: try tickets.followUps(ticketId: id))
    }
    func changeStatus(id: UUID, to status: TicketStatus) throws {
        guard var ticket = try tickets.fetch(id: id) else { throw DomainError.notFound }
        if status == .inProgress && ticket.technicianId == nil { throw DomainError.technicianRequired }
        guard ticket.status != status else { return }
        let date = now()
        ticket.status = status
        ticket.updatedAt = date
        if status == .resolved { ticket.resolvedAt = date }
        else { ticket.resolvedAt = nil }
        try tickets.save(ticket, with: FollowUp(id: UUID(), ticketId: id,
            text: "Estado cambiado a \(status.title)", createdAt: date))
    }
    func assign(ticketId: UUID, technicianId: UUID?) throws {
        guard var ticket = try tickets.fetch(id: ticketId) else { throw DomainError.notFound }
        if ticket.status == .inProgress && technicianId == nil {
            throw DomainError.validation("Un ticket en proceso necesita técnico.")
        }
        guard ticket.technicianId != technicianId else { return }
        var message = "Técnico removido"
        if let technicianId {
            guard let person = try people.fetch(id: technicianId) else { throw DomainError.notFound }
            message = "Asignado a \(person.name)"
        }
        let date = now()
        ticket.technicianId = technicianId
        ticket.updatedAt = date
        try tickets.save(ticket, with: FollowUp(id: UUID(), ticketId: ticketId, text: message, createdAt: date))
    }
    func addFollowUp(ticketId: UUID, text: String) throws {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard (1...300).contains(trimmed.count) else {
            throw DomainError.validation("El seguimiento debe tener entre 1 y 300 caracteres.")
        }
        guard try tickets.fetch(id: ticketId) != nil else { throw DomainError.notFound }
        try tickets.addFollowUp(FollowUp(id: UUID(), ticketId: ticketId, text: trimmed, createdAt: now()))
    }
}
