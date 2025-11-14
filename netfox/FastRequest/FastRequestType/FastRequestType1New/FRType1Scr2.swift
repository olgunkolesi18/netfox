import SwiftUI
import ScreenShield

struct FRType1Scr2: View {
    @State private var displayedStrings: [Date: Storage2ScrStrig] = [:]
    @State private var show3Screen = false
    
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
        VStack(spacing: 12) {
            Text(model?.storage2Scr.title ?? "")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .padding(.vertical, 10)
            
            logScrollView
        }
        .background(Color.black)
        .task {
            await startLogSequence()
        }
        .fullScreenCover(isPresented: $show3Screen) {
            FRType1Scr3(model: model,
                        showNextScreen: $showNextScreen,
                        isFinalScreenShown: $isFinalScreenShown,
                        completion: completion)
        }
    }
    
    private var logScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(displayedStrings.sorted(by: { $0.key < $1.key }), id: \.key) { key, logEntry in
                        rLogRow(logEntry, at: key)
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

    private func rLogRow(_ entry: Storage2ScrStrig, at key: Date) -> some View {
        HStack(alignment: .top, spacing: 5) {
            Text("[\(getCurrentTimeString(date: key))]")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(red: 124/255, green: 124/255, blue: 124/255))
            (
                Text(entry.firstName ?? "")
                    .foregroundColor(.white)
                + Text(entry.secondName ?? "")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(red: 255/255, green: 56/255, blue: 60/255))
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
        }
        .id(key)
    }
    
    private func startLogSequence() async {
        displayedStrings.removeAll()
        
        guard let logs = model?.storage2Scr.strigs else { return }
        
        for logEntry in logs {
            displayedStrings[Date()] = logEntry
            
            let randomDelay = Double.random(in: 0.05...0.1)
            
            try? await Task.sleep(nanoseconds: UInt64(randomDelay * 1_000_000_000))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            show3Screen = true
        }
    }

    private func getCurrentTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}

