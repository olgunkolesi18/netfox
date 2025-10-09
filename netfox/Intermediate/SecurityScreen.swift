import Foundation
import SwiftUI
import Kingfisher

public struct InterScreen : View {
    var scanObject: Objec
    var scanTitle: String
    var secureScreenNumber: Int
    let completion: ((EventsTitles?, [String: Any]?) -> Void)
    @State private var progress: CGFloat = 0
    @State private var showAlert: Bool = false
    @State private var redStringCount: Int = 0
    @State private var displayedStrings: [Date: Strig] = [:]
    @State private var displayedAntivirusStrings: [Strig] = []
    @State private var isFinalDisplay: Bool = false
    @Binding var showNextScreen: Bool
    @Binding var showDeepScreen: Bool
    @Binding var isDisabled: Bool
    @Binding var isSubscriptionActive: Bool
    private let currentTariff: String
    private let model: AuthorizationOfferModel?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    public init(showNextScreen: Binding<Bool>, showDeepScreen: Binding<Bool>, isSubscriptionActive: Binding<Bool>, isDisabled: Binding<Bool>, model: AuthorizationOfferModel?, currentTariff: String, scanObject: Objec, scanTitle: String, secureScreenNumber: Int, completion: @escaping (EventsTitles?, [String: Any]?) -> Void) {
        self.model = model
        self.currentTariff = currentTariff
        self._isSubscriptionActive = isSubscriptionActive
        self._showNextScreen = showNextScreen
        self._showDeepScreen = showDeepScreen
        self._isDisabled = isDisabled
        self.scanObject = scanObject
        self.scanTitle = scanTitle
        self.secureScreenNumber = secureScreenNumber
        self.completion = completion
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let isIpad = geometry.size.width > 600
            let isLandscape = geometry.size.width > geometry.size.height
            
            content(
                geometry: geometry,
                isIpad: isIpad,
                isLandscape: isLandscape
            )
            .onAppear {
                switch secureScreenNumber {
                case 1:
                    completion(.funnel_a_screen_2_view, nil)
                case 2:
                    completion(.scan2Show, nil)
                case 3:
                    completion(.scan3Show, nil)
                case 4:
                    completion(.scan4Show, nil)
                default:
                    completion(.funnel_a_screen_2_view, nil)
                }
                
                displayStringsWithDelay()
            }
            .onDisappear {
                switch secureScreenNumber {
                case 1:
                    completion(.funnel_a_screen_2_view, nil)
                case 2:
                    completion(.scan2Hide, nil)
                case 3:
                    completion(.scan3Hide, nil)
                case 4:
                    completion(.scan4Hide, nil)
                default:
                    completion(.funnel_a_screen_2_view, nil)
                }
            }
        }
        .fullScreenCover(isPresented: $showNextScreen) {
            FastRequestResultView(isDisabled: $isDisabled, isSubscriptionActive: $isSubscriptionActive, model: model, currentTariff: currentTariff, completion: completion)
        }
    }
    
    private func getCurrentTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.string(from: date)
    }
    
    private func displayStringsWithDelay() {
        displayedStrings = [:]
        displayedAntivirusStrings = []
        progress = 0
        redStringCount = 0
        isFinalDisplay = false
        
        var flCount = 0
        let totalStrings = scanObject.strigs.count
        var cumulativeDelay: TimeInterval = 0
        
        if secureScreenNumber == 2 {
            var localCount = 0
            
            for str in scanObject.strigs {
                if localCount < 3 {
                    flCount += 1
                    if str.color == "red", localCount < 3 {
                        localCount += 1
                    }
                }
            }
        }
        
        for (index, string) in scanObject.strigs.enumerated() {
            guard !showAlert else { break }
            
            let randomDelay = TimeInterval(NFX.sharedInstance().loadingDelay)
            
            cumulativeDelay += randomDelay
            
            switch secureScreenNumber {
            case 4:
                DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay) {
                    guard !showAlert else { return }
                    
                    displayedAntivirusStrings.insert(scanObject.strigs[index], at: 0)
                    withAnimation {
                        progress = (CGFloat(displayedAntivirusStrings.count) / CGFloat(totalStrings)) * 100
                        if index == totalStrings - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isFinalDisplay = true
                            }
                        }
                    }
                }
            case 2:
                if index <= (flCount + 2) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay) {
                        withAnimation {
                            displayedStrings[Date()] = scanObject.strigs[index]
                            progress = (CGFloat(displayedStrings.count) / CGFloat(totalStrings)) * 100
                            if index == (flCount + 2) {
                                showAlert = true
                            }
                        }
                    }
                }
            default:
                DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay) {
                    guard !showAlert else { return }
                    
                    withAnimation {
                        displayedStrings[Date()] = scanObject.strigs[index]
                        progress = (CGFloat(displayedStrings.count) / CGFloat(totalStrings)) * 100
                        if secureScreenNumber == 2, scanObject.strigs[index].color == "red" {
                            redStringCount += 1
                            
                            if redStringCount == 3 {
                                showAlert = true
                            }
                        }
                    }
                }
            }
        }
    }
}

private extension InterScreen {
    func content(
        geometry: GeometryProxy,
        isIpad: Bool,
        isLandscape: Bool
    ) -> some View {
        ZStack {
            Color(red: 242/255, green: 242/255, blue: 242/255).ignoresSafeArea()
            
            VStack(
                spacing: AdaptivePadding.getPadding(
                    for: .spacing,
                    width: geometry.size.width
                )
            ) {
                Text(scanTitle)
                    .font(.system(size: isIpad ? 34 : 24))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(
                        .top,
                        AdaptivePadding.getPadding(
                            for: .titleTopPadding,
                            width: geometry.size.width
                        )
                    )
                
                progress(isIpad: isIpad)
                
                if secureScreenNumber != 4{
                    data(isIpad: isIpad)
                } else {
                    antivirusData(isIpad: isIpad)
                }
            }
            .padding(.vertical, isLandscape ? 10 : 24)
            
            if showAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                switch secureScreenNumber {
                case 1:
                    alert0(isIpad: isIpad)
                        .onAppear {
                            completion(.funnel_a_screen_3_view, nil)
                        }
                case 2:
                    alert1(isIpad: isIpad)
                case 3:
                    alert2(isIpad: isIpad)
                default:
                    alert3(isIpad: isIpad)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func progress(isIpad: Bool) -> some View {
        VStack(spacing: isIpad ? 24 : 15) {
            VStack(spacing: 14) {
                ProgressBar(
                    progress: progress,
                    foregroundColor: Color(red: 0/255, green: 122/255, blue: 255/255),
                    maxValue: scanObject.strigs.count
                ) { currentProgress in
                    switch secureScreenNumber {
                    case 1:
                        if currentProgress >= 95 {
                            showAlert = true
                        }
                    case 2:
                        if currentProgress >= 10 {
                        }
                    case 3:
                        if currentProgress >= 100 {
                            showAlert = true
                        }
                    default:
                        if currentProgress >= 100 {
                            showAlert = true
                        }
                    }
                }
                .frame(height: isIpad ? 27 : 18)
                
                
                Text(scanObject.prgrsTitle)
                    .font(
                        TextUtil().adaptiveFont(
                            textSize: .scanningTextSize,
                            isIpad: isIpad
                        )
                    )
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, isIpad ? 78 : 40)
            .padding(.vertical, isIpad ? 50 : 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
            )
            .padding(.horizontal, isIpad ? 24 : 12)
        }
    }
    
    @ViewBuilder
    func data(isIpad: Bool) -> some View {
        VStack(spacing: 12) {
            ScrollView(showsIndicators: true){
                ForEach(Array(displayedStrings.keys).sorted(by: <), id: \.self) { key in
                    HStack(alignment: .top, spacing: 4) {
                        Text("[\(getCurrentTimeString(date: key))]")
                            .font(
                                TextUtil().adaptiveFont(
                                    textSize: .scanString,
                                    isIpad: isIpad
                                )
                            )
                            .foregroundColor(Color(red: 124/255, green: 124/255, blue: 124/255))
                        
                        if let scanString = displayedStrings[key] {
                            Text(scanString.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .font(
                                    TextUtil().adaptiveFont(
                                        textSize: .scanString,
                                        isIpad: isIpad
                                    )
                                )
                                .foregroundColor(
                                    scanString.color == "red" ? .red : scanString.color == "green" ? .green : .black
                                )
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, isIpad ? 16 : 8)
        .padding(.vertical, isIpad ? 21 : 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal, isIpad ? 24 : 12)
    }
    
    @ViewBuilder
    func antivirusData(isIpad: Bool) -> some View {
        VStack(spacing: 12) {
            ScrollView(showsIndicators: true) {
                ForEach(displayedAntivirusStrings.indices, id: \.self) { index in
                    
                    let string: Strig = displayedAntivirusStrings[index]
                    
                    HStack(alignment: .top, spacing: 10) {
                        
                        KFImage(URL(string: string.icn ?? ""))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 20)
                        
                        VStack(alignment: .leading) {
                            Text("[\(string.name)] \(Text("\(String(describing: index == 0 ? (scanObject.strigsTlt ?? "") : "Finished"))").foregroundColor(.black))")
                                .font(
                                    TextUtil().adaptiveFont(
                                        textSize: .scanString,
                                        isIpad: isIpad
                                    )
                                )
                                .foregroundColor(Color(red: 124/255, green: 124/255, blue: 124/255))
                            
                            if isFinalDisplay {
                                let threats = Int.random(in: 1...3)
                                let count = scanObject.strigsRes?.replacingOccurrences(of: "%", with: "\(threats)") ?? ""
                                Text(count)
                                    .font(
                                        TextUtil().adaptiveFont(
                                            textSize: .scanString,
                                            isIpad: isIpad
                                        )
                                    )
                                    .foregroundColor(.red)
                            } else if index == 0 {
                                let string = scanObject.strigsSubtlt?
                                    .replacingOccurrences(of: "1", with: "\(displayedAntivirusStrings.count)")
                                    .replacingOccurrences(of: "20", with: "\(scanObject.strigs.count)") ?? ""
                                
                                Text(string)
                                    .font(
                                        TextUtil().adaptiveFont(
                                            textSize: .scanString,
                                            isIpad: isIpad
                                        )
                                    )
                                    .foregroundColor(Color(red: 124/255, green: 124/255, blue: 124/255))
                            } else {
                                let threats = Int.random(in: 1...6)
                                let count = scanObject.strigsRes?.replacingOccurrences(of: "%", with: "\(threats)") ?? ""
                                
                                Text(count)
                                    .font(
                                        TextUtil().adaptiveFont(
                                            textSize: .scanString,
                                            isIpad: isIpad
                                        )
                                    )
                                    .foregroundColor(.red)
                                
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, isIpad ? 16 : 16)
                    .padding(.vertical, isIpad ? 19 : 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, isIpad ? 24 : 12)
                }
            }
        }
    }
    
    func alert0(isIpad: Bool) -> some View {
        VStack(spacing: 13) {
            Button {
                showNextScreen = true
                showDeepScreen = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
            }
            .offset(x: isIpad ? 170 : 110)

            VStack(spacing: 8) {
                KFImage(URL(string: scanObject.messIcon))
                    .setProcessor(SVGImgProcessor())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.red)
                
                Text(scanObject.messTlt)
                    .font(.system(size: isIpad ? 22 : 17))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .offset(y: -20)
            
            VStack(spacing: 8) {
                Text(scanObject.subMessTlt ?? "")
                    .font(.system(size: isIpad ? 16 : 13))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(scanObject.subMessTxt ?? "")
                    .font(.system(size: isIpad ? 16: 13))
                    .foregroundColor(Color(red: 110/255, green: 112/255, blue: 101/255))
                    .lineLimit(4)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.06))
            )
            .padding(.horizontal, 16)
            
            Text(scanObject.messSbtlt ?? "")
                .font(.system(size: isIpad ? 16 : 13))
                .lineLimit(4)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            
            VStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: 1).background(Color(red: 60/255, green: 60/255, blue: 67/255, opacity: 0.36))
                
                Button {
                    completion(.scan1Action, nil)
                    if !isSubscriptionActive {
                        completion(.funnel_a_subscription_start, nil)
                        
                        completion(nil, nil)
                    }
                    
                    showDeepScreen = false
                } label: {
                    Text(scanObject.messBtn)
                        .font(.system(size: isIpad ? 22 : 17))
                        .foregroundColor(.blue)
                        .padding(.vertical, 19)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .disabled(isDisabled)
            }
        }
        .padding(.top, 19)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 223/255, green: 223/255, blue: 223/255))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
        )
        .frame(width: isIpad ? 400 : 270)
        
    }
    
    func alert1(isIpad: Bool) -> some View {
        VStack(spacing: 13) {
            Button {
                showNextScreen = true
                showDeepScreen = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
            }
            .offset(x: isIpad ? 170 : 110)
            
            VStack(spacing: 8) {
                KFImage(URL(string: scanObject.messIcon))
                    .setProcessor(SVGImgProcessor())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.red)
                
                Text(scanObject.messTlt)
                    .font(.system(size: isIpad ? 22 : 17))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(scanObject.messTltPrc ?? "")
                    .font(.system(size: isIpad ? 16 : 13))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 16)
            .offset(y: -20)
            
            VStack(spacing: 8) {
                Text(scanObject.subMessTlt ?? "")
                    .font(.system(size: isIpad ? 16 : 13))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("\(scanObject.subMessTxtOne ?? "") \(scanObject.subMessTxtTwo ?? "") \(scanObject.subMessTxtThree ?? "")")
                    .font(.system(size: isIpad ? 16: 13))
                    .foregroundColor(Color(red: 110/255, green: 112/255, blue: 101/255))
                    .lineLimit(4)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.06))
            )
            .padding(.horizontal, 16)
            
            Text(scanObject.messSbtlt ?? "")
                .font(.system(size: isIpad ? 16 : 13))
                .lineLimit(4)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            
            VStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: 1).background(Color(red: 60/255, green: 60/255, blue: 67/255, opacity: 0.36))
                
                Button {
                    completion(.scan2Action, nil)
                    completion(nil, nil)
                } label: {
                    Text(scanObject.messBtn)
                        .font(.system(size: isIpad ? 22 : 17))
                        .foregroundColor(.blue)
                        .padding(.vertical, 19)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .disabled(isDisabled)
            }
        }
        .padding(.top, 19)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 223/255, green: 223/255, blue: 223/255))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
        )
        .frame(width: isIpad ? 400 : 270)
        
    }
    
    func alert2(isIpad: Bool) -> some View {
        VStack(spacing: 13) {
            Button {
                showNextScreen = true
                showDeepScreen = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
            }
            .offset(x: isIpad ? 170 : 110)
            
            VStack(spacing: 8) {
                KFImage(URL(string: scanObject.messIcon))
                    .setProcessor(SVGImgProcessor())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.red)
                
                Text(scanObject.messTlt)
                    .font(.system(size: isIpad ? 22 : 17))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(scanObject.messTltCmpl ?? "")
                    .font(.system(size: isIpad ? 16 : 13))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 16)
            .offset(y: -20)
            
            Text(scanObject.messSbtlt ?? "")
                .font(.system(size: isIpad ? 16 : 13))
                .lineLimit(4)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            
            VStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: 1).background(Color(red: 60/255, green: 60/255, blue: 67/255, opacity: 0.36))
                
                Button {
                    completion(.scan3Action, nil)
                    completion(nil, nil)
                } label: {
                    Text(scanObject.messBtn)
                        .font(.system(size: isIpad ? 22 : 17))
                        .foregroundColor(.blue)
                        .padding(.vertical, 19)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .disabled(isDisabled)
            }
        }
        .padding(.top, 19)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 223/255, green: 223/255, blue: 223/255))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
        }
        .frame(width: isIpad ? 400 : 270)
        
    }
    
    func alert3(isIpad: Bool) -> some View {
        VStack(spacing: 13) {
            Button {
                showNextScreen = true
                showDeepScreen = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
            }
            .offset(x: isIpad ? 170 : 110)
            
            VStack(spacing: 8) {
                KFImage(URL(string: scanObject.messIcon))
                    .setProcessor(SVGImgProcessor())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.red)
                
                Text(scanObject.messTlt)
                    .font(.system(size: isIpad ? 22 : 17))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .offset(y: -20)
            
            VStack(spacing: 8) {
                displayAntivirusMessageTitleCompletion(
                    messageTitleCompletion: scanObject.messTltCmpl,
                    messageTitleRed: scanObject.messTltRed,
                    isIpad: isIpad
                )
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.06))
            )
            .padding(.horizontal, 16)
            
            Text(scanObject.messSbtlt ?? "")
                .font(.system(size: isIpad ? 16 : 13))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            
            VStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: 1).background(Color(red: 60/255, green: 60/255, blue: 67/255, opacity: 0.36))
                
                Button {
                    completion(.scan4Action, nil)
                    completion(nil, nil)
                } label: {
                    Text(scanObject.messBtn)
                        .font(.system(size: isIpad ? 22 : 17))
                        .foregroundColor(.blue)
                        .padding(.vertical, 19)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .disabled(isDisabled)
            }
        }
        .padding(.top, 19)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 223/255, green: 223/255, blue: 223/255))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
        )
        .frame(width: isIpad ? 400 : 270)
        
    }
    
    @ViewBuilder
    func displayAntivirusMessageTitleCompletion(
        messageTitleCompletion: String?,
        messageTitleRed: [String]?,
        isIpad: Bool
    ) -> some View {
        if let completion = messageTitleCompletion, !completion.isEmpty {
            if let redWords = messageTitleRed, !redWords.isEmpty {
                formattedMessageTitle(
                    messageTitleCompletion: completion,
                    messageTitleRed: redWords
                )
                .font(.system(size: isIpad ? 16: 13))
                .foregroundColor(Color(red: 110/255, green: 112/255, blue: 101/255))
                .multilineTextAlignment(.center)
            } else {
                Text(completion)
                    .font(.system(size: isIpad ? 16: 13))
                    .foregroundColor(Color(red: 110/255, green: 112/255, blue: 101/255))
                    .multilineTextAlignment(.center)
            }
        } else {
            Text("")
                .font(.system(size: isIpad ? 16: 13))
                .foregroundColor(Color(red: 110/255, green: 112/255, blue: 101/255))
                .multilineTextAlignment(.center)
        }
    }
    
    private func formattedMessageTitle(
        messageTitleCompletion: String,
        messageTitleRed: [String]
    ) -> Text {
        var remainingText = messageTitleCompletion
        var attributedText = Text("")
        
        for redWord in messageTitleRed {
            if let range = remainingText.range(of: redWord) {
                let beforeRed = String(remainingText[..<range.lowerBound])
                if !beforeRed.isEmpty {
                    attributedText = attributedText + Text(beforeRed)
                }
                
                attributedText = attributedText + Text(redWord).foregroundColor(.red)
                
                remainingText = String(remainingText[range.upperBound...])
            }
        }
        
        if !remainingText.isEmpty {
            attributedText = attributedText + Text(remainingText)
        }
        
        return attributedText
    }
}
