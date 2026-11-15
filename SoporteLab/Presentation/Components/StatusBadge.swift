import SwiftUI
struct StatusBadge: View {
    let status: TicketStatus
    var body: some View { Badge(title: status.title, color: Theme.color(for: status)) }
}
