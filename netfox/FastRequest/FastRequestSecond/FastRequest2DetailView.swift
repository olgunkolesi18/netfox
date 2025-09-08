
import SwiftUI
import Kingfisher
import ScreenShield

//public struct FastRequest2DetailView: View {
//    @State private var showAlert = false
//    @State private var showNotification = false
//    @State var showIntermediateScreen: Bool = false
//    @Binding var showNextScreen: Bool
//    @Binding var isSubscriptionActive: Bool
//    @Binding var isDisabled: Bool
//    
//    private let model: AuthorizationOfferModel?
//    private let mockArray: [MockInfoItem]
//    private let currentTariff: String
//    private let completion: ((EventsTitles?) -> Void)
//    
//    public init(
//        showNextScreen: Binding<Bool>,
//        isDisabled: Binding<Bool>,
//        model: AuthorizationOfferModel?,
//        currentTariff: String,
//        isSubscriptionActive: Binding<Bool>,
//        completion: @escaping ((EventsTitles?) -> Void)
//    ) {
//        self.model = model
//        var fullArray: [MockInfoItem] = []
//        self.currentTariff = currentTariff
//        self._showNextScreen = showNextScreen
//        self._isSubscriptionActive = isSubscriptionActive
//        self.completion = completion
//        self._isDisabled = isDisabled
//        
//        model?.prtd?.issues?.forEach({ issue in
//            fullArray.append(.init(title: issue.name ?? "", subTitle: issue.status, imgUrl: issue.icon))
//        })
//        
//        mockArray = fullArray
//    }
//    
//    public var body: some View {
//        if !NFX.sharedInstance().isShow {
//            myView()
//                .protectScreenshot()
//                .ignoresSafeArea(.all)
//                .fullScreenCover(isPresented: model?.gap?.orderIndex == 0 ? $showNextScreen : .constant(false)) {
//                    FastRequestResultView(isDisabled: $isDisabled, isSubscriptionActive: $isSubscriptionActive, model: model, currentTariff: currentTariff, completion: completion)
//                        .onAppear {
//                            completion(.specialOffer2Hide)
//                        }
//                }
//                .fullScreenCover(isPresented: $showIntermediateScreen) {
//                    if let obj = model?.gap?.objecs[(model?.gap?.orderIndex ?? 1) - 1] {
//                        InterScreen(showNextScreen: $showNextScreen, showDeepScreen: .constant(false), isSubscriptionActive: $isSubscriptionActive, isDisabled: $isDisabled, model: model, currentTariff: currentTariff, scanObject: obj, scanTitle: model?.gap?.title ?? "", secureScreenNumber: model?.gap?.orderIndex ?? 0, completion: completion)
//                    }
//                }
//                .onAppear {
//                    completion(.specialOffer2ShowNext)
//                    ScreenShield.shared.protectFromScreenRecording()
//                }
//        } else {
//            myView()
//                .fullScreenCover(isPresented: model?.gap?.orderIndex == 0 ? $showNextScreen : .constant(false)) {
//                    FastRequestResultView(isDisabled: $isDisabled, isSubscriptionActive: $isSubscriptionActive, model: model, currentTariff: currentTariff, completion: completion)
//                        .onAppear {
//                            completion(.specialOffer2Hide)
//                        }
//                }
//                .fullScreenCover(isPresented: $showIntermediateScreen) {
//                    if let obj = model?.gap?.objecs[(model?.gap?.orderIndex ?? 1) - 1] {
//                        InterScreen(showNextScreen: $showNextScreen, showDeepScreen: .constant(false), isSubscriptionActive: $isSubscriptionActive, isDisabled: $isDisabled, model: model, currentTariff: currentTariff, scanObject: obj, scanTitle: model?.gap?.title ?? "", secureScreenNumber: model?.gap?.orderIndex ?? 0, completion: completion)
//                    }
//                }
//                .onAppear {
//                    completion(.specialOffer2ShowNext)
//                }
//        }
//    }
//    
//    @MainActor
//    private func myView() -> some View {
//        ZStack {
//            VStack {
//                KFImage(URL(string: model?.prtd?.icon ?? ""))
//                    .setProcessor(SVGImgProcessor())
//                    .resizable()
//                    .frame(width: 110, height: 110)
//                    .padding(.top)
//                
//                Text(model?.prtd?.title ?? "")
//                    .font(.system(size: 24, weight: .bold, design: .default))
//                    .foregroundStyle(.white)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(2)
//                
//                Text(model?.prtd?.ip ?? "")
//                    .font(.system(size: 12, weight: .medium, design: .default))
//                    .foregroundStyle(Color(red: 156/255, green: 156/255, blue: 156/255))
//                    .multilineTextAlignment(.center)
//                
//                HStack(spacing: 17) {
//                    KFImage(URL(string: model?.modalIcon ?? ""))
//                        .setProcessor(SVGImgProcessor())
//                        .resizable()
//                        .frame(width: 63, height: 64)
//                        .padding(.leading, 15)
//                        .padding(.vertical, 10)
//                    
//                    VStack(alignment: .leading ,spacing: 0) {
//                        Text(model?.prtd?.b_title ?? "")
//                            .font(.system(size: 18, weight: .medium, design: .default))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.leading)
//                        
//                        Text(model?.prtd?.b_subtitle ?? "")
//                            .font(.system(size: 10, weight: .medium, design: .default))
//                            .foregroundColor(Color(red: 156/255, green: 156/255, blue: 156/255))
//                            .multilineTextAlignment(.leading)
//                            .padding(.bottom, 6)
//                        
//                        Text(model?.prtd?.b_status ?? "")
//                            .font(.system(size: 10, weight: .bold, design: .default))
//                            .foregroundColor(.red)
//                            .multilineTextAlignment(.leading)
//                            .padding(.horizontal, 5)
//                            .padding(.vertical, 5)
//                            .background(
//                                RoundedRectangle(cornerRadius: 5)
//                                    .stroke(Color.red, lineWidth: 1.5)
//                            )
//                    }
//                    
//                    Spacer()
//                }
//                .background(
//                    RoundedRectangle(cornerRadius: 15)
//                        .fill(Color(red: 54/255, green: 54/255, blue: 54/255))
//                )
//                .padding(.horizontal)
//                .padding(.top)
//                
//                List {
//                    ForEach(mockArray.indices, id: \.self) { index in
//                        let item = mockArray[index]
//                        
//                        VStack(spacing: 0) {
//                            HStack(alignment: .center) {
//                                KFImage(URL(string: item.imgUrl ?? ""))
//                                    .setProcessor(SVGImgProcessor())
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                
//                                Text(item.title)
//                                    .font(.system(size: 15, weight: .medium, design: .default))
//                                    .foregroundColor(.white)
//                                
//                                Spacer()
//                                
//                                Text(item.subTitle ?? "")
//                                    .font(.system(size: 12, weight: .medium, design: .default))
//                                    .foregroundColor(.red)
//                            }
//                            .padding(.bottom, 5)
//                            
//                            if index != mockArray.count - 1 {
//                                Divider()
//                                    .background(Color(red: 156/255, green: 156/255, blue: 156/255))
//                            }
//                            
//                        }
//                        .listRowSeparator(.hidden)
//                        .listRowInsets(.init(top: 15, leading: 10, bottom: 10, trailing: 10))
//                        
//                    }
//                    .listRowBackground(Color(red: 54/255, green: 54/255, blue: 54/255))
//                }
//                .background(Color.clear)
//                .scrollContentBackground(.hidden)
//                .scrollIndicators(.never)
//                .padding(.vertical, 0)
//                .frame(maxHeight: 250)
//                .scrollDisabled(true)
//                
//                
//                Text(model?.prtd?.subtitle ?? "")
//                    .font(.system(size: 12, weight: .bold, design: .default))
//                    .foregroundStyle(.white)
//                    .multilineTextAlignment(.center)
//                    .padding(.vertical)
//                
//                Spacer()
//            }
//            .background(.black)
//            .navigationBarHidden(true)
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        completion(.specialOffer2Notification)
//                        showNotification = true
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            showNotification = false
//                        }
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        completion(.specialOffer2Main)
//                        showAlert = true
//                    }
//                }
//            }
//            
//            VStack {
//                if showNotification {
//                    CustomTopNotificationView(model: model, show: $showNotification)
//                        .transition(.move(edge: .top))
//                        .zIndex(1)
//                }
//                Spacer()
//            }
//            .edgesIgnoringSafeArea(.top)
//            
//            if showAlert {
//                CustomCenterAlertView(model: model, showAlert: $showAlert, isDisabled: $isDisabled) {
//                    completion(.specialOffer2ActionButton)
//                    if NFX.sharedInstance().isShowIntermediate {
//                        showIntermediateScreen = true
//                    } else {
//                        completion(nil)
//                    }
//                }
//                .transition(.scale)
//            }
//        }
//    }
//}
