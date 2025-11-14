import SwiftUI
import Kingfisher
import ScreenShield

struct FRType1Scr3: View {
    @State private var show4Screen = false
    
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
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text(model?.storage3Scr.title ?? "")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                
                HStack {
                    Text(model?.storage3Scr.subtitle ?? "")
                        .foregroundColor(Color(white: 0.6))
                        .font(.subheadline)
                        .padding(.leading, 4)
                    
                    Spacer()
                }
                .padding(.top, 6)
                .padding(.bottom, 8)
                
                topBoxView
                    .padding(.bottom, 16)
                    
                lowBoxView
                
                Spacer(minLength: 5)
            }
            .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $show4Screen) {
            FRType1Scr4(model: model,
                        isFinalScreenShown: $isFinalScreenShown)
        }
        .onChange(of: showNextScreen) { newValue in
            if newValue {
                show4Screen = true
            }
        }
    }
    
    private var topBoxView: some View {
        VStack(spacing: 0) {
            FRType1Scr3TopBoxRow(
                title: model?.storage3Scr.topBox.title1 ?? "",
                subtitle: model?.storage3Scr.topBox.subtitle1 ?? "")
            .padding(.top, 4)
            
            Rectangle()
                .fill(Color(red: 56/255, green: 56/255, blue: 56/255))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            FRType1Scr3TopBoxRow(
                title: model?.storage3Scr.topBox.title2 ?? "",
                subtitle: model?.storage3Scr.topBox.subtitle2 ?? "")
            
            Rectangle()
                .fill(Color(red: 56/255, green: 56/255, blue: 56/255))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            FRType1Scr3TopBoxRow(
                title: model?.storage3Scr.topBox.title3 ?? "",
                subtitle: model?.storage3Scr.topBox.subtitle3 ?? "")
            
            Rectangle()
                .fill(Color(red: 56/255, green: 56/255, blue: 56/255))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            FRType1Scr3TopBoxRow(
                title: model?.storage3Scr.topBox.title4 ?? "",
                subtitle: model?.storage3Scr.topBox.subtitle4 ?? "")
            .padding(.bottom, 4)
        }
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .cornerRadius(10)
    }
    
    private var lowBoxView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 21) {
                KFImage(URL(string: model?.storage1Scr.firstAlert.icon ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(model?.storage3Scr.lowBox.title ?? "")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(model?.storage3Scr.lowBox.subtitle ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 156/255, green: 156/255, blue: 156/255))
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 18)
            
            ViewThatFits(in: .vertical) {
                itemsListVStack
                
                ScrollView(.vertical, showsIndicators: false) {
                    itemsListVStack
                }
            }
            
            Rectangle()
                .fill(Color(red: 61/255, green: 61/255, blue: 65/255))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 21)
            
            Button(action: buttonAction) {
                Text(model?.storage3Scr.lowBox.button ?? "")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0, green: 122/255, blue: 1))
                    .cornerRadius(25)
            }
            .padding(.horizontal, 43)
            .padding(.bottom, 24)
            
        }
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .cornerRadius(10)
    }
    
    private var itemsListVStack: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(model?.storage3Scr.lowBox.items ?? [], id: \.self) { item in
                HStack {
                    Text(item ?? "")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 40)
                        .padding(.leading, 28)
                    
                    Spacer()
                }
            }
        }
    }
    
    private func buttonAction() {
        completion(nil, nil)
    }
}


struct FRType1Scr3TopBoxRow: View {
    let title: String?
    let subtitle: String?
    
    var body: some View {
        if let title = title, let subtitle = subtitle {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 231/255, green: 68/255, blue: 68/255))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

