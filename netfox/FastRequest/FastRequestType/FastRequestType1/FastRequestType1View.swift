import SwiftUI
import Kingfisher

extension UIDevice {
    static var isIpad: Bool {
        current.userInterfaceIdiom == .pad
    }
}

public struct FastRequestType1View: View {
    
    private var dataSourceItems: [SampleMenuItem] = []
    private var dataSourceFinalItems: [SampleMenuItem] = []
    private var dataSourceThirdItems: [SampleMenuItem] = []
    
    @State private var shouldOn = false
    @State private var shouldOff = false
    @State private var animatedItems: [SampleMenuItem] = []
    @State private var deviceStorageGB: Double = 0
    
    @State private var showCriticalAlert = false
    @State private var showDataLossAlert = false
    
    @State private var showFinalScreen = false
    
    @State private var subtitle: String = ""
    @State private var subtitleIsGreen: Bool = false
    @Binding var showNextScreen: Bool
    @Binding var isFinalScreenShown: Bool
    
    private let model: AuthorizationOfferModel?
    private let completion: ((EventsTitles?) -> Void)
    
    public init(model: AuthorizationOfferModel?, showNextScreen: Binding<Bool>, isFinalScreenShown: Binding<Bool>, completion: @escaping ((EventsTitles?) -> Void)) {
        self.model = model
        self.completion = completion
        self._showNextScreen = showNextScreen
        self._isFinalScreenShown = isFinalScreenShown
        
        _subtitle = State(initialValue: model?.storage.subtitle ?? "")
        setupDataSource()
        getTotalSpace()
        getDeviceStorage()
    }
    
    public var body: some View {
        ZStack {
            FirstScreen()
                .compositingGroup()
                .allowsHitTesting(!showFinalScreen)
                .zIndex(0)

            FinalScreen()
                .compositingGroup()
                .opacity(showFinalScreen ? 1 : 0)
                .allowsHitTesting(showFinalScreen)
                .zIndex(1)
        }
    }
    
    private func FirstScreen() -> some View {
        VStack(spacing: 10) {
            VStack {
                Text(model?.storage.title ?? "")
                    .font(.system(size: UIDevice.isIpad ? 20 : 17, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                SearchBar(text: model?.storage.searchText ?? "")
            }
            .padding(.top, UIDevice.isIpad ? 50 : 10)
            
            StorageUsageView(model: model?.storage, shouldShow: $shouldOn, shouldHide: $shouldOff, totalStorage: $deviceStorageGB)
                .padding(.top, 5)
            
            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(subtitleIsGreen ? Color(red: 0, green: 186/255, blue: 0) : .white)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 9) {
                Spacer()
                
                Text(model?.storage.sizeText ?? "")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(red: 0, green: 136/255, blue: 1))
                
                VStack {
                    Image(systemName: "chevron.up")
                        .resizable()
                        .foregroundColor(Color(red: 0, green: 136/255, blue: 1))
                        .scaledToFit()
                        .frame(width: 10, height: 6)
                        .offset(x: 0, y: 3)
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .foregroundColor(Color(red: 0, green: 136/255, blue: 1))
                        .scaledToFit()
                        .frame(width: 10, height: 6)
                        .offset(x: 0, y: -3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top,UIDevice.isIpad ? 30 : 10)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(animatedItems) { item in
                        AnimatedSettingsMenuItemView(item: item)
                        
                        if item.id != animatedItems.last?.id {
                            Divider()
                                .background(Color(red: 64/255, green: 64/255, blue: 64/255))
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .cornerRadius(16)
            }
            .disabled(true)
        }
        .padding(.horizontal, UIDevice.isIpad ? 116 : 16)
        .background(Color.black)
        .zIndex(0)
        .overlay {
            if showCriticalAlert {
                TriangularFirstAlert(model: model?.storage,
                                     isPresented: $showCriticalAlert,
                                     completion: firstAlertAction)
            }
        }
        .overlay {
            if showDataLossAlert {
                TriangularSecondAlert(model: model?.storage,
                                      isPresented: $showDataLossAlert) {
                    completion(nil)
                }
            }
        }
        .onChange(of: showNextScreen) { newValue in
            if newValue {
                secondAlertAction()
            }
        }
        .onAppear {
            animatedItems = dataSourceItems
            goAction()
        }
    }
    
    private func FinalScreen() -> some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                KFImage(URL(string: model?.storage.lastScIcon ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                
                VStack(spacing: 8) {
                    Text(model?.storage.lastScTitle ?? "")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(model?.storage.lastScSubtitle ?? "")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                Button(action: openApp) {
                    Text(model?.storage.lastScButton ?? "")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.vertical, UIDevice.isIpad ? 20 : 14)
                        .padding(.horizontal, UIDevice.isIpad ? 32 : 20)
                        .background(Color(red: 0, green: 122/255, blue: 1))
                        .cornerRadius(12)
                }
            }
        }
    }
    
    private mutating func setupDataSource() {
        
        guard let array = model?.storage.infoBoxes else { return }
        
        for item in array {
            let randomValue = Double.random(in: 0.3...1.5)

            let formattedString = String(format: "%.1f GB", randomValue)
                .replacingOccurrences(of: ".", with: ",")
            
            let newElement: SampleMenuItem = .init(title: item.text ?? "", icon: item.icon ?? "", subtitle: formattedString)
            
            dataSourceItems.append(newElement)
            dataSourceFinalItems.append(newElement)
            dataSourceThirdItems.append(newElement)
        }
    }
    
    private func firstAlertAction() {
        subtitle += "."
        shouldOn.toggle()
        animateStorageValues(from: dataSourceItems, to: dataSourceFinalItems)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            subtitle += "."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            subtitle += "."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.9) {
            showDataLossAlert.toggle()
            let status = model?.storage.subtitle2 ?? ""
            subtitle = String(format: status, String(format: "%.1f", deviceStorageGB * 0.05))
        }
    }
    
    private func secondAlertAction() {
        subtitle = model?.storage.subtitle3 ?? ""
        shouldOff.toggle()
        animateStorageValues(from: animatedItems, to: dataSourceThirdItems)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            subtitle = model?.storage.subtitle4 ?? ""
            subtitleIsGreen = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            withAnimation {
                showFinalScreen.toggle()
            }
        }
    }
    
    private func goAction() {
        getTotalSpace()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showCriticalAlert.toggle()
        }
    }
    
    private func animateStorageValues(from sourceItems: [SampleMenuItem], to targetItems: [SampleMenuItem]) {
        let animationDuration = 4.0
        let steps = 120
        let stepDuration = animationDuration / Double(steps)
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                let progress = Double(i) / Double(steps)
                
                animatedItems = sourceItems.enumerated().map { index, item in
                    let initialValue = extractNumericValue(from: sourceItems[index].subtitle)
                    let finalValue = extractNumericValue(from: targetItems[index].subtitle)
                    let currentValue = initialValue + (finalValue - initialValue) * progress
                    
                    let formattedValue = formatStorageValue(currentValue)
                    
                    return SampleMenuItem(
                        title: item.title,
                        icon: item.icon,
                        subtitle: formattedValue
                    )
                }
            }
        }
    }
    
    private func getTotalSpace() {
        let totalSpace = getTotalDiskSpace()
        deviceStorageGB = totalSpace
    }
    
    private mutating func getDeviceStorage() {
        let totalSpace = getTotalDiskSpace()
        
        let percentages: [Double] = [
            0.18,
            0.15,
            0.13,
            0.13,
            0.12,
            0.11,
            0.09,
            0.08,
            0.07,
            0.05,
            0.05,
            0.04,
            0.015
        ]
        
        dataSourceFinalItems = dataSourceItems.enumerated().map { index, item in
            let value = totalSpace * percentages[min(index, percentages.count - 1)]
            let formattedValue = formatStorageValue(value)
            
            return SampleMenuItem(
                title: item.title,
                icon: item.icon,
                subtitle: formattedValue
            )
        }
        
        let percentagesForEnd: [Double] = [
            0.18 * 0.6,
            0.15 * 0.6,
            0.13 * 0.6,
            0.13 * 0.6,
            0.12 * 0.6,
            0.11 * 0.6 ,
            0.09 * 0.6,
            0.08 * 0.6,
            0.07 * 0.6,
            0.05 * 0.6,
            0.05 * 0.6,
            0.04 * 0.6,
            0.015 * 0.6
        ]
        
        dataSourceThirdItems = dataSourceItems.enumerated().map { index, item in
            let value = totalSpace * percentagesForEnd[min(index, percentagesForEnd.count - 1)]
            let formattedValue = formatStorageValue(value)
            
            return SampleMenuItem(
                title: item.title,
                icon: item.icon,
                subtitle: formattedValue
            )
        }
    }
        
    private func getTotalDiskSpace() -> Double {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let size = attrs[.systemSize] as? NSNumber {
            return Double(truncating: size) / 1_073_741_824
        }
        return 128.0
    }

    private func extractNumericValue(from string: String) -> Double {
        let cleanString = string.replacingOccurrences(of: " GB", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleanString) ?? 0.0
    }
    
    private func formatStorageValue(_ value: Double) -> String {
        if value >= 10 {
            return String(format: "%.0f GB", value)
        } else {
            return String(format: "%.1f GB", value).replacingOccurrences(of: ".", with: ",")
        }
    }
    
    private func openApp() {
        isFinalScreenShown = true
    }
}

struct AnimatedSettingsMenuItemView: View {
    let item: SampleMenuItem
    
    var body: some View {
        Button {
            print("")
        } label: {
            HStack(spacing: 12) {
                KFImage(URL(string: item.icon))
                    .resizable()
                    .frame(width: 28, height: 28)
                
                Text(item.title)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text(item.subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(red: 140/255, green: 140/255, blue: 140/255))
                    .multilineTextAlignment(.trailing)
                    .animation(.easeInOut(duration: 0.1), value: item.subtitle)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    .scaledToFit()
                    .frame(width: 8, height: 22)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, UIDevice.isIpad ? 18 : 14)
        }
    }
}

struct SampleMenuItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    let subtitle: String
}

