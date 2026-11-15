import SwiftUI

struct TicketRow: View {
    let item: TicketListItem
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.title).font(.headline)
            Text([item.location, item.category.title, item.technicianName ?? "Sin asignar"].joined(separator: " · "))
                .font(.subheadline).foregroundStyle(.secondary)
            HStack { PriorityBadge(priority: item.priority); StatusBadge(status: item.status) }
        }.padding(.vertical, 3)
    }
}
