import SwiftUI

struct RootTabView: View {
    let container: AppContainer

    var body: some View {
        TabView {
            NavigationStack { TicketListBuilder.build(container: container) }
                .tabItem { Label("Tickets", systemImage: "wrench.and.screwdriver") }
            NavigationStack { TechnicianListBuilder.build(container: container) }
                .tabItem { Label("Técnicos", systemImage: "person.2") }
            NavigationStack { DashboardBuilder.build(container: container) }
                .tabItem { Label("Resumen", systemImage: "chart.bar") }
        }
        .tint(.indigo)
    }
}
