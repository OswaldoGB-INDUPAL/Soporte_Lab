import SwiftUI
struct StatCard: View {
    let title: String
    let value: Int
    let color: Color
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 4)
            VStack(alignment: .leading) {
                Text(title).font(.subheadline)
                Text(value, format: .number).font(.system(size: 34, weight: .bold, design: .rounded))
            }
            Spacer()
        }.padding().frame(maxWidth: .infinity, minHeight: 90)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}
