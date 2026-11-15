import SwiftUI
struct PriorityBadge: View {
    let priority: TicketPriority
    var body: some View { Badge(title: priority.title, color: Theme.color(for: priority)) }
}
