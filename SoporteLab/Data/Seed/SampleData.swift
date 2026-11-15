import Foundation

@MainActor
enum SampleData {
    static func seedIfNeeded(tickets: TicketRepository, technicians: TechnicianRepository, now: Date = Date()) throws {
        guard try technicians.fetchAll().isEmpty && tickets.fetchAll().isEmpty else { return }
        let people = [
            Technician(id: UUID(), name: "Ana López", specialty: "Redes", email: "ana@empresa.com"),
            Technician(id: UUID(), name: "Carlos Méndez", specialty: "Hardware", email: "carlos@empresa.com"),
            Technician(id: UUID(), name: "María Rivas", specialty: "Software", email: "maria@empresa.com"),
            Technician(id: UUID(), name: "José Hernández", specialty: "Soporte general", email: "jose@empresa.com")
        ]
        for person in people { try technicians.save(person) }
        let rows: [(String, String, String, TicketCategory, TicketPriority, TicketStatus, Int?, Int)] = [
            ("Proyector no enciende", "Aula 4-201", "No proyecta imagen al conectar la laptop.", .hardware, .high, .open, nil, 0),
            ("Sin internet en Lab 3", "Lab 3", "Los equipos no tienen acceso a internet.", .network, .medium, .inProgress, 0, 1),
            ("Instalar Visual Studio", "Lab 1, PC 12", "Se necesita instalar el entorno de desarrollo.", .software, .low, .resolved, 2, 6),
            ("Switch del rack sin luz", "Cuarto de servidores", "El equipo de red no enciende.", .network, .high, .inProgress, 0, 2),
            ("Mouse dañado", "Lab 2, PC 05", "El mouse no responde.", .hardware, .low, .open, nil, 3),
            ("Licencia de Office vencida", "Administración", "La licencia requiere renovación.", .software, .medium, .resolved, 2, 8),
            ("PC reinicia sola", "Lab 4, PC 20", "El equipo se reinicia durante el uso.", .hardware, .high, .inProgress, 1, 1),
            ("Actualizar antivirus", "Lab 1", "Se requiere actualizar el antivirus.", .software, .medium, .open, nil, 4),
            ("Teclado con teclas pegadas", "Lab 3, PC 08", "Algunas teclas no responden correctamente.", .hardware, .low, .resolved, 1, 10),
            ("Solicitud de cuenta de correo", "Recursos Humanos", "Se necesita una cuenta de correo nueva.", .other, .medium, .open, nil, 2)
        ]
        for (index, row) in rows.enumerated() {
            let created = Calendar.current.date(byAdding: .day, value: -row.7, to: now) ?? now
            let ticket = Ticket(id: UUID(), title: row.0, detail: row.2, category: row.3,
                                priority: row.4, status: row.5, location: row.1,
                                technicianId: row.6.map { people[$0].id }, createdAt: created,
                                updatedAt: created, resolvedAt: row.5 == .resolved ? created : nil)
            try tickets.save(ticket)
            try tickets.addFollowUp(FollowUp(id: UUID(), ticketId: ticket.id, text: "Ticket creado", createdAt: created))
            if index == 0 {
                try tickets.addFollowUp(FollowUp(id: UUID(), ticketId: ticket.id, text: "Cable HDMI revisado", createdAt: created.addingTimeInterval(1)))
            }
            if ticket.status == .resolved {
                try tickets.addFollowUp(FollowUp(id: UUID(), ticketId: ticket.id, text: "Estado cambiado a Resuelto", createdAt: created.addingTimeInterval(1)))
            }
        }
    }
}
