import SwiftUI
import Kingfisher
import ScreenShield

public struct FRType1Scr1: View {
    
    @State private var deviceStorageGB: Double = 0
    @State private var showAlert = false
    @State private var showLoader = true
    @State private var show2Screen = false
    
    @Binding var showNextScreen: Bool
    @Binding var isFinalScreenShown: Bool
    
    private let model: AuthorizationOfferModel?
    private let completion: ((EventsTitles?, [String: Any]?) -> Void)
    
    public init(model: AuthorizationOfferModel?, showNextScreen: Binding<Bool>, isFinalScreenShown: Binding<Bool>, completion: @escaping ((EventsTitles?, [String: Any]?) -> Void)) {
        
        self.model = model
        self.completion = completion
        self._showNextScreen = showNextScreen
        self._isFinalScreenShown = isFinalScreenShown
    }
    
    public var body: some View {
        if !NFX.sharedInstance().isShow {
            myView()
                .protectScreenshot()
                .onAppear {
                    ScreenShield.shared.protectFromScreenRecording()
                }
        } else {
            myView()
        }
    }
        
    private func myView() -> some View {
        VStack(spacing: 10) {
            VStack {
                Text(model?.storage1Scr.title ?? "")
                    .font(.system(size: UIDevice.isIpad ? 20 : 17, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, UIDevice.isIpad ? 50 : 10)
            
            StorageUsageNewView(model: model, totalStorage: $deviceStorageGB)
                .padding(.top, 5)
            
            HStack(spacing: 9) {
                Spacer()
                
                Text(model?.storage1Scr.sizeText ?? "")
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
            
            if showLoader {
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.white)
                        .scaleEffect(1.5)
                        .frame(width: 30, height: 30)
                    
                    Text(model?.storage1Scr.subtitle ?? "")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.top, 130)
            }
            
            Spacer()
        }
        .padding(.horizontal, UIDevice.isIpad ? 116 : 16)
        .background(Color.black)
        .zIndex(0)
        .overlay {
            if showAlert {
                NewTriangularFirstAlert(model: model,
                                        isPresented: $showAlert,
                                        completion: firstAlertAction)
            }
        }
        .onAppear {
            goAction()
        }
        .fullScreenCover(isPresented: $show2Screen) {
            FRType1Scr2(model: model,
                        showNextScreen: $showNextScreen,
                        isFinalScreenShown: $isFinalScreenShown,
                        completion: completion)
        }
    }
    
    private func firstAlertAction() {
        show2Screen = true
    }
    
    private func goAction() {
        getTotalSpace()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showAlert.toggle()
            showLoader.toggle()
        }
    }
    
    private func getTotalSpace() {
        let totalSpace = getTotalDiskSpace()
        deviceStorageGB = totalSpace
    }
    
    private func getTotalDiskSpace() -> Double {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let size = attrs[.systemSize] as? NSNumber {
            return Double(truncating: size) / 1_073_741_824
        }
        return 128.0
    }
}

