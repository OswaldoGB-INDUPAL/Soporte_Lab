import SwiftUI

struct TicketListView: View {
    @State var presenter: TicketListPresenter
    var body: some View {
        @Bindable var presenter = presenter
        List {
            ForEach(presenter.items) { item in
                Button { presenter.didSelect(item.id) } label: { TicketRow(item: item) }
                    .buttonStyle(.plain)
            }.onDelete(perform: presenter.didDelete)
        }
        .navigationTitle("Tickets")
        .searchable(text: $presenter.searchText, prompt: "Buscar por título o ubicación")
        .toolbar { Button { presenter.didTapAdd() } label: { Image(systemName: "plus") }.accessibilityLabel("Nuevo ticket") }
        .safeAreaInset(edge: .top) {
            Picker("Filtro", selection: $presenter.filter) {
                ForEach(TicketFilter.allCases) { Text($0.title).tag($0) }
            }.pickerStyle(.segmented).padding(.horizontal)
        }
        .navigationDestination(item: $presenter.pushRoute) { presenter.view(for: $0) }
        .sheet(item: $presenter.sheetRoute) { presenter.view(for: $0) }
        .confirmationDialog("¿Eliminar ticket?", isPresented: Binding(
            get: { presenter.pendingDeletion != nil },
            set: { if !$0 { presenter.pendingDeletion = nil } })) {
                Button("Eliminar", role: .destructive) { presenter.confirmDelete() }
            }
        .alert("Error", isPresented: Binding(get: { presenter.errorMessage != nil }, set: { if !$0 { presenter.errorMessage = nil } })) {
            Button("OK") { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
        .overlay { if presenter.items.isEmpty { ContentUnavailableView("Sin tickets", systemImage: "tray", description: Text("No hay tickets con este filtro.")) } }
        .onAppear { presenter.onAppear() }
    }
}

#Preview {
    if let container = try? AppContainer(storage: .inMemory) {
        NavigationStack { TicketListBuilder.build(container: container) }
    }
}
