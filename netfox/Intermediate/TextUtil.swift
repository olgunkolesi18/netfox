import Foundation
import SwiftUI

struct TextUtil {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    func adaptiveFont(textSize: TextSize, isIpad: Bool) -> Font {
        return .system(
            size: textSize.getTextSize(
                isIpad: isIpad
            )
        )
    }
}

enum TextSize {
    case scanningTextSize
    case scanString
}

extension TextSize {
    func getTextSize(isIpad: Bool) -> CGFloat {
        return switch self {
        case .scanningTextSize:
            isIpad ? 18 : 13
        case .scanString:
            isIpad ? 18 : 15
        }
    }
}
