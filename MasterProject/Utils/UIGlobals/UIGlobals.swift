
import UIKit

// MARK: - UIGLobals
struct UIGlobals {
    static let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*.])(?=.*[0-9]).{8,}$"
    static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    // MARK: REGEX
    static func isValidPasswordRegex(password: String) -> Bool {
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", UIGlobals.passwordRegex)
        return passwordCheck.evaluate(with: password)
    }
    
    static func isValidEmailRegex (email: String) -> Bool {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", UIGlobals.emailRegEx)
        return emailPred.evaluate(with: email)
    }
}


// MARK: - TextFields

// Defines keyboard type
enum FieldType {
    case phone
    case normal
}

// Indicates if textfield is being edited
enum EditingType {
    case editing
    case normal
}

// Indicates the field to which the text field is associated
enum TextIDField {
    case email
    case password
    case passwordConfirm
    case firstName
    case lastName
    case birthday
    case city
    case country
}

// MARK: - Notification Banner
struct BannerLeftView {
    static let sad = UIImageView(image: UIImage(named: "sad"))
    static let happy = UIImageView(image: UIImage(named: "happy"))
}
