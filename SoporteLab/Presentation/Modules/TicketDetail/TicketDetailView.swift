import SwiftUI

struct TicketDetailView: View {
    @State var presenter: TicketDetailPresenter
    var body: some View {
        @Bindable var presenter = presenter
        Group {
            if let data = presenter.data {
                List {
                    Section {
                        Text(data.ticket.title).font(.title2.bold())
                        HStack {
                            PriorityBadge(priority: data.ticket.priority)
                            StatusBadge(status: data.ticket.status)
                            CategoryBadge(category: data.ticket.category)
                        }
                        LabeledContent("Ubicación", value: data.ticket.location)
                        LabeledContent("Técnico", value: data.technicianName ?? "Sin asignar")
                        Text(data.ticket.detail.isEmpty ? "Sin descripción" : data.ticket.detail)
                        LabeledContent("Creado", value: data.ticket.createdAt.formatted(date: .abbreviated, time: .shortened))
                        LabeledContent("Actualizado", value: data.ticket.updatedAt.formatted(date: .abbreviated, time: .shortened))
                        if let date = data.ticket.resolvedAt {
                            LabeledContent("Resuelto", value: date.formatted(date: .abbreviated, time: .shortened))
                        }
                        Button(presenter.actionTitle) { presenter.didChangeStatus() }.buttonStyle(.borderedProminent)
                        Menu("Asignar") {
                            Button("Sin asignar") { presenter.didAssign(nil) }
                            ForEach(data.technicians) { person in
                                Button(person.name) { presenter.didAssign(person.id) }
                            }
                        }
                    }
                    Section("Seguimientos") {
                        ForEach(data.followUps) { item in
                            VStack(alignment: .leading) {
                                Text(item.createdAt.formatted(date: .abbreviated, time: .shortened)).font(.caption).foregroundStyle(.secondary)
                                Text(item.text)
                            }
                        }
                        HStack {
                            TextField("Agregar seguimiento…", text: $presenter.message)
                            Button { presenter.didAddFollowUp() } label: { Image(systemName: "paperplane.fill") }
                                .accessibilityLabel("Enviar seguimiento")
                                .disabled(presenter.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || presenter.message.count > 300)
                        }
                    }
                }
                .toolbar { Button("Editar") { presenter.didEdit() } }
            } else {
                ContentUnavailableView("Ticket no encontrado", systemImage: "tray")
            }
        }
        .navigationTitle("Detalle")
        .sheet(item: $presenter.route) { presenter.view(for: $0) }
        .alert("Error", isPresented: Binding(get: { presenter.errorMessage != nil }, set: { if !$0 { presenter.errorMessage = nil } })) {
            Button("OK") { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
        .onAppear { presenter.onAppear() }
    }
}

#Preview {
    if let container = try? AppContainer(storage: .inMemory),
       let ticket = try? container.ticketRepository.fetchAll().first {
        NavigationStack { TicketDetailBuilder.build(container: container, ticketId: ticket.id, onChange: {}) }
    }
}
