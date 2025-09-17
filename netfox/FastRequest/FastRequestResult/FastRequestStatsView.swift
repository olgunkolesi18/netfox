import Foundation
import SwiftUI
import Kingfisher

struct StatisticItem {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
}

struct StatisticsPopupView: View {
    @Binding var isPresented: Bool
    
    let title: String
    let titleIcon: String
    let subtitle: String
    let statistics: [StatisticItem]
    let closeButtonTitle: String
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissView()
                }
                .opacity(showContent ? 1 : 0)
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    KFImage(URL(string: titleIcon))
                        .setProcessor(SVGImgProcessor())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 24)
                .padding(.bottom, 20)
                
                // Statistics List
                VStack(spacing: 0) {
                    ForEach(Array(statistics.enumerated()), id: \.offset) { index, stat in
                        StatisticRow(
                            icon: stat.icon,
                            title: stat.title,
                            value: stat.value,
                            iconColor: stat.iconColor
                        )
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: showContent)
                        
                        if index < statistics.count - 1 {
                            Divider()
                                .padding(.leading, 65)
                        }
                    }
                }
                .background(.white)
                .cornerRadius(8)
                .padding(.horizontal, 16)
                
                // Close Button
                Button(action: dismissView) {
                    Text(closeButtonTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.clear)
                        .cornerRadius(16)
                }
                .padding(.top, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 242/255, green: 241/255, blue: 246/255))
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 40)
            .scaleEffect(showContent ? 1 : 0.8)
            .opacity(showContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showContent = true
            }
        }
    }
    
    private func dismissView() {
        withAnimation(.easeIn(duration: 0.25)) {
            showContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isPresented = false
        }
    }
}

// MARK: - Statistic Row Component
struct StatisticRow: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            KFImage(URL(string: icon))
                .setProcessor(SVGImgProcessor())
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)

            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(red: 156/255, green: 156/255, blue: 156/255))
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
    }
}
