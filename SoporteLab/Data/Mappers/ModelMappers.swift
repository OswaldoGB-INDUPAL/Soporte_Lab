import Foundation

extension TechnicianModel {
    func toEntity() -> Technician {
        Technician(id: id, name: name, specialty: specialty, email: email)
    }
}

extension TicketModel {
    func toEntity() -> Ticket {
        Ticket(id: id, title: title, detail: detail,
               category: TicketCategory(rawValue: categoryRaw) ?? .other,
               priority: TicketPriority(rawValue: priorityRaw) ?? .medium,
               status: TicketStatus(rawValue: statusRaw) ?? .open,
               location: location, technicianId: technician?.id,
               createdAt: createdAt, updatedAt: updatedAt, resolvedAt: resolvedAt)
    }
}

extension FollowUpModel {
    func toEntity() -> FollowUp? {
        guard let ticket = ticket else { return nil }
        return FollowUp(id: id, ticketId: ticket.id, text: text, createdAt: createdAt)
    }
}

func apply(_ ticket: Ticket, to model: TicketModel, technician: TechnicianModel?) {
    model.title = ticket.title
    model.detail = ticket.detail
    model.categoryRaw = ticket.category.rawValue
    model.priorityRaw = ticket.priority.rawValue
    model.statusRaw = ticket.status.rawValue
    model.location = ticket.location
    model.technician = technician
    model.createdAt = ticket.createdAt
    model.updatedAt = ticket.updatedAt
    model.resolvedAt = ticket.resolvedAt
}
