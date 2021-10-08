
import UIKit
import NotificationBannerSwift

open class ViewController<Presenter: PresenterProtocol>: UIViewController, StoryboardInstantiatable {

    @IBOutlet public weak var keyboardLayout: NSLayoutConstraint?

    public var presenter: Presenter!
    var loadingView: UIView?

    public var loading: Bool = false {
        didSet {
            loadingView?.isHidden = !loading
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override open func viewDidLoad() {
        setNeedsStatusBarAppearanceUpdate()
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        loadingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        loadingView?.addSubview(activityView)
        activityView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        activityView.startAnimating()
        loadingView?.isHidden = true

        view.addSubview(loadingView!)

        presenter.viewDidLoad()
        super.viewDidLoad()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        switch notification.name {
        case UIResponder.keyboardWillShowNotification: keyboardWillAppear(notification: notification)
        case UIResponder.keyboardWillHideNotification: keyboardWillDisappear(notification: notification)
        case UIResponder.keyboardDidShowNotification: keyboardDidAppear(notification: notification)
        default: break; }

        layoutKeyboard(notification: notification)
    }

    public func layoutKeyboard(notification: NSNotification) {

        guard let keyboardLayout = keyboardLayout else { return }
        guard let userInfo = notification.userInfo else { return }

        guard let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        guard let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(rawAnimationCurve))

        keyboardLayout.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY

        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)

    }

    func keyboardDidAppear(notification: NSNotification) { }

    open func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]as? CGRect
            else { return }
        keyboardWillAppear(keyboardRect: view.convert(keyboardEndFrame, from: view.window), userInfo: userInfo)
    }

    open func keyboardWillAppear(keyboardRect: CGRect, userInfo: [AnyHashable: Any]) {

    }

    open func keyboardWillDisappear(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]as? CGRect
            else { return }
        keyboardWillDisappear(keyboardRect: view.convert(keyboardEndFrame, from: view.window), userInfo: userInfo)
    }

    open func keyboardWillDisappear(keyboardRect: CGRect, userInfo: [AnyHashable: Any]) {

    }

}


/*public extension ViewController {
    
    public func showMessage(message: String,title: String? = nil,dismiss: Bool = false,completion: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (action) in
            completion?()
            if dismiss && self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
            }else if dismiss{
                self.navigationController?.popViewController(animated: true)
            }
        }))
        loading = false
        present(alert, animated: true, completion: nil)
    }
    
    public func showError(message: String,title: String? = "Error",dismiss: Bool = false,completion: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (action) in
            completion?()
            if dismiss && self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
            }else if dismiss{
                self.navigationController?.popViewController(animated: true)
            }
        }))
        loading = false
        present(alert, animated: true, completion: nil)
    }
    
}*/

public extension ViewController {

    static func load(presenter: Presenter) -> Self {
        let vc = instantiate()
        vc.presenter = presenter
        return vc
    }

    func showError(message: String, title: String? = "Error", dismiss: Bool = false, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completion?()
            if dismiss && self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
            } else if dismiss {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        loading = false
        present(alert, animated: true, completion: nil)
    }

    func showSpinner() {
        SwiftSpinner.show("")
    }
    
    func hideSpinner() {
        SwiftSpinner.hide()
    }
    
    func showErrorNotification(with title: String, message: String?) {
        let banner = GrowingNotificationBanner(title: "Ups! \(title)", subtitle: message, leftView: BannerLeftView.sad, style: .danger)
        banner.show()
    }
    
    func showSuccessNotification(with title: String, message: String?) {
        let banner = GrowingNotificationBanner(title: title, subtitle: message, leftView: BannerLeftView.happy, style: .success)
        banner.show()
    }
    
    func statusBarColorChange(color: UIColor) {

        if #available(iOS 13.0, *) {

            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = color
                statusBar.tag = 100
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)

        } else {

                let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                statusBar?.backgroundColor = color

            }
        }

}


