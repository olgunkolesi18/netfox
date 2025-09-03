import SwiftUI

struct StorageFlowLayout: View {
    let categories: [StorageCategory]
    
    var body: some View {
        FlowLayout(spacing: 12) {
            ForEach(Array(categories.enumerated()), id: \.element.name) { index, category in
                CategoryLabelView(category: category)
            }
        }
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, in: proposal.replacingUnspecifiedDimensions()).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, in: proposal.replacingUnspecifiedDimensions()).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], in containerSize: CGSize) -> (offsets: [CGPoint], size: CGSize) {
        var result: [CGPoint] = []
        var currentRow: [CGSize] = []
        var currentRowWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        let containerWidth = containerSize.width
        
        for size in sizes {
            let itemWidth = size.width
            
            if currentRowWidth + itemWidth > containerWidth && !currentRow.isEmpty {
                let rowHeight = currentRow.map(\.height).max() ?? 0
                placeRow(currentRow, startY: totalHeight, result: &result)
                totalHeight += rowHeight + 8
                maxWidth = max(maxWidth, currentRowWidth - spacing)
                
                currentRow = [size]
                currentRowWidth = itemWidth + spacing
            } else {
                currentRow.append(size)
                currentRowWidth += itemWidth + spacing
            }
        }
        
        if !currentRow.isEmpty {
            let rowHeight = currentRow.map(\.height).max() ?? 0
            placeRow(currentRow, startY: totalHeight, result: &result)
            totalHeight += rowHeight
            maxWidth = max(maxWidth, currentRowWidth - spacing)
        }
        
        return (result, CGSize(width: maxWidth, height: totalHeight))
    }
    
    private func placeRow(_ row: [CGSize], startY: CGFloat, result: inout [CGPoint]) {
        var currentX: CGFloat = 0
        
        for size in row {
            result.append(CGPoint(x: currentX, y: startY))
            currentX += size.width + spacing
        }
    }
}

