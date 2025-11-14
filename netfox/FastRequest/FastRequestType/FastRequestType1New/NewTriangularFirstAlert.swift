import SwiftUI
import Kingfisher

struct NewTriangularFirstAlert: View {
    @Binding var isPresented: Bool
    let onButtonTapped: () -> Void
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    private let model: AuthorizationOfferModel?
    
    init(model: AuthorizationOfferModel?, isPresented: Binding<Bool>, completion: @escaping () -> Void) {
        self.model = model
        self._isPresented = isPresented
        onButtonTapped = completion
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                KFImage(URL(string: model?.storage1Scr.firstAlert.icon ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack(spacing: 6) {
                    Text(model?.storage1Scr.firstAlert.title ?? "")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text(model?.storage1Scr.firstAlert.subtitle ?? "")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                .padding(.top, 12)
                .padding(.bottom, 15)
                .padding(.horizontal, 20)
                
                Divider()
                    .background(Color(red: 128/255, green: 128/255, blue: 128/255, opacity: 0.55))
                
                Button(model?.storage1Scr.firstAlert.button ?? "") {
                    onButtonTapped()
                    dismissAlert()
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color(red: 0, green: 122/255, blue: 1))
                .padding(.top, 11)
                .padding(.bottom, 14)
                .padding(.horizontal, 30)
                .background(Color.clear)
            }
            .padding(.top, 21)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 179/255, green: 179/255, blue: 179/255, opacity: 1))
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 50)
            .scaleEffect(scale)
            .opacity(opacity)
            .frame(width:  UIDevice.isIpad ? 400 : nil)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    private func dismissAlert() {
        withAnimation(.easeIn(duration: 0.2)) {
            scale = 0.8
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }
}

