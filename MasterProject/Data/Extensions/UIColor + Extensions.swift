
import UIKit

enum AssetsColor : String {
    case background
    case imperialRed
    case wineRed
    case wineMedium
    case platinum
    case platinumLight
    case accent
    case shadow
    case grayDisabled
    case wineMode
    case jetMedium
    case imperialMedium
    case lightBackground
    case barFontColor
    case defaultFont
    case titleLogo
    case accentSolid
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
