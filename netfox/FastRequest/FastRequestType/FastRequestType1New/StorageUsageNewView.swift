import SwiftUI

struct StorageUsageNewView: View {
    private let model: AuthorizationOfferModel?
    
    @Binding var totalStorage: Double
    @State private var usedStorage: Double = 1.0
    @State private var currentData: StorageData = StorageData(
        total: 128,
        used: 1.0,
        categories: []
    )
    
    init(model: AuthorizationOfferModel?, totalStorage: Binding<Double>) {
        self.model = model
        self._totalStorage = totalStorage
                
        let initial = StorageData(
            total: 128,
            used: 1.0,
            categories: [
                StorageCategory(name: model?.storage1Scr.topBox.subtitle1 ?? "", size: 10.3, color: .red),
                StorageCategory(name: model?.storage1Scr.topBox.subtitle2 ?? "", size: 8.2, color: .orange),
                StorageCategory(name: model?.storage1Scr.topBox.subtitle3 ?? "", size: 7.1, color: .yellow),
                StorageCategory(name: model?.storage1Scr.topBox.subtitle4 ?? "", size: 6.2, color: .gray),
                StorageCategory(name: model?.storage1Scr.topBox.subtitle5 ?? "", size: 5.2, color: .black)
            ]
        )
        
        self._currentData = State(initialValue: initial)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(model?.storage1Scr.topBox.title ?? "")
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
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }

}

