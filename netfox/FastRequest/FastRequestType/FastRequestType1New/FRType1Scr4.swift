import SwiftUI
import Kingfisher
import ScreenShield

struct FRType1Scr4: View {
    @State private var displayedStrings: [Date: Storage4ScrStrig] = [:]
    @State private var show5Screen = false
    
    @Binding var isFinalScreenShown: Bool
    
    private let model: AuthorizationOfferModel?
    
    public init(model: AuthorizationOfferModel?, isFinalScreenShown: Binding<Bool>) {
        
        self.model = model
        self._isFinalScreenShown = isFinalScreenShown
    }

    var body: some View {
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
        ZStack {
            FirstScreen()
                .compositingGroup()
                .allowsHitTesting(!show5Screen)
                .zIndex(0)
            
            FinalScreen()
                .compositingGroup()
                .opacity(show5Screen ? 1 : 0)
                .allowsHitTesting(show5Screen)
                .zIndex(1)
        }
    }
    
    private func FirstScreen() -> some View {
        VStack(spacing: 12) {
            Text(model?.storage4Scr.title ?? "System Log")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .padding(.vertical, 10)
            
            logScrollView
        }
        .background(Color.black)
        .task {
            await startLogSequence()
        }
    }
    
    private var logScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(displayedStrings.sorted(by: { $0.key < $1.key }), id: \.key) { key, logEntry in
                        gLogRow(logEntry, at: key)
                    }
                }
                .padding(.top, 24)
            }
            .disabled(true)
            .onChange(of: displayedStrings) { _ in
                if let lastKey = displayedStrings.keys.sorted().last {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(lastKey, anchor: .bottom)
                    }
                }
            }
        }
        .font(.system(size: 13, weight: .regular, design: .monospaced))
        .padding(.horizontal, 24)
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .cornerRadius(20)
        .padding(16)
        .frame(maxHeight: .infinity)
    }

    private func gLogRow(_ entry: Storage4ScrStrig, at key: Date) -> some View {
        HStack(alignment: .top, spacing: 5) {
            Text("[\(getCurrentTimeString(date: key))]")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(red: 124/255, green: 124/255, blue: 124/255))
            
            Text(entry.name ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(logColor(for: entry.color ?? ""))
        }
        .id(key)
    }
    
    private func FinalScreen() -> some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                KFImage(URL(string: model?.storage5Scr.lastScIcon ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                
                Text(model?.storage5Scr.lastScTitle ?? "")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                
                VStack(spacing: 20) {
                    FinalScreenInfoRow(
                        iconName: model?.storage5Scr.lastScBoxImg1 ?? "",
                        title: model?.storage5Scr.lastScBoxTitle1 ?? "",
                        subtitleFirstPart: model?.storage5Scr.lastScBoxText1 ?? "",
                        subtitleSecondPart: model?.storage5Scr.lastScBoxTextGreen1 ?? ""
                    )
                    .padding(.top, 24)
                    
                    Rectangle()
                        .fill(Color(red: 61/255, green: 62/255, blue: 65/255))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                    
                    FinalScreenInfoRow(
                        iconName: model?.storage5Scr.lastScBoxImg2 ?? "",
                        title: model?.storage5Scr.lastScBoxTitle2 ?? "",
                        subtitleFirstPart: model?.storage5Scr.lastScBoxText2 ?? "",
                        subtitleSecondPart: model?.storage5Scr.lastScBoxTextGreen2 ?? ""
                    )
                    
                    Rectangle()
                        .fill(Color(red: 61/255, green: 62/255, blue: 65/255))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                    
                    FinalScreenInfoRow(
                        iconName: model?.storage5Scr.lastScBoxImg3 ?? "",
                        title: model?.storage5Scr.lastScBoxTitle3 ?? "",
                        subtitleFirstPart: model?.storage5Scr.lastScBoxText3 ?? "",
                        subtitleSecondPart: model?.storage5Scr.lastScBoxTextGreen3 ?? ""
                    )
                    .padding(.bottom, 24)
                }
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .cornerRadius(10)
                
                Button(action: openApp) {
                    Text(model?.storage5Scr.lastScButton ?? "")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 172)
                        .frame(height: 50)
                        .background(Color(red: 0, green: 122/255, blue: 1))
                        .cornerRadius(25)
                }
                .padding(.top, 40)
                
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 16)
        }
    }
        
    private func startLogSequence() async {
        displayedStrings.removeAll()
        
        guard let logs = model?.storage4Scr.strigs else { return }
        
        for logEntry in logs {
            displayedStrings[Date()] = logEntry
            
            let randomDelay = Double.random(in: 0.05...0.1)

            try? await Task.sleep(nanoseconds: UInt64(randomDelay * 1_000_000_000))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                show5Screen.toggle()
            }
        }
    }

    private func logColor(for colorName: String) -> Color {
        switch colorName.lowercased() {
        case "green": Color(red: 52/255, green: 199/255, blue: 98/255)
        default: .white
        }
    }
    
    private func getCurrentTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func openApp() {
        isFinalScreenShown = true
    }
}


struct FinalScreenInfoRow: View {
    let iconName: String
    let title: String
    let subtitleFirstPart: String
    let subtitleSecondPart: String
    
    var body: some View {
        HStack(spacing: 19) {
            KFImage(URL(string: iconName))
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .fixedSize()
            
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                (
                    Text(subtitleFirstPart)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                    +
                    Text(subtitleSecondPart)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(red: 52/255, green: 199/255, blue: 89/255))
                )
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.horizontal, 21)
    }
}


