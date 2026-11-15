import SwiftUI

struct TicketFormView: View {
    @State var presenter: TicketFormPresenter
    var body: some View {
        @Bindable var presenter = presenter
        Form {
            Section("Datos") {
                TextField("Título", text: $presenter.data.title)
                if let error = presenter.errors["title"], !presenter.data.title.isEmpty {
                    Text(error).font(.footnote).foregroundStyle(.red)
                }
                TextField("Ubicación", text: $presenter.data.location)
                if let error = presenter.errors["location"], !presenter.data.location.isEmpty {
                    Text(error).font(.footnote).foregroundStyle(.red)
                }
                TextField("Descripción", text: $presenter.data.detail, axis: .vertical)
                if let error = presenter.errors["detail"] {
                    Text(error).font(.footnote).foregroundStyle(.red)
                }
            }
            Section("Clasificación") {
                Picker("Categoría", selection: $presenter.data.category) {
                    ForEach(TicketCategory.allCases) { Text($0.title).tag($0) }
                }
                Picker("Prioridad", selection: $presenter.data.priority) {
                    ForEach(TicketPriority.allCases) { Text($0.title).tag($0) }
                }
                Picker("Técnico", selection: $presenter.data.technicianId) {
                    Text("Ninguno").tag(Optional<UUID>.none)
                    ForEach(presenter.technicians) { person in Text(person.name).tag(Optional(person.id)) }
                }
            }
        }
        .navigationTitle(presenter.title)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { presenter.didCancel() } }
            ToolbarItem(placement: .confirmationAction) { Button("Guardar") { presenter.didSave() }.disabled(!presenter.canSave) }
        }
        .alert("Error", isPresented: Binding(get: { presenter.errorMessage != nil }, set: { if !$0 { presenter.errorMessage = nil } })) {
            Button("OK") { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
        .onAppear { presenter.onAppear() }
    }
}

#Preview {
    if let container = try? AppContainer(storage: .inMemory) {
        NavigationStack { TicketFormBuilder.build(container: container, mode: .create, onFinish: {}) }
    }
}
