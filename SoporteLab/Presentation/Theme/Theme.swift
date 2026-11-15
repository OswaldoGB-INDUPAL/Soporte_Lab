import SwiftUI

enum Theme {
    static func color(for status: TicketStatus) -> Color {
        switch status { case .open: return .blue; case .inProgress: return .orange; case .resolved: return .green }
    }
    static func color(for priority: TicketPriority) -> Color {
        switch priority { case .low: return .gray; case .medium: return .yellow; case .high: return .red }
    }
}

struct Badge: View {
    let title: String
    let color: Color
    var body: some View {
        Text(title).font(.caption.bold()).foregroundStyle(.primary)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.15), in: Capsule())
            .overlay(Capsule().stroke(color, lineWidth: 1))
    }
}
