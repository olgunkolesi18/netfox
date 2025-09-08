import Foundation
import SwiftUI
import Kingfisher
import ProgressHUD

struct FastRequestResultSecurityCenterView: View {
    @Binding var isSubscriptionActive: Bool
    @Binding var isRealTimeAntivirusOn: Bool
    @Binding var isSecurityOn: Bool
    @Binding var isBackgroundScanOn: Bool
    @Binding var isPasswordsOn: Bool
    
    @Binding var showStatistics: Bool
    @Binding var isProtected: Bool
    
    let completion: ((EventsTitles?, [String: Any]?) -> Void)?
    let model: AuthorizationOfferModel?
    let tariffButtonTapped: ((Bool) -> Void)
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 5) {
                HStack {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(5)
                            .frame(width: 60, height: 60)
                        
                        KFImage(URL(string: model?.scn?.banner_icon ?? ""))
                            .setProcessor(SVGImgProcessor())
                            .resizable()
                            .frame(width: 46, height: 59)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(model?.scn?.banner_title ?? "")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                        
                        Text(isProtected ? model?.scn?.subtitle_unp_paid ?? "" : model?.scn?.subtitle_unp ?? "")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundStyle(Color(red: 156/255, green: 156/255, blue: 156/255))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    .padding(.leading, 7)
                    
                    Spacer()
                }
                .padding(.all, 5)
                .background(Color(red: 250/255, green: 250/255, blue: 250/255))
                .cornerRadius(10)
                
                VStack {
                    //                HStack(spacing: 5) {
                    FastRequestResultToggleView(title: model?.scn?.features?[0].name ?? "",
                                                activeTitle: model?.scn?.features?[0].g_status ?? "",
                                                disactiveTitle: model?.scn?.features?[0].b_status ?? "",
                                                backColor: .white,
                                                isToggleActive: $isRealTimeAntivirusOn)
//                    .toggleStyle(SymbolToggleStyle())
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            completion?(.specialOffer5T0, nil)
                            tariffButtonTapped(true)
                        }
                        
                        let generator = UINotificationFeedbackGenerator()
                        
                        generator.notificationOccurred(.success)
                    }
                    .onChange(of: isRealTimeAntivirusOn) { value in
                       
                    }
                    
                    FastRequestResultToggleView(title: model?.scn?.features?[1].name ?? "",
                                                activeTitle: model?.scn?.features?[1].g_status ?? "",
                                                disactiveTitle: model?.scn?.features?[1].b_status ?? "",
                                                backColor: .white,
                                                isToggleActive: $isSecurityOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped(true)
                        }
                        
                        let generator = UINotificationFeedbackGenerator()
                        
                        generator.notificationOccurred(.success)
                    }
                    .onChange(of: isSecurityOn) { value in
                        completion?(.specialOffer5T1, nil)
                        
//                        if isSubscriptionActive, value {
//                            let generator = UINotificationFeedbackGenerator()
//                            
//                            generator.notificationOccurred(.success)
//                        } else {
//                            isSheetAnti = false
//                        }
                    }
                    //                }
                    
                    //                HStack(spacing: 5) {
                    FastRequestResultToggleView(title: model?.scn?.features?[2].name ?? "",
                                                activeTitle: model?.scn?.features?[2].g_status ?? "",
                                                disactiveTitle: model?.scn?.features?[2].b_status ?? "",
                                                backColor: .white,
                                                isToggleActive: $isBackgroundScanOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped(true)
                        }
                        
                        let generator = UINotificationFeedbackGenerator()
                        
                        generator.notificationOccurred(.success)
                    }
                    .onChange(of: isBackgroundScanOn) { value in
                        completion?(.specialOffer5T2, nil)
                        
//                        if isSubscriptionActive, value {
//                            let generator = UINotificationFeedbackGenerator()
//                            
//                            generator.notificationOccurred(.success)
//                        }
                    }
                    
                    FastRequestResultToggleView(title: model?.scn?.features?[3].name ?? "",
                                                activeTitle: model?.scn?.features?[3].g_status ?? "",
                                                disactiveTitle: model?.scn?.features?[3].b_status ?? "",
                                                backColor: .white,
                                                isToggleActive: $isPasswordsOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped(true)
                        }
                        
                        let generator = UINotificationFeedbackGenerator()
                        
                        generator.notificationOccurred(.success)
                    }
                    .onChange(of: isPasswordsOn) { value in
                        completion?(.specialOffer5T3, nil)
                        
//                        if isSubscriptionActive, value {
//                            let generator = UINotificationFeedbackGenerator()
//                            
//                            generator.notificationOccurred(.success)
//                        }
                    }
                }
            }
            .padding(.all, 5)
            .background(Color(red: 239/255, green: 239/255, blue: 239/255))
            .cornerRadius(15)
            
            FastRequestResultBoxStatsView(title: model?.scn?.stats?.statBtnTitle ?? "",
                                          subttitle: model?.scn?.stats?.statBtnSubtitle ?? "",
                                          imageUrl: model?.scn?.banner_icon ?? "", //!
                                          backColor: Color(red: 239/255, green: 239/255, blue: 239/255))
            .onTapGesture {
                showStatistics = true
            }
        }
    }
    
    private func showProgressAction() {
        ProgressHUD.animate(interaction: false)
    }
    
    private func showSuccessAction() {
        ProgressHUD.success(interaction: false)
    }
}
