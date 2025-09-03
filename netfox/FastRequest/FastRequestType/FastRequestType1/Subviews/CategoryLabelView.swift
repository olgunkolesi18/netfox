import SwiftUI

struct CategoryLabelView: View {
    let category: StorageCategory

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(category.color)
                .frame(width: 8, height: 8)

            Text(category.name)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}
