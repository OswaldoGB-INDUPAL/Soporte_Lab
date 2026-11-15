import SwiftUI
struct CategoryBadge: View {
    let category: TicketCategory
    var body: some View { Badge(title: category.title, color: .secondary) }
}
