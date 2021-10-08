
import Foundation
import UIKit

public class PlaceholderMightyTextField: MightyTextField {
    
    public var textChangedCallback: ((String?) -> Void)?
    public var textDidEndEditing: ((String?) -> Void)?
    public var acceptableCharacters: CharacterSet?
    public var placeholderColor: UIColor?
    
    private let placeholderLabel = UILabel()
    
    override public var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.text = attributedPlaceholder?.string
        }
    }
    
    @IBInspectable
    public var placeholderFontSize: CGFloat = 12 {
        didSet {
            placeholderLabel.font = placeholderLabel.font.withSize(placeholderFontSize)
        }
    }
    
    override public var text: String? {
        didSet {
            textFieldValueDidChange(self)
        }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet {
            textFieldValueDidChange(self)
        }
    }
    
    override public var accessoryView: UIView {
        didSet {
            super.accessoryView = accessoryView
            
            setNeedsLayout()
            layoutIfNeeded()
            
            if let button = accessoryView as? UIButton {
                var buttonSize = bounds.height
                
                if let image = button.imageView?.image {
                    buttonSize = image.size.width
                }
                
                button.bounds = CGRect(origin: button.bounds.origin, size: CGSize(width: buttonSize, height: bounds.height))
            }
            
            let textFieldTextMidPosition = bounds.height / 2 + placeholderFontSize / 2
            
            accessoryView.center = CGPoint(x: bounds.maxX - accessoryView.bounds.maxX / 2, y: textFieldTextMidPosition)
            accessoryView.autoresizingMask = .flexibleLeftMargin
            addSubview(accessoryView)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        placeholderLabel.font = placeholderLabel.font.withSize(placeholderFontSize)
        placeholderLabel.textColor = super.tintColor
        clipsToBounds = false
        placeholderLabel.alpha = 0
        movePlaceholderToBottom()
        
        addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldValueDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        
        placeholderLabel.textColor = super.tintColor
    }
    
    override public func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        return true
    }
    
    override public func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        return true
    }
    
    private func movePlaceholderToTop() {
        let placeholderFrame = CGRect(x: bounds.minX + horizontalTextInset, y: bounds.minY + placeholderFontSize / 2.5, width: bounds.width, height: placeholderFontSize + 1)
        placeholderLabel.frame = placeholderFrame
    }
    
    private func movePlaceholderToBottom() {
        let placeholderFrame = CGRect(x: bounds.minX, y: bounds.midY, width: bounds.width, height: placeholderFontSize)
        placeholderLabel.frame = placeholderFrame
        if placeholderColor != nil {
            placeholderLabel.textColor = placeholderColor
        } else {
            placeholderLabel.textColor = super.tintColor
        }
        
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let accesoryViewWidth = accessoryView.bounds.width
        return CGRect(x: horizontalTextInset, y: bounds.origin.y + placeholderFontSize / 2, width: bounds.width - horizontalTextInset - accesoryViewWidth, height: bounds.height)
    }
    
    @objc public func textFieldValueDidChange(_ textField: UITextField) {
        if let text = text, text.count > 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.placeholderLabel.alpha = 1
                self.movePlaceholderToTop()
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.placeholderLabel.alpha = 0
                self.movePlaceholderToBottom()
            })
        }
        
        textChangedCallback?(text)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textDidEndEditing?(textField.text)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let acceptableCharacters = acceptableCharacters else {
            return true
        }
        
        let filtered = string.components(separatedBy: acceptableCharacters.inverted).joined(separator: "")
        
        return string == filtered
    }
}
