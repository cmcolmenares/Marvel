
import UIKit

public protocol NibInstantiatable: UIView {
    static var NibName: String { get }
}

public extension NibInstantiatable{
    
    static var NibName: String { return String(describing: self) }
    
    static func instantiate() -> Self {
        return instantiateWithName(name: NibName,owner: self)
    }

    static func instantiateWithName(name: String, owner: AnyObject? = nil) -> Self {
        let nib = UINib(nibName: name, bundle: Bundle(for: Self.self))
        
        guard let view = nib.instantiate(withOwner: owner, options: nil).first else {
            fatalError("failed to load \(name) nib file")
        }
        
        return view as! Self
    }
    
}

public protocol StoryboardInstantiatable: UIViewController {
    static var storyboardName: String { get }
}

public extension StoryboardInstantiatable {
    
    static var storyboardName: String { return String(describing: self) }
    
    static func instantiate(storyboard: String = Self.storyboardName,name: String = Self.storyboardName) -> Self {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle(for: Self.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: name) as? Self else{
            fatalError("failed to load \(name) storyboard file.")
        }
        return viewController
    }
    
}

protocol Identifiable {
    static var identifier: String { get }
}
extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
protocol NibLoadable: Identifiable {
    static var nibName: String { get }
}
extension NibLoadable {
    @nonobjc static var nibName: String {
        return String(describing: self)
    }
}
extension UIView {
    static func loadFromNib<T: NibLoadable>(ofType _: T.Type) -> T {
        guard let nibViews = Bundle.main.loadNibNamed(T.nibName, owner: nil, options: nil) else {
            fatalError("Could not instantiate view from nib file.")
        }
        
        for view in nibViews {
            if let typedView = view as? T {
                return typedView
            }
        }
        fatalError("Could not instantiate view from nib file.")
    }
}
