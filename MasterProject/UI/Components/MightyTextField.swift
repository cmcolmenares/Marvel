
import UIKit

@IBDesignable
public class MightyTextField: UITextField, UITextFieldDelegate {
    
    let bottomLine = UIView()
	
	@IBInspectable
    override public var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
        }
    }
    
    public var hideBottomLine: Bool = false {
        didSet {
            if hideBottomLine {
                bottomLine.removeFromSuperview()
            } else {
                addSubview(bottomLine)
            }
        }
    }
    
    @IBInspectable
    public var horizontalTextInset: CGFloat = 0
    
    @IBInspectable
    public var horizontalIconInset: CGFloat = 0
    
    @IBInspectable
    public var icon: UIImage {
        willSet {
            if subviews.contains(iconImageView) {
                iconImageView.removeFromSuperview()
            }
        }
        didSet {
            iconImageView.image = icon
            let origin = CGPoint(x: horizontalIconInset, y: bounds.maxY / 2 - icon.size.height / 2)
            iconImageView.frame = CGRect(origin: origin, size: icon.size)
            addSubview(iconImageView)
        }
    }
    
    public var accessoryView = UIView() {
        willSet {
            if subviews.contains(accessoryView) {
                accessoryView.removeFromSuperview()
            }
        }
        
        didSet {
            layoutIfNeeded()
            
            if let button = accessoryView as? UIButton {
                button.bounds = CGRect(origin: button.bounds.origin, size: CGSize(width: min(44, bounds.width), height: min(44, bounds.height)))
            }
            
            accessoryView.center = CGPoint(x: bounds.maxX - accessoryView.bounds.maxX / 2, y: bounds.midY)
            accessoryView.autoresizingMask = .flexibleLeftMargin
            addSubview(accessoryView)
        }
    }
    
    override public var isSecureTextEntry: Bool {
        didSet {
            if !isSecureTextEntry {
                attributedText = NSAttributedString(string: text!, attributes: [NSAttributedString.Key.font: font!])
            }
        }
    }
    
    private var iconImageView = UIImageView()
	
	weak var nextControl: UIResponder? = nil
	
    override public init(frame: CGRect) {
        icon = UIImage()
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        icon = UIImage()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
		delegate = self
		
        borderStyle = .none
        tintColor = superview?.tintColor
        
        let onePixelHeight = 1.0 / UIScreen.main.scale
        bottomLine.frame = CGRect(x: 0, y: bounds.height - onePixelHeight, width: bounds.width, height: onePixelHeight)
		bottomLine.backgroundColor = tintColor
		bottomLine.translatesAutoresizingMaskIntoConstraints = true
        bottomLine.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
		addSubview(bottomLine)
    }
	
	private var currentPlaceholderColor: UIColor?
	private var placeholderAlphaComponent: CGFloat = 0.3
	
	public var shouldShowInputToolbar = false
	
	private lazy var inputToolbar: UIToolbar = {
		var toolbar = UIToolbar()
		toolbar.sizeToFit()
		
		let nextButton = UIBarButtonItem(title: "Siguiente", style: .plain, target: self, action: #selector(inputToolbarNextButtonTap))
		let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(inputToolbarDoneButtonTap))
		
		toolbar.setItems([nextButton, flexibleSpaceButton, doneButton], animated: false)
		
		return toolbar
	}()
	
    public func setPlaceholder(_ placeholderText: String, color: UIColor, alpha: CGFloat) {
		currentPlaceholderColor = color
		placeholderAlphaComponent = alpha

        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: color.withAlphaComponent(alpha)])
    }
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		if frame.height == 0 {
			if let placeholder = placeholder {
				setPlaceholder(placeholder, color: tintColor, alpha: 0)
			}
			
            bottomLine.isHidden = true
            textColor = textColor?.withAlphaComponent(0)
		} else {
			if let placeholder = placeholder {
				setPlaceholder(placeholder, color: tintColor, alpha: placeholderAlphaComponent)
			}
			
            bottomLine.isHidden = false
            textColor = textColor?.withAlphaComponent(1)
		}
	}
	
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        
        bottomLine.backgroundColor = tintColor
        iconImageView.tintColor = tintColor
        textColor = tintColor
        accessoryView.tintColor = tintColor
        
        guard let placeholder = placeholder else {
            return
        }
		
		setPlaceholder(placeholder, color: tintColor, alpha: placeholderAlphaComponent)
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
		
		commonInit()
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let accesoryViewWidth = accessoryView.bounds.width
        return CGRect(x: horizontalTextInset, y: bounds.origin.y, width: bounds.width - horizontalTextInset - accesoryViewWidth, height: bounds.height)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override public func borderRect(forBounds bounds: CGRect) -> CGRect {
        let border = super.borderRect(forBounds: bounds)
        return border
    }

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let nextTextField = (textField as! MightyTextField).nextControl {
			nextTextField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		
		return true
	}
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if shouldShowInputToolbar {
			textField.inputAccessoryView = inputToolbar
			inputToolbar.items?[0].isEnabled = nextControl != nil
		}
		
		return true
	}
	
	@objc func inputToolbarNextButtonTap() {
		nextControl?.becomeFirstResponder()
	}
	
	@objc func inputToolbarDoneButtonTap() {
		endEditing(true)
	}
}
