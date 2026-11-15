import SwiftUI
struct TechnicianListView: View {
    @State var presenter: TechnicianListPresenter
    var body: some View {
        @Bindable var presenter = presenter
        List {
            ForEach(presenter.items) { item in
                Button { presenter.didSelect(item.id) } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.technician.name).font(.headline)
                            Text("\(item.technician.specialty) · \(item.technician.email)")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.activeCount == 0 ? "Libre" :
                            item.activeCount == 1 ? "1 activo" : "\(item.activeCount) activos")
                            .font(.caption.bold()).foregroundStyle(.secondary)
                    }
                }.buttonStyle(.plain)
            }.onDelete(perform: presenter.didDelete)
        }
        .navigationTitle("Técnicos")
        .toolbar { Button { presenter.didAdd() } label: { Image(systemName: "plus") }.accessibilityLabel("Nuevo técnico") }
        .overlay { if presenter.items.isEmpty { ContentUnavailableView("Sin técnicos", systemImage: "person.2.slash") } }
        .sheet(item: $presenter.route) { presenter.view(for: $0) }
        .confirmationDialog("¿Eliminar técnico?", isPresented: Binding(
            get: { presenter.pendingDeletion != nil },
            set: { if !$0 { presenter.pendingDeletion = nil } })) {
                Button("Eliminar", role: .destructive) { presenter.confirmDelete() }
            }
        .alert("Error", isPresented: Binding(get: { presenter.errorMessage != nil }, set: { if !$0 { presenter.errorMessage = nil } })) {
            Button("OK") { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
        .onAppear { presenter.onAppear() }
    }
}

#Preview {
    if let container = try? AppContainer(storage: .inMemory) {
        NavigationStack { TechnicianListBuilder.build(container: container) }
    }
}
