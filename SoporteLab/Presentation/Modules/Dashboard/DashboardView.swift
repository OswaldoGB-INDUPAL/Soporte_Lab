import SwiftUI
struct DashboardView: View {
    @State var presenter: DashboardPresenter
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        @Bindable var presenter = presenter
        ScrollView {
            if let summary = presenter.summary {
                VStack(alignment: .leading, spacing: 18) {
                    Text("\(summary.total) tickets registrados").font(.headline)
                    LazyVGrid(columns: columns) {
                        StatCard(title: "Abiertos", value: summary.open, color: .blue)
                        StatCard(title: "En proceso", value: summary.inProgress, color: .orange)
                        StatCard(title: "Resueltos", value: summary.resolved, color: .green)
                        StatCard(title: "Prioridad alta", value: summary.highPriority, color: .red)
                    }
                    Text("Por categoría").font(.headline)
                    ForEach(TicketCategory.allCases) { category in
                        let count = summary.categories[category, default: 0]
                        let maximum = max(summary.categories.values.max() ?? 0, 1)
                        VStack(alignment: .leading) {
                            HStack { Text(category.title); Spacer(); Text(count, format: .number) }
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.secondary.opacity(0.15))
                                    Capsule().fill(Color.indigo).frame(width: geometry.size.width * CGFloat(count) / CGFloat(maximum))
                                }
                            }.frame(height: 9)
                        }
                    }
                }.padding()
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Resumen")
        .alert("Error", isPresented: Binding(get: { presenter.errorMessage != nil }, set: { if !$0 { presenter.errorMessage = nil } })) {
            Button("OK") { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
        .onAppear { presenter.onAppear() }
    }
}

#Preview {
    if let container = try? AppContainer(storage: .inMemory) {
        NavigationStack { DashboardBuilder.build(container: container) }
    }
}
