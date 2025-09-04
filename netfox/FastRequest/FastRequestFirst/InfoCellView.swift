

import Foundation
import SwiftUI

struct InfoCellView: View {
    let title: String
    let iconName: ImageResource
    
    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.leading, 10)
                .padding(.vertical, 10)
            
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.trailing, 30)
            
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

public struct EnterModel: Codable {
    public var token: String
    public var screen: Int?
    public var screen2: Int?
    public var offer: AuthorizationOfferObject?
    
    enum CodingKeys: String, CodingKey {
        case token
        case screen, screen2
        case offer = "specialize"
    }
}

public struct AuthorizationOfferObject: Codable {
    public var isActive: Bool
    public var data: AuthorizationOfferModel?
    
    enum CodingKeys: String, CodingKey {
        case isActive = "is_active"
        case data
    }
}

public struct AuthorizationOfferModel: Codable {
    var imageUrl: String
    var title: String
    var subtitle: String
    var benefitTitle: String
    var benefitDescriptions: [String]
    var btnTitle: String
    public var stTitle: String
    public var stSubtitle: String
    var poText: String
    var bzz: Bool?
    var settings: [String]?
    var settingsIcon: String?
    var settingsAnimation: String?
    var settingsTitle: String?
    var settingsBtnTitle: String?
    var modalTitle: String?
    var modalText: String?
    var modalIcon: String?
    var modalBtn: String?
    var pushIcon: String?
    var pushTitle: String?
    var pushText: String?
    var homeTitle: String?
    var homeSub: String?
    var homeIcon: String?
    public var scn: ScnModel?
    var prtd: PrtdModel?
    var objectTwo: ObjectTwo?
    public var gap: Gap?
    var sheet: SheetObject?
    public var storage: StorageModel
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case title
        case subtitle
        case benefitTitle = "benefit_title"
        case benefitDescriptions = "benefit_descriptions"
        case btnTitle = "btn_title"
        case stTitle = "st_title1"
        case stSubtitle  = "st_title2"
        case poText = "po_text"
        case bzz
        case settingsAnimation = "settings_anime"
        case settings
        case settingsTitle = "settings_title"
        case settingsBtnTitle = "settings_btn"
        case settingsIcon = "settings_icon"
        case modalTitle = "modal_title"
        case modalText = "modal_text"
        case modalIcon = "modal_icon"
        case modalBtn = "modal_btn"
        case pushIcon = "push_icon"
        case pushTitle = "push_title"
        case pushText = "push_text"
        case homeTitle = "home_title"
        case homeSub = "home_sub"
        case homeIcon = "home_icon"
        case scn, prtd, gap, sheet
        case objectTwo = "object_2"
        case storage
    }
}

public struct ScnModel: Codable {
    var title_proc            : String?
    var subtitle_proc        : String?
    var title_anim_proc        : String?
    var subtitle_anim_proc    : String?
    var title_disable            : String?
    var title_on            : String?
    var title_compl            : String?
    var subtitle_compl        : String?
    var title_anim_compl    : String?
    var subtitle_anim_compl    : String?
    var title_unp            : String?
    var subtitle_unp        : String?
    var subtitle_unp_paid: String?
    var title_anim_unp        : String?
    var subtitle_anim_unp    : String?
    var banner_title        : String?
    var banner_subtitle        : String?
    var banner_icon            : String?
    var banner_icon_unp        : String?
    var btn                    : String?
    var anim_scn            : String?
    var anim_done            : String?
    var anim_scn_unp        : String?
    var anim_done_unp        : String?
    var rr_title            : String?
    var rr_subtitle            : String?
    public var push_title: String?
    public var push_content: String?
    var stats: Stats?
    var features            : [Features]?
    
    struct Features: Codable {
        var name    : String?
        var g_status: String?
        var b_status: String?
    }
    
    struct Stats: Codable {
        var cls    : String?
        var statScnIcon5: String?
        var statScnIcon4: String?
        var statBtnSubtitle    : String?
        var statScnIcon3: String?
        var statScnCount5: String?
        var statScnIcon2    : String?
        var statScnTitle1: String?
        var statImg: String?
        var statScnText5: String?
        var statBtnArrowImg: String?
        var statScnText4: String?
        var statScnCount4: String?
        var statScnText3: String?
        var statScnText2: String?
        var statScnCount3: String?
        var statScnSubtitle1: String?
        var statBtnTitle: String?
        var statScnImg1: String?
        var statScnCount2: String?
    }
}

struct ObjectTwo: Codable {
    let center: Center
    let dark_blue: DarkBlue?
    let description: Description
    
    struct Center: Codable {
        var title    : String?
        var subtitle: String?
        var footer_text: String?
        var res_color: String?
        var items: [Items]
        
        struct Items: Codable {
            let name: String?
            let res: String?
        }
    }
    
    struct DarkBlue: Codable {
        var subtitle: String?
        var small_img: String?
        var title: String?
        var al_title: String?
        var al_subtitle: String?
        var al_subtitle_no_bio: String?
        var main_img: String?
        var btn_title: String?
        var footer_text: String?
    }
    
    struct Description: Codable {
        var btn_subtitle_color: String?
        var subtitle: String?
        var items_title: String?
        var title: String?
        var btn_subtitle: String?
        var main_img: String?
        var btn_title: String?
        var items: [String]?
    }
}

struct PrtdModel: Codable{
    var icon        : String?
    var title        : String?
    var ip            : String?
    var subtitle    : String?
    var b_title        : String?
    var b_subtitle    : String?
    var b_status    : String?
    var modal_title    : String?
    var modal_text    : String?
    var issues        : [IssuesObj]?
    
    struct IssuesObj: Codable {
        var icon    : String?
        var name: String?
        var status: String?
    }
}

public struct Gap: Codable {
    public let orderIndex: Int?
    public let title: String
    let titleTwo: String
    let titleDeep: String?
    public let objecs: [Objec]
    
    enum CodingKeys: String, CodingKey {
        case titleTwo = "title_two"
        case orderIndex = "order_index"
        case titleDeep = "title_deep"
        case title, objecs
    }
}

struct LevelOne: Codable {
    let scr_first: ScreenFirst
    let scr_second: ScreenSecond
    let scr_third: ScreenThird
}

struct LevelTwo: Codable {
    let scr_first: ScreenFirstLevel
    let scr_second: ScreenSecondLevel
}

struct ScreenFirstLevel: Codable {
    let title: String
    let description: String
    let item: String
    let scr_btn: String
    let scr_img: String
}

struct ScreenSecondLevel: Codable {
    let title: String
    let description: String
    let scr_img: String
    let scn_items: [String]
    let scr_btn: String
}

struct ScreenFirst: Codable {
    let title: String
    let description: String
    let item: String
    let scr_btn: String
    let anim_lot: String
    let item_icon: String
}

struct ScreenSecond: Codable {
    let titles: [String]
    let anim_lot: String
}

struct ScreenThird: Codable {
    let title_icon: String
    let title: String
    let description: String
    let cart: Cart
}

struct Cart: Codable {
    let title_icon: String
    let title: String
    let subtitle: String
    let items: [CartItem]
    let btn: String
}

struct CartItem: Codable {
    let icon: String
    let text: String
}

public struct Objec: Codable {
    let prgrsTitle: String
    let strigs: [Strig]
    let strigs_hand_start: [Strig]?
    let messIcon, messTlt: String
    let subMessTlt, subMessTxt: String?
    let messSbtlt: String?
    let messBtn: String
    let messTltPrc, messTltCmpl, subMessTxtOne, subMessTxtTwo: String?
    let subMessTxtThree, strigsTlt, strigsSubtlt, strigsRes: String?
    let messTltRed: [String]?
    
    enum CodingKeys: String, CodingKey {
        case prgrsTitle = "prgrs_title"
        case strigs, strigs_hand_start
        case messIcon = "mess_icon"
        case messTlt = "mess_tlt"
        case subMessTlt = "sub_mess_tlt"
        case subMessTxt = "sub_mess_txt"
        case messSbtlt = "mess_sbtlt"
        case messBtn = "mess_btn"
        case messTltPrc = "mess_tlt_prc"
        case messTltCmpl = "mess_tlt_cmpl"
        case subMessTxtOne = "sub_mess_txt_one"
        case subMessTxtTwo = "sub_mess_txt_two"
        case subMessTxtThree = "sub_mess_txt_three"
        case strigsTlt = "strigs_tlt"
        case strigsSubtlt = "strigs_subtlt"
        case strigsRes = "strigs_res"
        case messTltRed = "mess_tlt_red"
    }
}

struct Strig: Codable {
    let name: String
    let color: String?
    let icn: String?
}

struct SheetObject: Codable {
    let title_1:String
    let title_2:String
    let subtitle:String
    let status_1:String
    let status_2:String
    let status_3:String
    let status_4:String
    let btn_1:String
    let btn_2:String
    let inf_1:String
    let inf_2:String
    let inf_3:String
    let ic_1:String
    let ic_2:String
    let ic_3:String
    let ic_4:String
    let ic_5:String
}

public struct StorageModel: Codable {
    let title: String?
    let subtitle: String?
    let subtitle2: String?
    let subtitle3: String?
    let subtitle4: String?
    let searchText: String?
    let sizeText: String?
    let topBox: TopBox?
    let infoBoxes: [InfoBox]?
    let firstAlert: StorageAlert?
    let secondAlert: StorageAlert?
    let lastScIcon: String?
    let lastScTitle: String?
    let lastScSubtitle: String?
    let lastScButton: String?
    
    enum CodingKeys: String, CodingKey {
        case subtitle4, subtitle
        case searchText = "search_text"
        case firstAlert = "first_alert"
        case secondAlert = "second_alert"
        case subtitle2, title
        case lastScIcon = "last_sc_icon"
        case lastScTitle = "last_sc_title"
        case sizeText = "size_text"
        case lastScSubtitle = "last_sc_subtitle"
        case subtitle3
        case topBox = "top_box"
        case infoBoxes = "info_boxes"
        case lastScButton = "last_sc_button"
    }
}

// MARK: - Alert
public struct StorageAlert: Codable {
    let icon: String?
    let title: String?
    let subtitle: String?
    let button: String?
}

// MARK: - InfoBox
public struct InfoBox: Codable {
    let icon: String?
    let text: String?
}

// MARK: - TopBox
public struct TopBox: Codable {
    let title: String
    let subtitle1: String?
    let subtitle2: String?
    let subtitle3: String?
    let subtitle4: String?
    let subtitle5: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle2 = "Subtitle2"
        case subtitle3 = "Subtitle3"
        case subtitle4 = "Subtitle4"
        case subtitle1 = "Subtitle1"
        case subtitle5 = "Subtitle5"
    }
}
