import SwiftUI

struct StorageBarView: View {
    let data: StorageData
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.black)
                    .frame(height: 20)
                
                HStack(spacing: 0) {
                    ForEach(Array(data.categories.enumerated()), id: \.element.name) { index, category in
                        let widthRatio = category.size / data.total
                        let segmentWidth = geometry.size.width * widthRatio
                        
                        Rectangle()
                            .fill(category.color)
                            .frame(width: max(segmentWidth, 0))
                            .animation(.easeInOut(duration: 3.0), value: category.size)
                    }
                    
                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: 2))
            }
        }
        .frame(height: 12)
    }
}

