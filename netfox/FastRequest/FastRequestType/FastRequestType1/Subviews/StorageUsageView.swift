import SwiftUI

struct StorageCategory {
    let name: String
    let size: Double
    let color: Color
}

struct StorageData {
    let total: Double
    var used: Double
    let categories: [StorageCategory]
}

struct StorageUsageView: View {
    
    private var originalData = StorageData(
        total: 128,
        used: 1.0,
        categories: [
            StorageCategory(name: "", size: 10.3, color: Color(red: 255/255, green: 56/255, blue: 60/255)),
            StorageCategory(name: "", size: 8.2, color: Color(red: 255/255, green: 141/255, blue: 40/255)),
            StorageCategory(name: "", size: 7.1, color: Color(red: 255/255, green: 204/255, blue: 0)),
            StorageCategory(name: "", size: 6.2, color: Color(red: 72/255, green: 72/255, blue: 74/255)),
            StorageCategory(name: "", size: 5.2, color: Color(red: 44/255, green: 44/255, blue: 46/255))
        ]
    )
    
    private var demoData = StorageData(
        total: 128,
        used: 126.2,
        categories: [
            StorageCategory(name: "", size: 85.5, color: Color(red: 255/255, green: 56/255, blue: 60/255)),
            StorageCategory(name: "", size: 25.3, color: Color(red: 255/255, green: 141/255, blue: 40/255)),
            StorageCategory(name: "", size: 8.2, color: Color(red: 255/255, green: 204/255, blue: 0)),
            StorageCategory(name: "", size: 2.5, color: Color(red: 72/255, green: 72/255, blue: 74/255)),
            StorageCategory(name: "", size: 4.7, color: Color(red: 44/255, green: 44/255, blue: 46/255))
        ]
    )
    
    private var finalData = StorageData(
        total: 128,
        used: 1.0,
        categories: [
            StorageCategory(name: "", size: 51.0, color: Color(red: 255/255, green: 56/255, blue: 60/255)),
            StorageCategory(name: "", size: 4.92, color: Color(red: 255/255, green: 141/255, blue: 40/255)),
            StorageCategory(name: "", size: 4.26, color: Color(red: 255/255, green: 204/255, blue: 0)),
            StorageCategory(name: "", size: 3.72, color: Color(red: 72/255, green: 72/255, blue: 74/255)),
            StorageCategory(name: "", size: 3.12, color: Color(red: 44/255, green: 44/255, blue: 46/255))
        ]
    )
    
    @State private var currentData: StorageData = StorageData(
        total: 128,
        used: 1.0,
        categories: [
            StorageCategory(name: "", size: 51.0, color: Color(red: 255/255, green: 56/255, blue: 60/255)),
            StorageCategory(name: "", size: 4.92, color: Color(red: 255/255, green: 141/255, blue: 40/255)),
            StorageCategory(name: "", size: 4.26, color: Color(red: 255/255, green: 204/255, blue: 0)),
            StorageCategory(name: "", size: 3.72, color: Color(red: 72/255, green: 72/255, blue: 74/255)),
            StorageCategory(name: "", size: 3.12, color: Color(red: 44/255, green: 44/255, blue: 46/255))
        ]
    )

    @Binding var shouldShow: Bool
    @Binding var shouldHide: Bool
    @Binding var totalStorage: Double
    @State private var usedStorage: Double = 0
    
    private let model: StorageModel?
    
    init(model: StorageModel?, shouldShow: Binding<Bool>, shouldHide: Binding<Bool>, totalStorage: Binding<Double>) {
        self.model = model
        self._shouldShow = shouldShow
        self._shouldHide = shouldHide
        self._totalStorage = totalStorage
        
        setupDataSource()
        
        let initial = StorageData(
            total: 128,
            used: 1.0,
            categories: [
                StorageCategory(name: model?.topBox?.subtitle1 ?? "", size: 10.3, color: .red),
                StorageCategory(name: model?.topBox?.subtitle2 ?? "", size: 8.2, color: .orange),
                StorageCategory(name: model?.topBox?.subtitle3 ?? "", size: 7.1, color: .yellow),
                StorageCategory(name: model?.topBox?.subtitle4 ?? "", size: 6.2, color: .gray),
                StorageCategory(name: model?.topBox?.subtitle5 ?? "", size: 5.2, color: .black)
            ]
        )
        
        self._currentData = State(initialValue: initial)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(model?.topBox?.title ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(String(format: "%.1f", usedStorage)) of \(String(format: "%.1f", totalStorage)) GB used")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 125/255, green: 125/255, blue: 125/255))
            }
            
            StorageBarView(data: currentData)
                .padding(.bottom, 9)
            
            StorageFlowLayout(categories: currentData.categories)
                .padding(.horizontal, 4)
        }
        .onChange(of: shouldShow) { _ in
            startDemoAnimation()
        }
        .onChange(of: shouldHide) { _ in
            stopDemoAnimation()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
    
    private mutating func setupDataSource() {
        originalData = StorageData(
            total: 128,
            used: 1.0,
            categories: [
                StorageCategory(name: model?.topBox?.subtitle1 ?? "", size: 10.3, color: Color(red: 255/255, green: 56/255, blue: 60/255)),
                StorageCategory(name: model?.topBox?.subtitle2 ?? "", size: 8.2, color: Color(red: 255/255, green: 141/255, blue: 40/255)),
                StorageCategory(name: model?.topBox?.subtitle3 ?? "", size: 7.1, color: Color(red: 255/255, green: 204/255, blue: 0)),
                StorageCategory(name: model?.topBox?.subtitle4 ?? "", size: 6.2, color: Color(red: 72/255, green: 72/255, blue: 74/255)),
                StorageCategory(name: model?.topBox?.subtitle5 ?? "", size: 5.2, color: Color(red: 44/255, green: 44/255, blue: 46/255))
            ]
        )
        
        demoData = StorageData(
            total: 128,
            used: 126.2,
            categories: [
                StorageCategory(name: model?.topBox?.subtitle1 ?? "", size: 85.5, color: Color(red: 255/255, green: 56/255, blue: 60/255)),
                StorageCategory(name: model?.topBox?.subtitle2 ?? "", size: 25.3, color: Color(red: 255/255, green: 141/255, blue: 40/255)),
                StorageCategory(name: model?.topBox?.subtitle3 ?? "", size: 8.2, color: Color(red: 255/255, green: 204/255, blue: 0)),
                StorageCategory(name: model?.topBox?.subtitle4 ?? "", size: 2.5, color: Color(red: 72/255, green: 72/255, blue: 74/255)),
                StorageCategory(name: model?.topBox?.subtitle5 ?? "", size: 4.7, color: Color(red: 44/255, green: 44/255, blue: 46/255))
            ]
        )
        
        finalData = StorageData(
            total: 128,
            used: 1.0,
            categories: [
                StorageCategory(name: model?.topBox?.subtitle1 ?? "", size: 51.0, color: Color(red: 255/255, green: 56/255, blue: 60/255)),
                StorageCategory(name: model?.topBox?.subtitle2 ?? "", size: 4.92, color: Color(red: 255/255, green: 141/255, blue: 40/255)),
                StorageCategory(name: model?.topBox?.subtitle3 ?? "", size: 4.26, color: Color(red: 255/255, green: 204/255, blue: 0)),
                StorageCategory(name: model?.topBox?.subtitle4 ?? "", size: 3.72, color: Color(red: 72/255, green: 72/255, blue: 74/255)),
                StorageCategory(name: model?.topBox?.subtitle5 ?? "", size: 3.12, color: Color(red: 44/255, green: 44/255, blue: 46/255))
            ]
        )
    }
    
    private func startDemoAnimation() {
        animateStorageData(from: currentData, to: demoData, duration: 3.0, steps: 120)
        animateUsedStorageTitle(from: usedStorage, to: totalStorage * 0.95, duration: 4.0, steps: 120)
    }
    
    private func stopDemoAnimation() {
        animateStorageData(from: currentData, to: finalData, duration: 3.0, steps: 120)
        animateUsedStorageTitle(from: usedStorage, to: totalStorage * 0.6, duration: 4.0, steps: 120)
    }
    
    private func animateUsedStorageTitle(from start: Double, to end: Double, duration: Double = 2.5, steps: Int = 60) {
        let stepDuration = duration / Double(steps)
        let stepValue = (end - start) / Double(steps)

        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                let newValue = start + stepValue * Double(i)

                withAnimation(.linear(duration: stepDuration)) {
                    usedStorage = newValue
                }
            }
        }
    }

    
    private func animateStorageData(from start: StorageData, to end: StorageData, duration: Double = 2.5, steps: Int = 60) {
        let stepDuration = duration / Double(steps)

        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                let progress = Double(i) / Double(steps)
                
                var animatedData = StorageData(
                    total: start.total,
                    used: start.used + (end.used - start.used) * progress,
                    categories: start.categories.enumerated().map { index, category in
                        let target = end.categories[index]
                        return StorageCategory(
                            name: category.name,
                            size: category.size + (target.size - category.size) * progress,
                            color: target.color
                        )
                    }
                )

                withAnimation(.linear(duration: stepDuration)) {
                    currentData = animatedData
                }
            }
        }
    }
    
    private func formatSize(_ size: Double) -> String {
        if size < 1 {
            return "\(Int(size * 1000)) MB"
        }
        return String(format: "%.1f GB", size)
    }
}


