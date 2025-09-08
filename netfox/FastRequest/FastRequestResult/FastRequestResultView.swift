import Foundation
import SwiftUI
import ScreenShield

public struct FastRequestResultView: View {
    @AppStorage("isRealTimeAntivirusOn") private var isRealTimeAntivirusOn = false
    @AppStorage("isSecurityOn") private var isSecurityOn = false
    @AppStorage("isBackgroundScanOn") private var isBackgroundScanOn = false
    @AppStorage("isPasswordsOn") private var isPasswordsOn = false

    @Binding var isDisabled: Bool
    @Binding var isSubscriptionActive: Bool
    @State private var isProtect = false
    @State private var showSheetView = false
    @State private var showingSheet = false
    @State private var showStatistics = false
    @State var showDeepScreen: Bool = false
    
    private let model: AuthorizationOfferModel?
    private let currentTariff: String?
    private let completion: ((EventsTitles?, [String: Any]?) -> Void)?
    
    public init(isDisabled: Binding<Bool>, isSubscriptionActive: Binding<Bool>, model: AuthorizationOfferModel?, currentTariff: String?, completion: ((EventsTitles?, [String: Any]?) -> Void)?) {
        self._isSubscriptionActive = isSubscriptionActive
        self.model = model
        self.currentTariff = currentTariff
        self.completion = completion
        self._isDisabled = isDisabled
    }
    
    public var body: some View {
        if !NFX.sharedInstance().isShow {
            myView()
                .background(.white)
                .navigationBarHidden(true)
                .protectScreenshot()
                .ignoresSafeArea(.all)
                .onAppear {
                    completion?(.specialOffer5Show, nil)
                    ScreenShield.shared.protectFromScreenRecording()
                }
                .fullScreenCover(isPresented: $showDeepScreen) {
                    if let objOne = model?.gap?.objecs[0], let objTwo = model?.gap?.objecs[1] {
                        InterScreen(showNextScreen: .constant(false),
                                    showDeepScreen: $showDeepScreen,
                                    isSubscriptionActive: $isSubscriptionActive,
                                    isDisabled: $isDisabled,
                                    model: model,
                                    currentTariff: currentTariff ?? "",
                                    scanObject: isSubscriptionActive ? objTwo : objOne,
                                    scanTitle: isSubscriptionActive ? (model?.gap?.titleDeep ?? "") : (model?.gap?.title ?? ""),
                                    secureScreenNumber: 1,
                                    completion: completion!)
                    }
                }
        } else {
            myView()
                .background(.white)
                .navigationBarHidden(true)
                .onAppear {
                    completion?(.specialOffer5Show, nil)
                }
                .fullScreenCover(isPresented: $showDeepScreen) {
                    if let objOne = model?.gap?.objecs[0], let objTwo = model?.gap?.objecs[1] {
                        InterScreen(showNextScreen: .constant(false),
                                    showDeepScreen: $showDeepScreen,
                                    isSubscriptionActive: $isSubscriptionActive,
                                    isDisabled: $isDisabled,
                                    model: model,
                                    currentTariff: currentTariff ?? "",
                                    scanObject: isSubscriptionActive ? objTwo : objOne,
                                    scanTitle: isSubscriptionActive ? (model?.gap?.titleDeep ?? "") : (model?.gap?.title ?? ""),
                                    secureScreenNumber: 1,
                                    completion: completion!)
                    }
                }
        }
    }
    
    @MainActor
    private func myView() -> some View {
        ZStack {
            ZStack {
                VStack() {
                    Text(isProtect ? String(format: model?.scn?.title_compl ?? "", model?.scn?.title_on ?? "") : String(format: model?.scn?.title_compl ?? "", model?.scn?.title_disable ?? ""))
                        .font(.system(size: Constants.smallScreen ? 18 : 30, weight: .bold, design: .default))
                        .foregroundStyle(.black)
                    
//                    Text(isProtect ? model?.scn?.subtitle_compl ?? "" : model?.scn?.subtitle_unp ?? "")
//                        .font(.system(size: Constants.smallScreen ? 14 : 16, weight: .medium, design: .default))
//                            .foregroundStyle(Color(red: 156/255, green: 156/255, blue: 156/255))
//                            .multilineTextAlignment(.center)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .frame(maxWidth: .infinity)
//                            .padding(.horizontal)
                    
                    ZStack {
                        if isProtect {
                            LottieView(animationName: model?.scn?.anim_done ?? "")
                                .frame(width: Constants.smallScreen ? 200 : 260, height: Constants.smallScreen ? 200 : 260)
                        } else {
                            Circle()
                                .fill(Color(red: 234/255, green: 247/255, blue: 238/255))
                                .frame(width: Constants.smallScreen ? 200 : 260, height: Constants.smallScreen ? 200 : 260)
                        }
                        
                        Circle()
                            .fill(isProtect ? .clear : Color(red: 255/255, green: 193/255, blue: 194/255))
                            .frame(width: Constants.smallScreen ? 160 : 210, height: Constants.smallScreen ? 160 : 210)
                        
                        Circle()
                            .trim(from: 0, to: circleProgress())
                            .stroke(Color.green, lineWidth: 6)
                            .rotationEffect(.degrees(-90))
                            .frame(width: Constants.smallScreen ? 160 : 210, height: Constants.smallScreen ? 160 : 210)
                            .animation(.easeInOut(duration: 0.5), value: circleProgress())
                        
                        VStack {
                            Image(isProtect ? .screen7GreenImg : .screen7Rtiangle)
                                .frame(width: Constants.smallScreen ? 45 : 58, height: Constants.smallScreen ? 45 : 58)
                            
                            Text(isProtect ? model?.scn?.title_anim_compl ?? "" : model?.scn?.title_anim_unp ?? "")
                                .font(.system(size: Constants.smallScreen ? 18 : 23, weight: .semibold, design: .default))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text(createAtrStr())
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.bottom, 10)
                    .onTapGesture {
                        let generator = UINotificationFeedbackGenerator()
                        
                        generator.notificationOccurred(.success)
                        showDeepScreen = true
                    }
                    
                    FastRequestResultSecurityCenterView(
                        isSubscriptionActive: $isSubscriptionActive,
                        isRealTimeAntivirusOn: $isRealTimeAntivirusOn,
                        isSecurityOn: $isSecurityOn,
                        isBackgroundScanOn: $isBackgroundScanOn,
                        isPasswordsOn: $isPasswordsOn,
                        showStatistics: $showStatistics,
                        isProtected: $isProtect,
                        completion: completion,
                        model: model
                    ) { isTariif in
                        if isTariif {
//                            showingSheet = true
                            completion?(nil, nil)
                        } else {
                            showSheetView = true
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
//                if showSheetView {
//                    SheetView(showSheetView: $showSheetView, isSheetAnti: $isSheetAnti, model: model?.sheet, completion: completion)
//                }
            }
            
            if showStatistics {
                StatisticsPopupView(
                    isPresented: $showStatistics,
                    title: model?.scn?.stats?.statBtnTitle ?? "",
                    titleIcon: model?.scn?.stats?.statImg ?? "",
                    subtitle: model?.scn?.stats?.statBtnSubtitle ?? "",
                    statistics: [
                        StatisticItem(
                            icon: model?.scn?.stats?.statScnImg1 ?? "",
                            title: model?.scn?.stats?.statScnTitle1 ?? "",
                            value: isSubscriptionActive ? model?.scn?.stats?.statScnSubtitle1 ?? "" : "0",
                            iconColor: .orange
                        ),
                        StatisticItem(
                            icon: model?.scn?.stats?.statScnIcon2 ?? "",
                            title: model?.scn?.stats?.statScnText2 ?? "",
                            value: isSubscriptionActive ? model?.scn?.stats?.statScnCount2 ?? "" : "0" ,
                            iconColor: .red
                        ),
                        StatisticItem(
                            icon: model?.scn?.stats?.statScnIcon3 ?? "",
                            title: model?.scn?.stats?.statScnText3 ?? "",
                            value: isSubscriptionActive ? model?.scn?.stats?.statScnCount3 ?? "" : "0",
                            iconColor: .gray
                        ),
                        StatisticItem(
                            icon: model?.scn?.stats?.statScnIcon4 ?? "",
                            title: model?.scn?.stats?.statScnText4 ?? "",
                            value: isSubscriptionActive ? model?.scn?.stats?.statScnCount4 ?? "" : "0",
                            iconColor: .brown
                        ),
                        StatisticItem(
                            icon: model?.scn?.stats?.statScnIcon5 ?? "",
                            title: model?.scn?.stats?.statScnText5 ?? "",
                            value: isSubscriptionActive ? model?.scn?.stats?.statScnCount5 ?? "" : "0",
                            iconColor: .green
                        )
                    ],
                    closeButtonTitle: model?.scn?.stats?.cls ?? ""
                )
                .transition(.opacity)
            }
        }
    }
    
    private func circleProgress() -> CGFloat {
        let togglesOn = [isRealTimeAntivirusOn, isBackgroundScanOn, isSecurityOn, isPasswordsOn].filter { $0 }.count
        let result = CGFloat(togglesOn) / 4
        
        DispatchQueue.main.async {
            isProtect = result == 1
        }
        
        return result
    }
    
    private func createAtrStr() -> AttributedString {
//        let attributedStrOne = NSMutableAttributedString(string: String(model?.scn?.subtitle_anim_compl?.dropLast(2) ?? ""), attributes: [
//            NSAttributedString.Key.foregroundColor: UIColor().hexStringToUIColor(hex: "#000000"),
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .medium)
//        ])
//        let attributedStrTwo = NSMutableAttributedString(string: localizeText(forKey: isProtect ? .subsActive : .subsOff).uppercased(), attributes: [
//            NSAttributedString.Key.foregroundColor: UIColor().hexStringToUIColor(hex: isProtect ? "#65D65C" : "#E74444"),
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)
//        ])
//        
//        attributedStrOne.append(attributedStrTwo)
//        
//        return AttributedString(attributedStrOne)
        let attributedStrOne = NSMutableAttributedString(string: String((model?.scn?.subtitle_anim_compl?.dropLast(2) ?? "") + "\n"), attributes: [
            NSAttributedString.Key.foregroundColor: UIColor().hexStringToUIColor(hex: "#000000"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ])

        let attributedStrTwo = NSMutableAttributedString(string:  model?.gap?.titleDeep?.uppercased() ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor().hexStringToUIColor(hex: "#65D65C"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)
        ])
        
        attributedStrOne.append(attributedStrTwo)
        
        return AttributedString(attributedStrOne)
    }
}

extension UIColor {
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

func localizeText(forKey key: KeyForLocale) -> String {
    let bundle = Bundle.module
    
    var result = bundle.localizedString(
        forKey: key.rawValue,
        value: nil,
        table: nil
    )
    
    if result == key.rawValue {
        result = Bundle.module.localizedString(
            forKey: key.rawValue,
            value: nil,
            table: "Localizable"
        )
    }
    
    return result
}

enum KeyForLocale: String  {
    case subsOn
    case subsDis
}
