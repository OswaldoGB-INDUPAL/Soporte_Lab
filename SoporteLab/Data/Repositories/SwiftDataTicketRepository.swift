import Foundation
import SwiftData

@MainActor
final class SwiftDataTicketRepository: TicketRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }

    func fetchAll() throws -> [Ticket] {
        do { return try context.fetch(FetchDescriptor<TicketModel>()).map { $0.toEntity() } }
        catch { throw DomainError.persistence(error.localizedDescription) }
    }

    func fetch(id: UUID) throws -> Ticket? {
        try fetchAll().first { $0.id == id }
    }

    func save(_ ticket: Ticket) throws {
        try persist(ticket, followUp: nil)
    }

    func save(_ ticket: Ticket, with followUp: FollowUp) throws {
        guard followUp.ticketId == ticket.id else {
            throw DomainError.validation("El seguimiento no corresponde al ticket.")
        }
        try persist(ticket, followUp: followUp)
    }

    private func persist(_ ticket: Ticket, followUp: FollowUp?) throws {
        do {
            let models = try context.fetch(FetchDescriptor<TicketModel>())
            let technicians = try context.fetch(FetchDescriptor<TechnicianModel>())
            let technician = technicians.first { $0.id == ticket.technicianId }
            if ticket.technicianId != nil && technician == nil { throw DomainError.notFound }
            let model: TicketModel
            if let existing = models.first(where: { $0.id == ticket.id }) {
                model = existing
                apply(ticket, to: model, technician: technician)
            } else {
                model = TicketModel(id: ticket.id, title: ticket.title, detail: ticket.detail,
                    categoryRaw: ticket.category.rawValue, priorityRaw: ticket.priority.rawValue,
                    statusRaw: ticket.status.rawValue, location: ticket.location,
                    createdAt: ticket.createdAt, updatedAt: ticket.updatedAt,
                    resolvedAt: ticket.resolvedAt, technician: technician)
                context.insert(model)
            }
            if let followUp {
                context.insert(FollowUpModel(id: followUp.id, text: followUp.text,
                                             createdAt: followUp.createdAt, ticket: model))
            }
            try context.save()
        } catch {
            context.rollback()
            if let error = error as? DomainError { throw error }
            throw DomainError.persistence(error.localizedDescription)
        }
    }

    func delete(id: UUID) throws {
        do {
            guard let model = try context.fetch(FetchDescriptor<TicketModel>()).first(where: { $0.id == id }) else { throw DomainError.notFound }
            context.delete(model)
            try context.save()
        } catch {
            context.rollback()
            if let error = error as? DomainError { throw error }
            throw DomainError.persistence(error.localizedDescription)
        }
    }

    func followUps(ticketId: UUID) throws -> [FollowUp] {
        do {
            return try context.fetch(FetchDescriptor<FollowUpModel>())
                .compactMap { $0.toEntity() }
                .filter { $0.ticketId == ticketId }
                .sorted { $0.createdAt < $1.createdAt }
        } catch { throw DomainError.persistence(error.localizedDescription) }
    }

    func addFollowUp(_ followUp: FollowUp) throws {
        do {
            guard let ticket = try context.fetch(FetchDescriptor<TicketModel>()).first(where: { $0.id == followUp.ticketId }) else { throw DomainError.notFound }
            context.insert(FollowUpModel(id: followUp.id, text: followUp.text, createdAt: followUp.createdAt, ticket: ticket))
            try context.save()
        } catch {
            context.rollback()
            if let error = error as? DomainError { throw error }
            throw DomainError.persistence(error.localizedDescription)
        }
    }
}
